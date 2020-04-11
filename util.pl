
words(S, W) :- split_string(S, " ", "", W).
unwords(W, S) :-
    reverse(W, R),
    foldl(string_concat, R, "", S).



cb(S) --> "```", S, "```".

codeblock(Str, Res) :-
    phrase(cb(Str), As),
    string_codes(Res, As).
