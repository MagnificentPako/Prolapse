:- module(
     util,
     [
       not_from_me/1,
       codeblock/2,
       codeblock/3,
       cb/3,
       cb/4,
       get_msg_author/2,
       save_stuff/2,
       get_stuff/2
     ]
   ).
:- reexport(
     [
       library(dcg/basics),
       library(dcg/high_order),
       library(clpfd),
       library(pio),
       library(aggregate)
     ]
   ).

:- dynamic stuff/2.

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
    get_msg_author(Msg, AuthorId),
    dif(MyId, AuthorId).

% given a msg dict, return the author ID, if any
get_msg_author(Msg, AuthorId) :-
    get_dict(author, Msg.d, Author),
    get_dict(id, Author, AuthorId).

save_stuff(Key, Value) :-
    retractall(stuff(Key, _)),
    asserta(stuff(Key, Value)).

get_stuff(Key, Value) :-
    stuff(Key, Value).

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

