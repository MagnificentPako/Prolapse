:- module(
     units,
     [user_plugin/2]
   ).

:- use_module(prolapse(util)).
:- use_module(unit_db).


user_plugin("units", units:convert_handler).

conversion_request(convert_unit(Val, From, To)) -->
  num(Val), unit(From), middle, unit(To).
conversion_request(convert_unit(Val, From, To)) -->
  num(Val), unit(From), unit(To).

middle --> [to] | [in].

num(N) -->
  [X],
  {
    (
      number(X),
      N = X
    ) ; (
      atom(X),
      atom_string(X, Str),
      number_string(N, Str)
    )
  }.

convert_handler(Args, Msg) :-
  maplist(atom_string, Atoms, Args),
  writeln(Atoms),
  once(phrase(conversion_request(Request), Atoms, [])),
  Request = convert_unit(Val, From, To),
  once(phrase(path_from_to(From, To, []), Path)),
  prod(Path, Factor),
  Res is Val * Factor,
  format(
    string(Reply),
    "~w ~w = ~w ~w\n",
    [Val, From, Res, To]
  ),
  reply(Msg, Reply).

unit(U) --> [U], { unit_db:get_unit(U, _, _) }.


convertible(X, Y, Factor) :-
  unit_db:get_unit(X, Factor, Y).
convertible(X, Y, Factor) :-
  unit_db:get_unit(X, Recip, Y),
  Factor is 1 / Recip.
  
path_from_to(A, A, _) -->
  [].
path_from_to(A, B, Visited) -->
  [Factor],
  { dif(A, Next),
    convertible(A, Next, Factor),
    maplist(dif(Next), Visited)
  },
  path_from_to(Next, B, [A|Visited]).

prod(List, Prod) :-
  foldl(mul, List, 1, Prod).

mul(X, Y, R) :- R is X * Y.

