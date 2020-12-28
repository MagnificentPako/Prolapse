:- module(
     http_lib,
     [
       send_message/2,
       send_message/3,
       get_guild/2,
       reply/2,
       reply/3,
       edit_message/4
     ]
   ).

:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json_convert)).

:- use_module(prolapse(config), [get_config/2]).

:- style_check(-singleton).

ua(Ua) :- Ua = "Prolapse (https://github.com/MagnificentPako/Prolapse, 0.1)".

base_url("https://discordapp.com/api/v6/").

endpoint(Segment, Params, Url) :-
    base_url(BaseUrl),
    string_concat(BaseUrl, Segment, FullUrl),
    format(string(Url), FullUrl, Params).

req_options(Auth, Ua, Options) :- 
    Options = [ request_header(authorization=Auth)
              , request_header(user_agent=Ua)
              , json_object(dict)
              ].

do_request(get, Url, Res, O)        :- http_get(Url, Res, O).
do_request(post(Data), Url, Res, O) :- http_post(Url, Data, Res, O).
do_request(patch(Data), Url, Res, O) :- http_patch(Url, Data, Res, O).

 
request(R, Url, Res) :-
    ua(Ua),
    get_config(token, Token),
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
    is_dict(Message),
    !,
    do_send_message(Channel, Message, Res).

send_message(Channel, Message, Res) :-
    format(string(String), "~w", [Message]),
    !,
    do_send_message(Channel, _{ content: String }, Res).

send_message(_, Msg, _) :-
    writeln("Failed to send message").

get_guild(GuildId, Guild) :-
    endpoint("guilds/~w", [GuildId], Url),
    request(get, Url, Guild).


%% reply to ToMsg with SendMsg
reply(ToMsg, SendMsg) :-
    format("Replying with ~w\n", [SendMsg]),
    send_message(ToMsg.d.channel_id, SendMsg).

reply(ToMsg, SendMsg, Res) :-
    send_message(ToMsg.d.channel_id, SendMsg, Res).
