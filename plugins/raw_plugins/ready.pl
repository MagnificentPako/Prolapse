
:- multifile raw_plugin/2.

raw_plugin("READY", ready_handler).

ready_handler(Msg) :-
    writeln("READY plugin, saving user id"),
    asserta(me(id, Msg.d.user.id)).
