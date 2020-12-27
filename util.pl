:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).
:- use_module(library(clpfd)).
:- use_module(library(pio)).
:- use_module(library(aggregate)).


words(S, W) :- split_string(S, " ", "", W).
unwords(W, S) :-
    reverse(W, R),
    foldl(string_concat, R, "", S).

cb(S, Lang) --> "```", Lang, "\n", S, "```".
cb(S) --> cb(S, "").

codeblock(Str, Res) :-
    codeblock(Str, "", Res).
codeblock(Str, Lang, Res) :-
    phrase(cb(Str, Lang), As),
    string_codes(Res, As).


not_from_me(Msg) :-
    get_config(id, MyId),
    format("MyId is ~a\n", [MyId]),
    (
      get_msg_author(Msg, AuthorId),
      dif(MyId, AuthorId)
    ) ; true.

% given a msg dict, return the author ID, if any
get_msg_author(Msg, Author) :-
    _{
      d: _{author: _{id: Author}}
    } :< Msg.
    

% dcg utils
lines([])     --> call(eos), !.
lines([L|Ls]) --> line(L), lines(Ls).

line([])     --> ( "\n" | call(eos) ), !.
line([C|Cs]) --> [C], line(Cs).

list([])     --> [].
list([L|Ls]) --> [L], list(Ls).

count(Elem, List, Count) :-
    findall(_, member(Elem, List), Cs),
    length(Cs, Count).

state(S), [S] --> [S].

state(S0, S), [S] --> [S0].

% push_state(S), [S] --> [].

:- op(920,fy, *).

*_. 

