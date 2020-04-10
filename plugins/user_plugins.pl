

handle_command(Msg, _) :-
   format("Handling command ~s\n", [Msg]), fail.
handle_command(Msg, Res) :-
    string_concat("::", Rest, Msg),
    split_string(Rest, " ", "", [Cmd|Args]),
    command_handler(Cmd, Args, Msg), !.
handle_command(_, not_saved).


command_handler("echo", Args, Msg) :-
    writeln(Args),
    send_message(Msg.d.channel_id, Args).
%% command_handler("eval", [Args], Res) :-
%%     atom_string(A, Args),
%%     writeln(Args),
%%     Res is A.
command_handler(Cmd, _, Msg) :-
    sformat(Response, "~s is not a valid command", [Cmd]),
    send_message(Msg.d.channel_id, Response).
