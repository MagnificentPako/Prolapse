:- module(
     reload,
     [plugin/2]
   ).


:- use_module(library(http/json)).

:- use_module(prolapse(plugins), [load_bot_plugins]).
:- use_module(prolapse(event)).
:- use_module(prolapse(util)).




plugin(prefix("reload"), reload:reload_handler).
plugin(prefix("listeners"), reload:dump_listeners).
%% plugin(raw("MESSAGE_REACTION_ADD"), reload:reaction_plugin).
%% plugin(raw("MESSAGE_REACTION_REMOVE"), reload:reaction_plugin).

reload_handler(Msg) :-
    do_reload,
    on_event(once, "MESSAGE_REACTION_ADD", Msg.d.id, reload:reaction_plugin),
    on_event(once, "MESSAGE_REACTION_REMOVE", Msg.d.id, reload:reaction_plugin),
    reply(Msg, "Reloaded.").

do_reload :-
    load_bot_plugins,
    make.

dump_listeners(Msg) :-
    with_output_to(
      string(X),
      forall(
        listening(prolapse, X, Y),
        (
          write(X),
          write(" - "),
          writeln(Y)
        )
      )
    ),
    codeblock(X, "prolog", CB),
    reply(Msg, CB).


reaction_plugin(_) :-
    do_reload.
    %% reply(Msg, "Event").
