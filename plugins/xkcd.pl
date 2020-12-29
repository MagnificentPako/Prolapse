:- module(
     xkcd,
     [plugin/2]
   ).

:- use_module(library(http/http_client)).

:- use_module(prolapse(http_lib)).

plugin(prefix("xkcd"), xkcd:handler).

send_xkcd(Msg, Res) :-
    Object = _{ embed: _{ title: Res.safe_title
                        , description: Res.alt
                        , image: _{ url: Res.img }}},
    reply(Msg, Object).

handler(Msg) :- !,
    http_get("https://xkcd.com/info.0.json", Res, [json_object(dict)]),
    send_xkcd(Msg, Res).

handler(Msg) :- !,
 % TODO: unbreak
    http_get("https://xkcd.com/$_Id/info.0.json", Res, [json_object(dict)]),
    send_xkcd(Msg, Res).
