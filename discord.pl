:- [http_client].
:- [ws_client].
:- [plugins/raw_plugins].

:- initialization(main, main).

callback(Msg) :-
    run_raw_plugins(Msg.t, Msg).

run_bot :-
    read_token(Token),
    asserta(me(token, Token)),
    start_ws(callback).

read_token(Token) :-
    open(".token", read, Stream),
    read_line_to_string(Stream, Token).

main :- run_bot.
