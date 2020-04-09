:- use_module(library(http/websocket)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).

heartbeat(Time, WS) :-
    repeat,
    sleep(Time / 1000),
    heartbeatSeq(S),
    Object = json{ op:1, d:S},
    atom_json_dict(J, Object, []),
    ws_send(WS, text(J)),
    1 < 0.

read_json(WS, J) :-
    ws_receive(WS, Reply),
    atom_json_dict(Reply.data, J, []).  

identify_client(WS, Token) :-
    Object = json{ op:2
                 , d: json{ token: Token
                         , properties: json{ '$os': "linux"
                                           , '$browser': "Discolog 0.1"
                                           , '$device':  "Discolog 0.1" }}},
    atom_json_dict(JJ, Object, []),
    ws_send(WS, text(JJ)).

ws_loop(Token, WS, Callback) :-
    repeat,
    read_json(WS, Msg),
    abolish(heartbeatSeq/1),
    assert(heartbeatSeq(Msg.s)),
    call(Callback, Token, Msg),
    1 < 0.

start_ws(Token, Callback) :-
    URL = "wss://gateway.discord.gg/?v=6&encoding=json",
    write("Starting Bot"), nl,
    http_open_websocket(URL, WS, []),
    read_json(WS, HELLO),
    thread_create(heartbeat(HELLO.d.heartbeat_interval, WS), _),
    identify_client(WS, Token),
    ws_loop(Token, WS, Callback).