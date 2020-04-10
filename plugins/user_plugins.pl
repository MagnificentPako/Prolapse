

handle_user_command(Msg) :-
   format("Trying to run command ~s\n", [Msg.d.content]), fail.
handle_user_command(Msg) :-
    string_concat("::", Rest, Msg.d.content),
    split_string(Rest, " ", "", [Cmd|Args]),
    command_handler(Cmd, Args, Msg), !.
handle_user_command(_, not_saved).


% not quite working yet
command_handler("echo", Args, Msg) :-
    writeln(Args),
    print_term(Msg, []).
command_handler("reload", _, Msg) :-
    make,
    send_message(Msg.d.channel_id, "Reloaded.").
%% command_handler("eval", [Args], Res) :-
%%     atom_string(A, Args),
%%     writeln(Args),
%%     Res is A.
command_handler(Cmd, _, Msg) :-
    sformat(Response, "~s is not a valid command", [Cmd]),
    send_message(Msg.d.channel_id, Response).
