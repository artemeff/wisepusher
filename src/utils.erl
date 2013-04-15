%%
%% Utils for WisePush
%%
-module(utils).

%%
%% Author: Yuri Artemev
%% http://artemeff.com
%% http://github.com/artemeff/wisepusher
%%
-author('Yuri Artemev <i@artemeff.com>').

%%
%% API methods
%%
-export([uid/0, debug/2, log/1]).

%%
%% Configuration
%%
-define(ENABLED, true).

%%
%% Implementation
%%
debug(Msg, Vars) ->
  case ?ENABLED of
    true -> io:format(Msg, Vars);
    _Any -> false
  end.

log(Msg) ->
  case ?ENABLED of
    true -> io:format(Msg);
    _Any -> false
  end.

uid() ->
  {node(), now(), make_ref()}.
