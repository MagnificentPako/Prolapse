:- [http_client].
:- [ws_client].


:- dynamic ping/1.
:- dynamic heartbeatSeq/1.
:- dynamic me/1.

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
    assert(me(Msg.d.user.id)).

start_with_token :-
    start_ws("some token", callback).words(S, W) :- split_string(S, " ", "", W).
words(S, W) :- split_string(S, " ", "", W).
unwords(W, S) :-
    reverse(W, R),
    foldl(string_concat, R, "", S).

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
