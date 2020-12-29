:- module(
     help,
     [plugin/2]
   ).

:- use_module(prolapse(util)).
:- use_module(prolapse(http_lib), [reply/2, create_reaction/2]).


plugin(prefix("list_plugins"), help:list_plugins).
plugin(prefix("help"), help:list_plugins).

list_plugins(Msg) :-
    get_stuff(plugins, AllPlugins),
    findall(
      P,
      ( member(P, AllPlugins),
        P = plugin(prefix(_), _)
      ),
      Ps
    ),
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
    reply(Msg, Help),
    create_reaction(Msg, "👍").
