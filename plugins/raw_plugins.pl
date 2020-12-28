:- module(
     raw_plugins,
     [
       run_raw_plugins/2,
       load_raw_plugins/0
     ]
   ).

% :- use_module(prolapse(user_plugins)).
:- use_module(prolapse(util)).
:- use_module(prolapse(plugins), [load_plugins/3]).


load_raw_plugins :-
    writeln("Loading raw plugins"),
    load_plugins("plugins/raw_plugins", raw_plugin, Ps),
    save_stuff(raw_plugins, Ps).

run_raw_plugins(MsgType, Msg) :-
    get_stuff(raw_plugins, Plugins),
    member(
      plugin(MsgType, Handler),
      Plugins
    ),
    call(Handler, Msg).
