-module(hackney_pool_debug_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    S = ?CHILD(hackney_pool_debug_http_server, worker),
    C = ?CHILD(hackney_pool_debug_http_client, worker),
    CS = ?CHILD(hackney_pool_debug_client_worker_sup, supervisor),
    {ok, { {one_for_one, 5, 10}, [CS, S, C]} }.

