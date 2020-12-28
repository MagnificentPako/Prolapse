:- module(
       user_plugins,
       [
           handle_user_command/1,
           run_user_plugin/3,
           load_user_plugins/0
       ]
   ).
%% :- expand_file_name("plugins/user_plugins/*", Files), load_files(Files, []).

:- use_module(prolapse(util)).
:- use_module(prolapse(plugins), [load_plugins/3]).

handle_user_command(Msg) :-
    catch_with_backtrace(
        (
            string_concat("::", Rest, Msg.d.content),
            split_string(Rest, " ", "", [Cmd|Args]),
            run_user_plugin(Cmd, Args, Msg)
        ),
        Exception,
        handle_command_exception(Exception, Msg)
    ).

handle_command_exception(Exception, Msg) :-
    message_to_string(Exception, AsString),
    codeblock(AsString, "prolog", CB),
    format(string(Error), "An error occurred:\n ~s", [CB]),
    reply(Msg, Error).
    

load_user_plugins :-
    dbg(plugins, "Loading user plugins"),
    load_plugins("plugins/user_plugins", user_plugin, Ps),
    dbg(plugins, "Loaded"),
    save_stuff(user_plugins, Ps).

%% run_user_plugin(Command, _, Msg) :-
%%     \+ user_plugin(Command, _),
%%     format(atom(Reply), "~s is not a valid command(run_user_plugin).", [Command]),
%%     reply(Msg, Reply).
run_user_plugin(Command, Args, Msg) :-
    not_from_me(Msg),
    get_stuff(user_plugins, Ps),
    member(
        plugin(Command, Handler),
        Ps
    ),
    dbg(user_plugins, "Calling plugin ~w\n", [Handler]),
    call(Handler, Args, Msg).

