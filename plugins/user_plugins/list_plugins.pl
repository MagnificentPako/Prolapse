:- multifile user_plugin/2.

user_plugin("list_plugins", list_plugins).
list_plugins(_, Msg) :-
    findall(user_plugin(P, H), user_plugin(P, H), Ps),
    with_output_to(string(Pretty), listing(user_plugin)),
    codeblock(Pretty, "prolog", Res),
    reply(Msg, Res).
