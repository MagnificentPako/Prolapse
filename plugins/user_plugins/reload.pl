:- [http_client].

:- multifile user_plugin/2.

user_plugin("reload", do_reload).
do_reload(_, Msg) :-
    make,
    reply(Msg, "Reloaded.").
