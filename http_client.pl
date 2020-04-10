:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).

:- dynamic me/2.

ua(Ua) :- Ua = "Prolapse (https://github.com/MagnificentPako/Prolapse, 0.1)".

endpoint(Segment, Params, Url) :-
    string_concat("https://discordapp.com/api/v6/", Segment, Url_),
    sformat(Url, Url_, Params).

req_options(Auth, Ua, Options) :- 
    Options = [ request_header(authorization=Auth)
              , request_header(user_agen=Ua)
              , json_object(dict)
              ].

do_request(get, Url, Res, O)        :- http_get(Url, Res, O).
do_request(post(Data), Url, Res, O) :- http_post(Url, Data, Res, O).
 
request(R, Url, Res) :-
    me(token, Token),
    ua(Ua),
    sformat(Auth, "Bot ~w", [Token]),
    req_options(Auth, Ua, O),
    do_request(R, Url, Res, O).

do_send_message(Channel, Message) :-
    endpoint("channels/~w/messages", [Channel], Url),
    request(post(json(Message)), Url, _).

send_message(Channel, Message) :-
    string(Message),
    (\+ is_dict(Message)),
    do_send_message(Channel, _{ content: Message }).

send_message(Channel, Message) :-
    is_dict(Message),
    writeln('sending'),
    do_send_message(Channel, Message).

get_guild(GuildId, Guild) :-
    endpoint("guilds/~w", [GuildId], Url),
    request(get, Url, Guild).