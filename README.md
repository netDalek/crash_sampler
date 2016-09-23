title: Erlang
author:
  name: Denis Kirichenko
  twitter: deni10o
output: basic.html
controls: false
style: basic-style.css

--

# Erlang CRASH
## How to read erlang error log

--

### Emulator

    spawn(fun() -> crash:crash() end)

#### error_logger:handle_event
    {error,<0.90.0>,
      {emulator,"~s~n",
         ["Error in process <0.104.0> on node 'nonode@nohost'
           with exit value: {undef,[{crash,crash,[],[]}]}\n"]}}

#### lager
Error in process <0.104.0> on node 'nonode@nohost' with exit value: {undef,[{crash,crash,[],[]}]}

---

### Proc_lib

    handle_call(crash, _From, State) ->
        erlang:error(smth),

#### error_logger:handle_event
    {error_report,<0.287.0>, {<0.3382.0>,crash_report,
           [[{initial_call,{my_server,init,['Argument__1']}},
             {pid,<0.3382.0>}, {registered_name,my_server},
             {error_info, {exit, {smth, %Stacktrace%}, %Stacktrace2%}},
             {ancestors,[crash_sampler_sup,<0.288.0>]},
             {messages,[]}, {links,[<0.289.0>]},
             {dictionary,[]}, {trap_exit,false},
             {status,running}, {heap_size,987},
             {stack_size,27}, {reductions,214}],
            []]}}

#### lager

CRASH REPORT Process my_server with 0 neighbours exited with reason: smth in my_server:handle_call/3 line 31 in gen_server:terminate/7 line 826

--

### Gen_server

    handle_call(crash, _From, State) ->
        erlang:error(smth),

#### error_logger:handle_event
    {error,<0.112.0>, {<0.115.0>,
         "** Generic server ~p terminating \n ** Last message in was ~p~n
          ** When Server state == ~p~n ** Reason for termination == ~n** ~p~n",
         [my_server,crash, {state}, {smth,
                [{my_server,handle_call,3, [{file,
                          "/projects/crash_sampler/_build/default/lib/crash_sampler/src/my_server.erl"},
                      {line,30}]},
                  ...

#### lager
gen_server my_server terminated with reason: smth in my_server:handle_call/3 line 30

---
### {stop, reason, ok, State}

    handle_call(crash, _From, State) ->
        {stop, reason, ok, State};

#### Gen_server
gen_server my_server2 terminated with reason: reason

#### Proc_lib

CRASH REPORT Process my_server2 with 0 neighbours exited with reason: reason in gen_server:handle_msg/5 line 677

---

### handle_call(crash, _From, State) -> exit(kill),

#### Gen_server
gen_server my_server2 terminated with reason: kill in my_server2:handle_call/3 line 34

#### Proc_lib
CRASH REPORT Process my_server2 with 0 neighbours exited with reason: kill in gen_server:terminate/7 line 826

---
### terminate(_Reason, _State) -> exit(smth2),

gen_server my_server2 terminated with reason: smth2 in my_server2:terminate/2 line 48

CRASH REPORT Process my_server2 with 0 neighbours exited with reason: smth2 in gen_server:terminate/7 line 814

---
### gen_server:call

    -module(my_server).
    handle_call(crash, _From, State) ->
        my_server2:crash(),
        ...

    -module(my_server2).
    handle_call(crash, _From, State) ->
        exit(smth2),
        ...

gen_server my_server terminated with reason: {smth2,{gen_server,call,[my_server2,crash]}} in gen_server:call/2 line 204

CRASH REPORT Process my_server with 0 neighbours exited with reason: {smth2,{gen_server,call,[my_server2,crash]}} in gen_server:terminate/7 line 826
---

### Supervisor

    handle_call(crash, _From, State) ->
        crash:crash(smth),

#### error_logger:handle_event
    {error_report,<0.90.0>, {<0.92.0>,supervisor_report,
                     [{supervisor,{<0.92.0>,bernhard_sup}},
                      {errorContext,child_terminated},
                      {reason,{undef,[{crash,crash,[],[]}]}},
                      {offender,[{pid,<0.94.0>},
                                 {name,my_server}, {mfargs,{my_server,start_link,[]}},
                                 {restart_type,permanent}, {shutdown,5000},
                                 {child_type,worker}]}]}}

#### Lager

    Supervisor {<0.92.0>,bernhard_sup} had child my_server started with my_server:
    start_link() at <0.94.0> exit with reason call to undefined function crash:crash()
    in context child_terminated

---

### sys:terminate(my_server, reason).

gen_server my_server terminated with reason: reason

CRASH REPORT Process my_server with 0 neighbours exited with reason: reason in gen_server:terminate/7 line 826


---

### Child supervisor

    -module('crash_sampler_sup').
    ...
    #{id => my_sup, start => {my_sup, start_link, []}}

exit(whereis(crash_sampler_sup), kill).

gen_server my_sup terminated with reason: killed

---

### one_for_all

    SupFlags = #{strategy => one_for_all, intensity => 1, period => 1},
    ChildSpecs = [
        #{id => my_server, start => {my_server, start_link, []}},
        #{id => my_server2, start => {my_server2, start_link, []}},

exit(whereis(my_server), kill).

Будет ли сообщение о падении my_server2?

---

### Links

* https://github.com/erlang/otp/blob/maint/lib/stdlib/src/
* https://github.com/basho/lager/blob/master/src/error_logger_lager_h.erl
