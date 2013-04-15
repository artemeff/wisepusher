%%
%% Reader/Writer TCP Socket
%%
-module(wisepusher_app).

%%
%% Author: Yuri Artemev
%% http://artemeff.com
%% http://github.com/artemeff/wisepusher
%%
-author('Yuri Artemev <i@artemeff.com>').

%%
%% Application standarts
%%
-behaviour(application).

%%
%% API methods
%%
-export([start/2, stop/1]).

%%
%% Implementation
%%
start(_StartType, _StartArgs) ->
  utils:log(" -- start wisepusher app~n"),
  wisepusher_sup:start_link().

stop(_State) ->
  ok.
