:- multifile user_plugin/2.

user_plugin("list_plugins", list_plugins).
user_plugin("help", list_plugins).
list_plugins(_, Msg) :-
    with_output_to(string(Pretty), listing(user_plugin)),
    codeblock(Pretty, "prolog", Res),
    reply(Msg, Res).
