:- [http_client].
:- [ws_client].

callback(Token, Msg) :-
    Msg.t = "MESSAGE_CREATE",
    (\+ me(Msg.d.author.id)),
    send_message(Token, Msg.d.channel_id, Msg.d.content),
    ping("message").

callback(_, Msg) :-
    Msg.t = "READY",
    assert(me(Msg.d.user.id)).

start_with_token :-
    start_ws("some token", callback).