:- [http_client].
:- [ws_client].
:- [plugins/raw_plugins].
:- [config].


:- initialization(main, main).

callback(Msg) :-
    run_raw_plugins(Msg.t, Msg).

run_bot :-
    load_config,
    start_ws(callback).

main :- run_bot.
