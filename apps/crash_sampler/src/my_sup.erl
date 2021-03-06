%%%-------------------------------------------------------------------
%% @doc my_sup supervisor.
%% @end
%%%-------------------------------------------------------------------

-module('my_sup').

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    SupFlags = #{strategy => one_for_all, intensity => 1, period => 1},
    ChildSpecs = [
        % #{id => my_server, shutdown => infinity, start => {my_server, start_link, []}},
        % #{id => my_server2, shutdown => infinity, start => {my_server2, start_link, []}}
    ],
    {ok, {SupFlags, ChildSpecs}}.

%%====================================================================
%% Internal functions
%%====================================================================
