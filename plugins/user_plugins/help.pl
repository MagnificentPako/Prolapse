:- module(
     help,
     [user_plugin/2]
   ).

:- use_module(prolapse(util)).
:- use_module(prolapse(http_lib), [reply/2]).


user_plugin("list_plugins", help:list_plugins).
user_plugin("help", help:list_plugins).

list_plugins(_, Msg) :-
    get_stuff(user_plugins, Ps),
    member(P, Ps),
    %% term_string(P, Res),
    writeln(P),
    reply(Msg, P).
