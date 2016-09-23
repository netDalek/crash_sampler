%% -*- erlang-indent-level: 4;indent-tabs-mode: nil -*-
%% ex: ts=4 sw=4 et
%% @author {{author}} <{{author_email}}>
%% @copyright {{copyright_year}} {{copyright_holder}}

-module(my_server2).

-behaviour(gen_server).

-export([start_link/0]).
-export([crash/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-record(state, {}).

start_link() ->
    % sys:statistics(?MODULE, true),
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

crash() ->
    spawn(fun() -> timer:sleep(500), exit(whereis(?MODULE), kill) end),
    gen_server:call(?MODULE, crash).

init([]) ->
    {ok, #state{}}.

handle_call(crash, _From, State) ->
    % timer:sleep(1000), 
    % exit(self(), kill),
    % exit(self(), kill),
    % {reply, ok, State};
    {stop, reason, ok, State};
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, _State) ->
    io:format("my_server2:terminate(~p, _State)\r\n", [Reason]),
    % exit(smth2),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Internal functions
