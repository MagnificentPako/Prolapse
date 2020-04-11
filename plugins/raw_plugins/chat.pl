:- multifile raw_plugin/2.

raw_plugin("MESSAGE_CREATE", chat_plugin).

chat_plugin(Msg) :-
    format("~s says: ~s\n", [Msg.d.author.username, Msg.d.content]).
