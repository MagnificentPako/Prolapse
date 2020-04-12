:- [util].
:- [plugins/user_plugins].

:- dynamic eval_message/1.
:- multifile raw_plugin/2.

%% TODO: Currently all plugins react to edits...
raw_plugin("MESSAGE_UPDATE", user_command_plugin).
raw_plugin("MESSAGE_CREATE", user_command_plugin).
user_command_plugin(Msg) :-
    not_from_me(Msg),
    handle_user_command(Msg).
