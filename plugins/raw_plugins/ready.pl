:- module(
     ready,
     [raw_plugin/2]
   ).

:- use_module(prolapse(config)).
:- use_module(prolapse(util), [dbg/2]).


raw_plugin("READY", ready:ready_handler).

ready_handler(Msg) :-
    dbg(raw_plugin, "READY plugin, saving user id"),
    set_config(id, Msg.d.user.id).
