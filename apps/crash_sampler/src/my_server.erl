-module(my_server).

-behaviour(gen_server).

-export([start_link/0]).
-export([crash/0]).
-export([method/0]).

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
    gen_server:call(?MODULE, crash).

method() ->
    gen_server:call(?MODULE, method).

init([]) ->
    lager:info("starting"),
    % gen_server:cast(self(), crash),
    {ok, #state{}}.

handle_call(method, _From, State) ->
    {reply, {ok, method}, State};
handle_call(crash, _From, State) ->
    my_server2:crash(),
    % exit(smth),
    % erlang:error(smth),
    % exit(spawn_link(fun() -> timer:sleep(50000) end), kill),
    {reply, ok, State};
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast(crash, State) ->
    {stop, killed, State};
    % erlang:error(smth),
    % {noreply, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, _State) ->
    io:format("my_server:terminate(~p, _State)\r\n", [Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Internal functions
