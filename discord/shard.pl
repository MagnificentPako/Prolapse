:- module(
     shard,
     [start_shards/0]
   ).

:- use_module(library(http/websocket)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(debug)).

:- use_module(prolapse(http_lib)).
:- use_module(prolapse(discord/shard)).
:- use_module(prolapse(discord/opcodes), [gateway_op/2]).
:- use_module(prolapse(plugins), [run_plugins/1]).
:- use_module(prolapse(util)).



:- dynamic shard_heartbeat_seq/2.

spawn_shards(WSS, Callback, Shards, IDs) :-
    debug(debug, "Starting ~w shards", [Shards]),
    N is Shards - 1,
    findall(
      ThreadId
      , ( between(0, N, Num)
          , create_shard(WSS, [Num, Shards], Callback, ThreadId)
          , sleep(5.2))
      , IDs).

callback(Msg, _ShardId) :-
    get_dict(data, Msg, Data),
    dif(Data.t, null),
    dbg(ws, "~w", [Data.t]),
    run_plugins(Data).

start_shards :-
    setup_gateway(callback).

setup_gateway(Callback) :-
    get_gateway_bot(Res),
    format(string(WSS), "~w/?v=6&encoding=json", [Res.url]),
    spawn_shards(WSS, Callback, 1, [ID|_]),
    thread_join(ID).


create_shard(WSS, [ShardId, ShardNum], Callback, ThreadId) :- 
    thread_create(shard(WSS, [ShardId, ShardNum], Callback), ThreadId).

shard(WSS, [ShardId, ShardNum], Callback) :- 
    debug(debug, "Shard ~w Created", [ShardId]),
    http_open_websocket(WSS, Socket, []),
    ws_receive(Socket, HELLO, [format(json)]),
    thread_create(shard_heartbeat(Socket, HELLO.data.d.heartbeat_interval, ShardId), Beat),
    get_config(token, Token),
    gateway_op(Op, identify),
    Object = json{ op: Op
                 , d: json{ token: Token
                          , properties: json{ '$os': "linux"
                                            , '$browser': "Prolapse 0.1"
                                            , '$device':  "Prolapse 0.1" }
                          , shard: [ShardId, ShardNum] }},
    ws_send(Socket, json(Object)),
    shard_loop(Socket, ShardId, Callback),
    thread_join(Beat).
  
shard_loop(Socket, ShardId, Callback) :- 
    repeat,
    ws_receive(Socket, Msg, [format(json)]),
    retractall(shard_heartbeat_seq(_, ShardId)),
    asserta(shard_heartbeat_seq(Msg.data.s, ShardId)),
    call(Callback, Msg, ShardId),
    fail.

shard_heartbeat(WS, Time, ShardId) :- 
    repeat,
    Seconds is Time / 1000,
    sleep(Seconds),
    shard_heartbeat_seq(S, ShardId),
    Object = json{ op:1, d:S },
    ws_send(WS, json(Object)),
    fail.
