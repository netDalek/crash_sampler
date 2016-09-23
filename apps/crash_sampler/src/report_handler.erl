-module(report_handler).
-behaviour(gen_event).
 
-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3, terminate/2]).

%% ===================================================================
%% Callback
%% ===================================================================
 
init([]) -> {ok, []}.
 
handle_event(Msg, State) ->
    io:format("MSG = ~p\r\n", [Msg]),
    {ok, State}.
 
handle_call(_, State) ->
    {ok, ok, State}.
 
handle_info(_, State) ->
    {ok, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
 
terminate(_Reason, _State) ->
    ok.
