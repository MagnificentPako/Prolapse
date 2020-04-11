:- [user_plugins].
:- [raw_plugins/chat].
:- [raw_plugins/ready].
:- [raw_plugins/user_commands].
:- [raw_plugins/caching].

:- multifile raw_plugin/2.

% Since prolog makes it so easy to do this kind of dispatching, I was thinking it would be
% a cool idea to handle every message as a plugin of sorts. We can distinguish between
% "raw" plugins that handle the low level messages such as READY, GUILD_CREATE, etc
% and then we can implement "bang commands" as a "user"(as opposed to raw) plugin for MESSAGE_CREATE

%% run_user_plugin(Command, _, Msg) :-
%%     \+ user_plugin(Command, _),
%%     format(atom(Reply), "~s is not a valid command(run_user_plugin).", [Command]),
%%     reply(Msg, Reply).
%% run_user_plugin(Command, Args, Msg) :-
%%     user_plugin(Command, Handler),
%%     format("Calling plugin ~a\n", [Handler]),
%%     call(Handler, Args, Msg).

run_raw_plugins(MsgType, Msg) :-
    raw_plugin(MsgType, Handler),
    call(Handler, Msg).
