:- module(
     units,
     []
   ).


convert(m, cm, 100).
convert(cm, mm, 10).
convert(inch, cm, 2.54).

%% convert(X, Y, R) :-
%%     convert(X, Z, R1),
%%     convert(Z, Y, R2),
%%     R is R1 * R2.
%% convert(X, Y, R) :-
%%     convert(Y, X, R1),
%%     R is 1 / R1.
