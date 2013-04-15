%%
%% Reader/Writer TCP Socket
%%
-module(tcp).

%%
%% Author: Yuri Artemev
%% http://artemeff.com
%% http://github.com/artemeff/wisepusher
%%
-author('Yuri Artemev <i@artemeff.com>').

%%
%% Builded by OTP conventions with gen_server
%% Documentatin: http://erlanger.ru/wiki/index.php/OTP_Gen_Server
%%
-behaviour(gen_server).

%%
%% API methods
%%
-export([start/3, stop/1, restart/3]).
-export([accept_loop/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%
%% Configuration
%%
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]).
-define(GEN_OPTIONS, []).

%%
%% Records
%%
-record(server_state, {port, loop, ip = any, lsocket = null}).

%%
%% Implementation
%%

% Start server
start(Name, Port, Loop) ->
  utils:debug(" -- start tcp listener ~p:~p with callback: ~p~n", [Name, Port, Loop]),
  State = #server_state{port = Port, loop = Loop},
  gen_server:start_link({local, Name}, ?MODULE, State, ?GEN_OPTIONS).

% Kill server
stop(Name) ->
  utils:log(" -- stop tcp listener~n"),
  gen_server:cast(Name, stop).

% Restart server
restart(Name, Port, Loop) ->
  stop(Name), start(Name, Port, Loop).

%%
%% Gen Server API
%%
% Starts server, here you should initialize all variables
init(State = #server_state{port = Port}) ->
  utils:log(" -- create listener thread~n"),
  case gen_tcp:listen(Port, ?TCP_OPTIONS) of
    {ok, LSocket} ->
      NewState = State#server_state{lsocket = LSocket},
      {ok, accept(NewState)};
    {error, Reason} ->
      {stop, Reason}
  end.

handle_cast(stop, State = #server_state{lsocket = LSocket}) ->
  gen_tcp:close(LSocket),
  utils:log(" -- tcp listener is closed~n"),
  {stop, normal, State};

handle_cast({accepted, _Pid}, State = #server_state{}) ->
  {noreply, accept(State)}.

accept_loop({Server, LSocket, {M, F}}) ->
  {ok, Socket} = gen_tcp:accept(LSocket),
  % Let the server spawn a new process and replace this loop
  % with the echo loop, to avoid blocking 
  gen_server:cast(Server, {accepted, self()}),
  M:F(Socket).

% To be more robust we should be using spawn_link and trapping exits
accept(State = #server_state{lsocket = LSocket, loop = Loop}) ->
  proc_lib:spawn(?MODULE, accept_loop, [{self(), LSocket, Loop}]),
  State.

% These are just here to suppress warnings.
handle_call(_Msg, _Caller, State) ->
  {noreply, State}.

handle_info(_Msg, Library) ->
  {noreply, Library}.

terminate(_Reason, _Library) ->
  ok.

code_change(_OldVersion, Library, _Extra) ->
  {ok, Library}.
