
% I thought i had to use this but we might still have to so i'm just keeping it here
% if there's an easier way to "unsplit" a string
words(S, W) :- split_string(S, " ", "", W).
unwords(W, S) :-
    reverse(W, R),
    foldl(string_concat, R, "", S).
