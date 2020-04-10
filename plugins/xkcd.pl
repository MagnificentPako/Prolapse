send_xkcd(Msg, Res) :-
    Object = _{ embed: _{ title: Res.safe_title
                        , description: Res.alt
                        , image: _{ url: Res.img }}},
    send_message(Msg.d.channel_id, Object).

command_handler("xkcd", [], Msg) :- !,
    http_get("https://xkcd.com/info.0.json", Res, [json_object(dict)]),
    send_xkcd(Msg, Res).

command_handler("xkcd", [Id|_], Msg) :- !,
    writeln("running xkcd command"), 
    http_get("https://xkcd.com/$Id/info.0.json", Res, [json_object(dict)]),
    send_xkcd(Msg, Res).