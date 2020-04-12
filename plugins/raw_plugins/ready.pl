:- [config].


:- multifile raw_plugin/2.

raw_plugin("READY", ready_handler).

ready_handler(Msg) :-
    writeln("READY plugin, saving user id"),
    set_config(id, Msg.d.user.id).
