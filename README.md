This is sample app to demonstrate bug #xxx of hackney.

It starts a inets HTTP server (`hackney_pool_debug_http_server`) which serves functions from module `hackney_pool_debug_http_func`.

Then it starts a gen_server (`hackney_pool_debug_http_client`) that will start 3 worker processes (`hackney_pool_debug_http_client_worker`) that will make HTTP requests to the HTTP server.

In the pool, the 3rd request will be put into a queue, and it will stay there forever, even when the 2 first requests complete.

See the bug description for more information.
