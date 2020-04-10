:- use_module(library(http/websocket)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).
:- dynamic heartbeatSeq/1.

heartbeat(Time, WS) :-
    repeat,
    sleep(Time / 1000),
    heartbeatSeq(S),
    Object = json{ op:1, d:S},
    atom_json_dict(J, Object, []),
    ws_send(WS, text(J)),
    fail.

read_json(WS, J) :-
    ws_receive(WS, Reply),
    atom_json_dict(Reply.data, J, []).  

identify_client(WS, Token) :-
    Object = json{ op:2
                 , d: json{ token: Token
                         , properties: json{ '$os': "linux"
                                           , '$browser': "Prolapse 0.1"
                                           , '$device':  "Prolapse 0.1" }}},
    atom_json_dict(JJ, Object, []),
    ws_send(WS, text(JJ)).

ws_loop(Token, WS, Callback) :-
    repeat,
    read_json(WS, Msg),
    abolish(heartbeatSeq/1),
    assert(heartbeatSeq(Msg.s)),
    call(Callback, Token, Msg),
    fail.

start_ws(Token, Callback) :-
    URL = "wss://gateway.discord.gg/?v=6&encoding=json",
    write("Starting Bot"), nl,
    http_open_websocket(URL, WS, []),
    read_json(WS, HELLO),
    thread_create(heartbeat(HELLO.d.heartbeat_interval, WS), _),
    identify_client(WS, Token),
    ws_loop(Token, WS, Callback).
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
