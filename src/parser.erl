%%
%% Data parser
%%
-module(parser).

%%
%% Author: Yuri Artemev
%% http://artemeff.com
%% http://github.com/artemeff/wisepusher
%%
-author('Yuri Artemev <i@artemeff.com>').

%%
%% API methods
%%
-export([decode/1, encode/1]).

%%
%% Records
%%
%-record(users,   {type, ids,  event, message}).
%-record(user,    {type, id,   event, message}).
%-record(channel, {type, name, event, message}).

%%
%% Implementation
%%
decode(Data) ->
  %logger:debug(" -- parser original data: ~p~n", [Data]),
  %Struct = jsonx:decode(Data),
  %logger:debug(" -- parser structured data: ~p~n", [Struct]),
  %{Type, _} = Struct,
  %logger:debug(" -- parser type of: ~p~n", [Type]).
  jsonx:decode(Data).

encode(Data) ->
  %logger:debug(" -- parser original data: ~p~n", [Data]),
  jsonx:encode(Data).
