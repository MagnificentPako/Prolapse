
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
