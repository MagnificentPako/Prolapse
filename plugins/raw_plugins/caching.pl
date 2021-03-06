:- [util].

:- multifile command_handler/3.
:- multifile user_plugin/2.

:- use_module(library(pprint)).

user_plugin("cache", handle_cache_command).


handle_cache_command(_, Msg) :-
    reply(Msg, "cache command").


:- multifile raw_plugin/2.
raw_plugin("GUILD_CREATE", initial_cache).

initial_cache(Msg) :-
    select_dict(_{members: Ms, channels: _}, Msg.d, _),
    forall(member(M, Ms), cache_user(M.user)).

%% cache_user(User) :- format("Caching user ~s\n", User.username), fail.
cache_user(User) :-
    retractall(cached(user(User.id, _))),
    assertz(cached(user(User.id, User))).
