:- [util].

:- multifile command_handler/3.
:- multifile user_plugin/2.

:- use_module(library(pprint)).

user_plugin("cache", handle_cache_command).
user_plugin("cache", another_handler).
user_plugin("list_plugins", list_plugins).

list_plugins(_, Msg) :-
    findall(user_plugin(P, H), user_plugin(P, H), Ps),
    with_output_to(string(Pretty), listing(user_plugin)),
    codeblock(Pretty, "prolog", Res),
    reply(Msg, Res).

handle_cache_command(_, Msg) :-
    reply(Msg, "cache command").

another_handler(_, Msg) :-
    reply(Msg, "foo").


:- multifile raw_plugin/2.
raw_plugin("GUILD_CREATE", initial_cache).

initial_cache(Msg) :-
    select_dict(_{members: Ms, channels: _}, Msg.d, _),
    forall(member(M, Ms), cache_user(M.user)).

%% cache_user(User) :- format("Caching user ~s\n", User.username), fail.
cache_user(User) :-
    retractall(cached(user(User.id, _))),
    assertz(cached(user(User.id, User))).
