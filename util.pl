:- quasi_quotation_syntax(message).


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

/*
:- set_prolog_flag(double_quotes, chars).

message_syntax(_, _, []) -->
    "".

message_syntax(Vars, _Dict, [mention(user, Id)]) -->
    '@',
    number(Nth),
    !,
    { nth0(Nth, Vars, Id) }.

message_syntax(Vars, Dict, [E|Elem]) -->
   [E], message_syntax(Vars, Dict, Elem).

message(Content, Vars, Dict, Mention) :-
    phrase_from_quasi_quotation(message_syntax(Vars, Dict, Mention), Content).
*/