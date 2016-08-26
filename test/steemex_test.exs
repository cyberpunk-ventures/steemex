defmodule SteemexTest do
  use ExUnit.Case, async: true
  doctest Steemex
  @db_api "database_api"

  setup_all context do
    Steemex.IdAgent.start_link
    handler_fn = fn pid ->
      fn id, call_params, data  ->
        send(pid, {id, call_params, data})
      end
    end
    %{handler_fn: handler_fn, steem_url: System.get_env("STEEM_URL")}
  end

  test "get_dynamic_global_properties call succeeds", context do
    handler_fn = context.handler_fn.(self)
    Steemex.WS.start_link(handler_fn, context.steem_url)

    params = [@db_api, "get_dynamic_global_properties", []]
    Steemex.call(params)

    assert_receive {_, ^params, %{"id" => _, "result" => _}}, 5_000
  end

  test "get_content", context do
    handler_fn = context.handler_fn.(self)
    Steemex.WS.start_link(handler_fn, context.steem_url)
    Steemex.get_content("xeroc", "piston-web-first-open-source-steem-gui---searching-for-alpha-testers")
    params = [@db_api, "get_content", ["xeroc", "piston-web-first-open-source-steem-gui---searching-for-alpha-testers"]]

    assert_receive {_, ^params, %{"id" => _, "result" => %{"author" => _, "permlink" => _}}}, 5_000
  end

  test "get_block", context do
    handler_fn = context.handler_fn.(self)
    Steemex.WS.start_link(handler_fn, context.steem_url)
    Steemex.get_block(3_141_592)
    params = [@db_api, "get_block", [3_141_592]]

    assert_receive {_, ^params, %{"id" => _, "result" => %{"previous" => _, "transactions" => _}}}, 5_000
  end

end
