:- module(
     ws_client,
     [
       start_ws/0,
       heartbeatSeq/1
     ]
   ).
:- use_module(library(http/websocket)).

:- use_module(prolapse(plugins/raw_plugins)).


:- dynamic heartbeatSeq/1.

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

callback(Msg) :-
    run_raw_plugins(Msg.t, Msg).

start_ws(Callback) :-
    URL = "wss://gateway.discord.gg/?v=6&encoding=json",
    dbg(info, "Starting bot"),
    http_open_websocket(URL, WS, []),
    ws_receive(WS, HELLO, [format(json)]),
    thread_create(heartbeat(HELLO.data.d.heartbeat_interval, WS), _),
    get_config(token, Token),
    identify_client(WS, Token),
    ws_loop(WS, Callback).

start_ws :-
    start_ws(callback).
