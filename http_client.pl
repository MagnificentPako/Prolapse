:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).

send_message(Token, Channel, Message) :-
    sformat(URL, "https://discordapp.com/api/v6/channels/~w/messages", [Channel]),
    sformat(Auth, "Bot ~w", [Token]), 
    http_post( URL
             , json(json{ content:Message })
             , _
             , [request_header(authorization=Auth)]).