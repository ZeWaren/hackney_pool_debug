-module(hackney_pool_debug_client_worker_sup).
-author("Erwan Martin <public@fzwte.net>").

-behaviour(supervisor).

%% API
-export([start_link/0, start_worker/2]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_worker(URL, ExpectedResult) ->
  supervisor:start_child(hackney_pool_debug_client_worker_sup, [URL, ExpectedResult]).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
  ChildSpec = #{
    id => hackney_pool_debug_http_client_worker,
    start => {hackney_pool_debug_http_client_worker, start_link, []},
    restart => temporary
  },

  Strategy = #{strategy => simple_one_for_one, intensity => 5, period => 10},
  {ok, {Strategy, [ChildSpec]}}.

