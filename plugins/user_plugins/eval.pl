:- module(
       eval,
       [user_plugin/2]
   ).

:- use_module(library(sandbox)).

:- use_module(prolapse(http_lib)).
:- use_module(prolapse(util)).

safe_goal(_) :- fail.

user_plugin("def", def_plugin).
user_plugin("ask", ask_plugin).
user_plugin("undef", undef_plugin).
user_plugin("eval", eval:eval_plugin).

run_code(true).
run_code((A, B)) :-
    run_code(goal(A)),
    run_code(goal(B)).
run_code(goal(G)) :-
    run_goal(goal(G)).

run_goal(goal(G)) :-
    dbg(plugin(eval), "run_goal: ~w\n", [G]), fail.
run_goal(goal(G)) :-
    safe_goal(G),
    G.


run_eval(Msg, parse_code(Code, Vars)) :-
    format(string(Str), "Running code ~w\n", [Code]),
    reply(Msg, Str),
    run_code(goal(Code)),
    !,
    member(Name = Result, Vars),
    format(string(Reply), "~w = ~w\n", [Name, Result]),
    reply(Msg, Reply).
    

% given a list of atoms, parse to prolog code
parse_code(ArgList, parse_code(Code, Vars)) :-
    atomic_list_concat(ArgList, " ", Atom),
    read_term_from_atom(
        Atom,
        Code,
        [
            variable_names(Vars)
        ]
    ).

eval_plugin(Args, Msg) :-
    writeln(Args),
    parse_code(Args, Code),
    run_eval(Msg, Code).


def_plugin(Args, Msg) :-
    atomic_list_concat(Args, " ", A),
    %% atom_string(A, Str),
    read_term_from_atom(A, T, []),
    writeln(T),
    T,
    reply(Msg, "Defined.").

%% undef_plugin([Arg], Msg) :-
%%     atom_string(A, Arg),
%%     retractall(A),
%%     reply(Msg, "Undefined.").

%% ask_plugin(Args, Msg) :-
%%     have_responded_to(Msg.d.id, MyReplyId),
%%     !,
%%     do_eval(Args, NewResult),
%%     edit_message(Msg.d.channel_id, MyReplyId, NewResult, _).

%% ask_plugin(Args, Msg) :-
%%     do_eval(Args, CB),
%%     reply(Msg, CB, Res),
%%     Tag = have_responded_to(Msg.d.id, Res.id),
%%     format("Saving ~p\n", [Tag]),
%%     assertz(Tag).

do_eval(Args, Res) :-
    catch(
        do_eval_throws(Args, Res),
        Exception,
        (
            term_string(Exception, AsString),
            codeblock(AsString, "prolog", CB),
            format(string(Res), "An error occurred:\n ~s", [CB])
        )
    ).

do_eval_throws(Args, CB) :-
    atomic_list_concat(Args, " ", A),
    read_term_from_atom(A, T, []),
    T,
    !,
    term_string(T, Str),
    codeblock(Str, "prolog", CB).
