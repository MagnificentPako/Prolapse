:- module(
     unit_db,
     []
   ).

:- use_module(library(persistency)).

:- persistent
   convert(from:atom, factor:number, to:atom).

attach_db(File) :-
  db_attach(File, []).

add_unit(From, Factor, To) :-
  assert_convert(From, Factor, To).

get_unit(From, Factor, To) :-
  convert(From, Factor, To).
get_unit(From, 1, From).
