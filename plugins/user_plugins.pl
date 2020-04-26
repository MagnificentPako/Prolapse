:- expand_file_name("plugins/user_plugins/*", Files), load_files(Files, []).

:- multifile user_plugin/2.

handle_user_command(Msg) :-
    string_concat("::", Rest, Msg.d.content),
    split_string(Rest, " ", "", [Cmd|Args]),
    catch(
        run_user_plugin(Cmd, Args, Msg),
        Exception,
        (
            term_string(Exception, AsString),
            codeblock(AsString, "prolog", CB),
            format(string(Error), "An error occurred:\n ~s", [CB]),
            reply(Msg, Error)
        )
    ).

run_user_plugin(Command, _, Msg) :-
    \+ user_plugin(Command, _),
    format(atom(Reply), "~s is not a valid command(run_user_plugin).", [Command]),
    reply(Msg, Reply).
run_user_plugin(Command, Args, Msg) :-
    user_plugin(Command, Handler),
    format("Calling plugin ~a\n", [Handler]),
    call(Handler, Args, Msg).

