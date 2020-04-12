
:- dynamic config/2.

get_config(Key, Res) :- config(Key, Res), !.
get_config(Key, _) :- throw(config_error(nonexistent, Key)).


set_config(Key, Value) :-
    retractall(config(Key, _)),
    asserta(config(Key, Value)).

load_token :-
    open(".token", read, Stream),
    read_line_to_string(Stream, Token),
    set_config(token, Token).

load_config :-
    load_token.
