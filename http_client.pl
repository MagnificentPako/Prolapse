:- style_check(-singleton).

:- dynamic me/2.

ua(Ua) :- Ua = "Prolapse (https://github.com/MagnificentPako/Prolapse, 0.1)".

endpoint(Segment, Params, Url) :-
    sformat(Url, 'https://discordapp.com/api/v6/$Segment', Params).

req_options(Auth, Ua, Options) :- 
    Options = [ request_header(authorization=Auth)
              , request_header(user_agen=Ua)
              , json_object(dict)
              ].

do_request(get, Url, Res, O)        :- http_get(Url, Res, O).
do_request(post(Data), Url, Res, O) :- http_post(Url, Data, Res, O).
do_request(patch(Data), Url, Res, O) :- http_patch(Url, Data, Res, O).

 
request(R, Url, Res) :-
    me(token, Token),
    ua(Ua),
    sformat(Auth, "Bot ~w", [Token]),
    req_options(Auth, Ua, O),
    do_request(R, Url, Res, O).

do_send_message(Channel, Message, Res) :-
    endpoint("channels/~w/messages", [Channel], Url),
    request(post(json(Message)), Url, Res).

do_edit_message(Channel, MsgId, Message, Res) :-
    endpoint("channels/~w/messages/~w", [Channel, MsgId], Url),
    request(patch(json(Message)), Url, Res).

edit_message(Channel, MsgId, NewMessage, Res) :-
    do_edit_message(Channel, MsgId, _{ content: NewMessage}, Res).

send_message(Channel, Message) :-
    send_message(Channel, Message, _).

send_message(Channel, Message, Res) :-
    string(Message),
    !,
    do_send_message(Channel, _{ content: Message }, Res).

send_message(Channel, Message, Res) :-
    is_dict(Message),
    !,
    do_send_message(Channel, Message, Res).

get_guild(GuildId, Guild) :-
    endpoint("guilds/~w", [GuildId], Url),
    request(get, Url, Guild).


%% reply to ToMsg with SendMsg
reply(ToMsg, SendMsg) :-
    send_message(ToMsg.d.channel_id, SendMsg).

reply(ToMsg, SendMsg, Res) :-
    send_message(ToMsg.d.channel_id, SendMsg, Res).
