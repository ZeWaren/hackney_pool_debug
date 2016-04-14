-module(hackney_pool_debug_http_func).
-author("Erwan Martin <public@fzwte.net>").

%% API
-export([echo/3, long_stuff/3]).

echo(SessionID, _Env, Input) ->
  mod_esi:deliver(SessionID, header()),
  mod_esi:deliver(SessionID, Input).

long_stuff(SessionID, _Env, _Input) ->
  ok = timer:sleep(10000),
  mod_esi:deliver(SessionID, header()),
  mod_esi:deliver(SessionID, <<"ok">>).

header() ->
  "Content-Type: text/plain\r\n\r\n".
