:- [plugins/user_plugins].

:- expand_file_name("plugins/raw_plugins/*", Files), load_files(Files, []).

:- multifile raw_plugin/2.

% Since prolog makes it so easy to do this kind of dispatching, I was thinking it would be
% a cool idea to handle every message as a plugin of sorts. We can distinguish between
% "raw" plugins that handle the low level messages such as READY, GUILD_CREATE, etc
% and then we can implement "bang commands" as a "user"(as opposed to raw) plugin for MESSAGE_CREATE

run_raw_plugins(MsgType, Msg) :-
    raw_plugin(MsgType, Handler),
    call(Handler, Msg).
