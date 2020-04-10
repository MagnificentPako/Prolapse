:- [http_client].
:- [ws_client].


:- dynamic ping/1.
:- dynamic heartbeatSeq/1.
:- dynamic me/1, me/2.

callback(Token, Msg) :-
    Msg.t = "MESSAGE_CREATE",
    (\+ me(Msg.d.author.id)),
    writeln(Msg.d.content),
    send_message(Token, Msg.d.channel_id, Msg.d.content),
    handle_command(Msg.d.content, SS),
    send_message(Token, Msg.d.channel_id, SS),
    ping("message").

callback(_, Msg) :-
    Msg.t = "READY",
    asserta(me(Msg.d.user.id)).

run_bot :-
    read_token(Token),
    asserta(me(token, Token)),
    start_ws(callback).

read_token(Token) :-
    open(".token", read, Stream),
    read_line_to_string(Stream, Token).

handle_command(Msg, Res) :-
    string_concat("::", Rest, Msg),
    split_string(Rest, " ", "", [Cmd|Args]),
    command_handler(Cmd, Args, Res),
    %% term_string(T, Rest),
    %% asserta(T),
    %% call(T),
    !.
handle_command(_, not_saved).


command_handler("echo", Args, Res) :-
    writeln(Args),
    term_string(echo(Args), Res).
%% command_handler("eval", [Args], Res) :-
%%     atom_string(A, Args),
%%     writeln(Args),
%%     Res is A.
command_handler(_, _, "Not a valid command.").
