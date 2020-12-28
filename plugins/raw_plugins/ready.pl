:- module(
     ready,
     [raw_plugin/2]
   ).

:- use_module(prolapse(config)).


raw_plugin("READY", ready:ready_handler).

ready_handler(Msg) :-
    writeln("READY plugin, saving user id"),
    set_config(id, Msg.d.user.id).
