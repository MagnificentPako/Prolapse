:- [http_client].

:- multifile user_plugin/2.

user_plugin("reload", do_reload).
do_reload(_, Msg) :-
    expand_file_name("plugins/raw_plugins/*", Files), load_files(Files, []),
    make,
    reply(Msg, "Reloaded.").
