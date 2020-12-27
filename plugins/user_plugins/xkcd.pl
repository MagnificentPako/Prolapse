:- style_check(-singleton).
:- multifile user_plugin/2.

user_plugin("xkcd", handler).

send_xkcd(Msg, Res) :-
    Object = _{ embed: _{ title: Res.safe_title
                        , description: Res.alt
                        , image: _{ url: Res.img }}},
    reply(Msg, Object).

handler([], Msg) :- !,
    http_get("https://xkcd.com/info.0.json", Res, [json_object(dict)]),
    send_xkcd(Msg, Res).

handler([_Id|_], Msg) :- !,
    http_get("https://xkcd.com/$_Id/info.0.json", Res, [json_object(dict)]),
    send_xkcd(Msg, Res).