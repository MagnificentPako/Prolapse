:- [user_plugins].

% Since prolog makes it so easy to do this kind of dispatching, I was thinking it would be
% a cool idea to handle every message as a plugin of sorts. We can distinguish between
% "raw" plugins that handle the low level messages such as READY, GUILD_CREATE, etc
% and then we can implement "bang commands" as a "user"(as opposed to raw) plugin for MESSAGE_CREATE


raw_plugin("READY", Msg) :-
    writeln("READY plugin, saving user id"),
    asserta(me(Msg.d.user.id)).

raw_plugin("MESSAGE_CREATE", Msg) :-
    format("~s says: ~s\n", [Msg.d.author.username, Msg.d.content]).
raw_plugin("MESSAGE_CREATE", Msg) :-
   handle_user_command(Msg).
