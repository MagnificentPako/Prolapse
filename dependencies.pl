:- use_module(library(prolog_pack)).

:- initialization(packages, main).

packages :-
    O = [ interactive(false), silent(true) ],
    pack_install(interpolate, O),
    writeln("Packages installed.").
    