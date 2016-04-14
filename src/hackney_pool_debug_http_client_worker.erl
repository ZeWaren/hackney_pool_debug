-module(hackney_pool_debug_http_client_worker).
-author("Erwan Martin <public@fzwte.net>").

-behaviour(gen_server).

%% API
-export([start_link/2]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {url, expected_result}).

%%%===================================================================
%%% API
%%%===================================================================

start_link(URL, ExpectedResult) ->
  gen_server:start_link(?MODULE, [URL, ExpectedResult], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([URL, ExpectedResult]) ->
  gen_server:cast(self(), work),
  {ok, #state{url=URL, expected_result=ExpectedResult}}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(work, #state{url=URL,expected_result=ExpectedResult}=State) ->
  Method = get,
  Headers = [],
  Payload = <<>>,
  HOptions = [{with_body, true}, {pool, debug_pool}, {recv_timeout, 15000}],
  {ok, 200, _RespHeaders, ExpectedResult} = hackney:request(Method, URL, Headers, Payload, HOptions),
  {stop, normal, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("Worker completed successfully.~n"),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
