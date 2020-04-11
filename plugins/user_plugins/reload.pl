:- [http_client].

user_plugin("reload", do_reload).
do_reload(_, Msg) :-
    make,
    reply(Msg, "Reloaded.").
