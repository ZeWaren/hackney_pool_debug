-module(hackney_pool_debug_http_server).
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

-record(state, {pid}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
  {ok, Pid} = inets:start(httpd, [
    {modules, [mod_esi]},
    {port, 8046},
    {server_name ,"hackney_pool_debug_http_server"},
    {server_root,"/some/where/hackney_pool_debug"},
    {document_root,"/some/where/hackney_pool_debug/priv"},
    {bind_address, "127.0.0.1"},
    {erl_script_alias, {"/test", [hackney_pool_debug_http_func]}}
  ]),
  {ok, #state{pid=Pid}}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, #state{pid=Pid}) ->
  ok = inets:stop(httpd, Pid),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
