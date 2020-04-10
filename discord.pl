:- [http_client].
:- [ws_client].
:- [plugins/raw].

:- initialization(main, main).

:- dynamic ping/1.
:- dynamic heartbeatSeq/1.
:- dynamic me/1, me/2.

callback(Msg) :-
    raw_plugin(Msg.t, Msg).

run_bot :-
    read_token(Token),
    asserta(me(token, Token)),
    start_ws(callback).

read_token(Token) :-
    open(".token", read, Stream),
    read_line_to_string(Stream, Token).

main :- run_bot.
