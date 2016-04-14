-module(hackney_pool_debug_http_client).
-author("Erwan Martin <public@fzwte.net>").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
  ok = hackney_pool:start_pool(debug_pool, [{timeout, 150000}, {max_connections, 2}]),
  gen_server:cast(self(), start_workers),
  {ok, #state{}}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(start_workers, State) ->
  %% make sure the hosts are resolvable first.
  hackney_pool_debug_client_worker_sup:start_worker(<<"http://some-host.example.com:8046/test/hackney_pool_debug_http_func/long_stuff/params">>, <<"ok">>),
  hackney_pool_debug_client_worker_sup:start_worker(<<"http://some-host.example.com:8046/test/hackney_pool_debug_http_func/long_stuff/params">>, <<"ok">>),
  hackney_pool_debug_client_worker_sup:start_worker(<<"http://some-other-host.example.com:8046/test/hackney_pool_debug_http_func/echo/you_re_the_one_that_echoes">>, <<"you_re_the_one_that_echoes">>),
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, #state{}) ->
  ok = hackney_pool:stop_pool(debug_pool).

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
