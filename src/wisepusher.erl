%%
%% Reader/Writer TCP Socket
%%
-module(wisepusher).

%%
%% Author: Yuri Artemev
%% http://artemeff.com
%% http://github.com/artemeff/wisepusher
%%
-author('Yuri Artemev <i@artemeff.com>').

%%
%% API methods
%%
-export([start/0, stop/0, restart/0, loop/1]).

%%
%% Implementation
%%

%%
%% Start wisepusher server
%% Usage:
%%    tcp:start(main_module_name, port_for_tcp_socket, {module_when_loop, loop_name}).
%%
start() ->
  utils:log(" -- start workers~n"),
  % applications
  application:start(jsonx),
  application:start(crypto),
  application:start(ranch),
  application:start(cowboy),
  application:start(wisepusher),
  % tcp listener
  tcp:start(?MODULE, 8001, {?MODULE, loop}),
  % ws listener
  ws:start(8002, "/ws").

stop() ->
  utils:log(" -- kill main worker~n"),
  % ws:start(),
  tcp:stop(?MODULE).

restart() ->
  % TODO write normal restart
  stop(), restart().

% Looper
loop(Socket) ->
  case gen_tcp:recv(Socket, 0) of
    {ok, Data} ->
      % ws:send(where, data),
      gen_tcp:send(Socket, "ok"),
      utils:debug(" -- received data: ~n~p~n", [Data]),
      utils:debug(" -- decoded data: ~n~p~n", [jsonx:decode(Data)]),
      %erlang:start_timer(100, ws, Data),
      loop(Socket);
    {error, closed} ->
      ok
  end.
