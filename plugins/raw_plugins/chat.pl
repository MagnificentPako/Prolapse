:- multifile raw_plugin/2.

raw_plugin("MESSAGE_CREATE", chat_plugin).

chat_plugin(Msg) :-
    get_dict(author, Msg.d, Author) ->
        format("~s says: ~s\n", [Author.username, Msg.d.content]).
