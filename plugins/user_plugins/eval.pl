:- dynamic have_responded_to/2.
:- dynamic user_plugin/2.
:- multifile user_plugin/2.


user_plugin("def", def_plugin).
user_plugin("ask", ask_plugin).
user_plugin("undef", undef_plugin).


def_plugin(Args, Msg) :-
    atomic_list_concat(Args, " ", A),
    %% atom_string(A, Str),
    read_term_from_atom(A, T, []),
    writeln(T),
    T,
    reply(Msg, "Defined.").

undef_plugin([Arg], Msg) :-
    atom_string(A, Arg),
    retractall(A),
    reply(Msg, "Undefined.").

ask_plugin(Args, Msg) :-
    have_responded_to(Msg.d.id, MyReplyId),
    !,
    sub_string(Msg.d.content, 6, _, 0, Content),
    do_eval(Content, NewResult),
    edit_message(Msg.d.channel_id, MyReplyId, NewResult, _).

ask_plugin(Args, Msg) :-
    sub_string(Msg.d.content, 6, _, 0, Content),
    do_eval(Content, CB),
    reply(Msg, CB, Res),
    Tag = have_responded_to(Msg.d.id, Res.id),
    format("Saving ~p\n", [Tag]),
    assertz(Tag).

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


do_eval_throws(Content, CB) :-
    %with_output_to(string(Str), call(T)),
    %aggregate_all(bag(X), T, Result),
    %writeln(Result),
    %term_to_atom(Result, Str),
    text_to_string(Content, Content_),
    atom_string(Atom, Content_),
    atom_to_term(Atom, Result, []),
    writeln(Result),
    free_variables(Result, _, [], Vars),
    writeln(Vars),
    Str = "",
    !,
    codeblock(Str, "prolog", CB).
