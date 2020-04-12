:- use_module(library(http/websocket)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).
:- dynamic heartbeatSeq/1.
:- dynamic me/2.

heartbeat(Time, WS) :-
    repeat,
    Seconds is Time / 1000,
    sleep(Seconds),
    heartbeatSeq(S),
    Object = json{ op:1, d:S},
    ws_send(WS, json(Object)),
    fail.

identify_client(WS, Token) :-
    Object = json{ op:2
                 , d: json{ token: Token
                          , properties: json{ '$os': "linux"
                                            , '$browser': "Prolapse 0.1"
                                            , '$device':  "Prolapse 0.1" }}},
    ws_send(WS, json(Object)).

ws_loop(WS, Callback) :-
    repeat,
    ws_receive(WS, Msg, [format(json)]),
    abolish(heartbeatSeq/1),
    asserta(heartbeatSeq(Msg.data.s)),
    writeln(Msg.data.t),
    call(Callback, Msg.data),
    fail.

start_ws(Callback) :-
    URL = "wss://gateway.discord.gg/?v=6&encoding=json",
    writeln("Starting bot"),
    http_open_websocket(URL, WS, []),
    ws_receive(WS, HELLO, [format(json)]),
    thread_create(heartbeat(HELLO.data.d.heartbeat_interval, WS), _),
    me(token, Token),
    identify_client(WS, Token),
    ws_loop(WS, Callback).

%% caching code stuf
:- dynamic user/2.

fetch_from_network(user(UserId), Res) :-
    %% simulate network request
    sleep(2),
    %% store user in cache
    User = some_user,
    (retract(user(UserId, User)) ; asserta(user(UserId, User))),
    Res = User.

get_from_cache(user(UserId), Res) :- user(UserId, Res).

get_user(UserId, Res) :- get_from_cache(user(UserId), Res), !.
get_user(UserId, Res) :- fetch_from_network(user(UserId), Res), !.
