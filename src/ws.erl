%%
%% Writer WebSocket
%%
-module(ws).

%%
%% Author: Yuri Artemev
%% http://artemeff.com
%% http://github.com/artemeff/ws
%%
-author('Yuri Artemev <i@artemeff.com>').

%%
%% Cowboy
%%
-behaviour(cowboy_websocket_handler).

%%
%% API methods
%%
%-export([start/0, stop/0, restart/0]).
-export([start/2, init/3, websocket_init/3, websocket_handle/3, websocket_info/3, websocket_terminate/3]).

%%
%% Implementation
%%
start(Port, Path) ->
  % create ws handler
  Dispatch = cowboy_router:compile([
    {'_', [
      {Path, ws, []}
    ]}
  ]),
  {ok, _} = cowboy:start_http(http, 100, [{port, Port}],
    [{env, [{dispatch, Dispatch}]}]).

init({tcp, http}, _Req, _Opts) ->
  {upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
  % identify connected client
  utils:log(" -- ws new client~n"),
  utils:debug(" -- ws peer uid: ~p~n", [utils:uid()]),
  %erlang:start_timer(1000, self(), <<"Hello!">>),
  utils:debug(" -- self: ~p~n", [self()]),
  {ok, Req, undefined_state}.

websocket_handle({text, Msg}, Req, State) ->
  utils:debug(" -- ws got data: ~p~n", [Msg]),
  {reply, {text, << Msg/binary >>}, Req, State};

websocket_handle(Data, Req, State) ->
  utils:debug(" -- ws undef data from handle: ~p~n", [Data]),
  {ok, Req, State}.


%websocket_info({timeout, _Ref, Msg}, Req, State) ->
%  %erlang:start_timer(1000, self(), <<"How' you doin'?">>),
%  utils:log(" -- ws from info 1~n"),
%  {reply, {text, Msg}, Req, State};
  
websocket_info(Info, Req, State) ->
  utils:debug(" -- ws info: ~p~n", [Info]),
  {ok, Req, State}.


websocket_terminate(_Reason, _Req, _State) ->
  utils:log(" -- ws client close connection~n"),
  ok.
