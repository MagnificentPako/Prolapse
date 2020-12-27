:- use_module(library(pprint)).
:- use_module(library(aggregate)).
:- use_module(library(http/json)).
:- use_module(library(dcg/basics)).
:- use_module(library(interpolate)).
:- use_module(library(http/http_json)).
:- use_module(library(dcg/high_order)).
:- use_module(library(http/websocket)).
:- use_module(library(http/http_client)).
:- use_module(library(quasi_quotations)).
:- use_module(library(http/json_convert)).

:- ensure_loaded(http_client).
:- ensure_loaded(ws_client).
:- ensure_loaded(plugins/raw_plugins).
:- ensure_loaded(util).

:- initialization(main, main).

callback(Msg) :-
    run_raw_plugins(Msg.t, Msg).

run_bot :-
    load_token,
    start_ws(callback).

read_token(Token) :-
    open(".token", read, Stream),
    read_line_to_string(Stream, Token).

main :- run_bot.
