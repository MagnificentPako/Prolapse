:- [http_client].

:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).
:- use_module(library(interpolate)).

:- dynamic me/2.
:- discontiguous command_handler/3.

handle_user_command(Msg) :-
    me(id, Id),
    (\+ Id = Msg.d.author.id),
   format("Trying to run command ~s\n", [Msg.d.content]), fail.
handle_user_command(Msg) :-
    string_concat("::", Rest, Msg.d.content),
    split_string(Rest, " ", "", [Cmd|Args]),
    command_handler(Cmd, Args, Msg), !.
handle_user_command(_, not_saved).


% not quite working yet
command_handler("echo", _, Msg) :-
    string_concat("::echo ", Rest, Msg.d.content),
    send_message(Msg.d.channel_id, Rest).
command_handler("reload", _, Msg) :-
    make,
    send_message(Msg.d.channel_id, "Reloaded.").
%% command_handler("eval", [Args], Res) :-
%%     atom_string(A, Args),
%%     writeln(Args),
%%     Res is A.


:- include(plugins/xkcd).


command_handler(Cmd, _, Msg) :-
    sformat(Response, "~s is not a valid command", [Cmd]),
    send_message(Msg.d.channel_id, Response).