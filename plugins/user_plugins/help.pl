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
    with_output_to(
      string(Output),
      findall(
        P,
        (
          member(P, Ps),
          writeln(P)
        ),
        _
      )
    ),
    codeblock(Output, "prolog", Help),
    %% term_string(P, Res),
    reply(Msg, Help).
