:- module(
     user_commands,
     [raw_plugin/2]
   ).


:- use_module(prolapse(plugins/user_plugins)).


%% TODO: Currently all plugins react to edits...
raw_plugin("MESSAGE_UPDATE", user_commands:user_command_plugin).
raw_plugin("MESSAGE_CREATE", user_commands:user_command_plugin).
user_command_plugin(Msg) :-
    %% true.
    %% not_from_me(Msg),
    writeln("Handling"),
    handle_user_command(Msg).
