:- [plugins/user_plugins].

:- multifile raw_plugin/2.
raw_plugin("MESSAGE_CREATE", user_command_plugin).
user_command_plugin(Msg) :-
    \+ me(id, Msg.d.author.id),
    handle_user_command(Msg).
