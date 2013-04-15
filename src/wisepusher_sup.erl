%%
%% Reader/Writer TCP Socket
%%
-module(wisepusher_sup).

%%
%% Author: Yuri Artemev
%% http://artemeff.com
%% http://github.com/artemeff/wisepusher
%%
-author('Yuri Artemev <i@artemeff.com>').

%%
%% Supervisor standarts
%%
-behaviour(supervisor).

%%
%% API methods
%%
-export([start_link/0, init/1]).

%%
%% Constants
%%
-define(SUPERVISOR, ?MODULE).

%%
%% Implementation
%%
start_link() ->
  utils:log(" -- start supervisor~n"),
  supervisor:start_link({local, ?SUPERVISOR}, ?MODULE, []).

%% supervisor
init([]) ->
  {ok, {{one_for_one, 10, 10}, []}}.
  %{ok, {{one_for_one, 1, 60}, % may be '{one_for_one, 1, 60}', '{one_for_one, 10, 10}'
  %    [{
  %      wisepusher,
  %      {wisepusher, start, []},
  %      permanent,
  %      5000, % may be '5000', '10'
  %      supervisor, % may be 'worker', 'supervisor'
  %      [wisepusher]
  %    }]
  %  }
  %}.
