:- module(
     reload,
     [user_plugin/2]
   ).

:- use_module(prolapse(plugins/raw_plugins), [load_raw_plugins/0]).
:- use_module(prolapse(plugins/user_plugins), [load_user_plugins/0]).


user_plugin("reload", reload:do_reload).
do_reload(_, Msg) :-
    load_raw_plugins,
    load_user_plugins,
    make,
    reply(Msg, "Reloaded.").
