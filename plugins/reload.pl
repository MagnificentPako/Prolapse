:- module(
     reload,
     [plugin/2]
   ).


:- use_module(prolapse(plugins), [load_bot_plugins]).


plugin(prefix("reload"), reload:do_reload).
do_reload(Msg) :-
    load_bot_plugins,
    make,
    reply(Msg, "Reloaded.").
