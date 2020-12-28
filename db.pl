:- module(
     db,
     [
       db_new/2,
       db_get/2,
       db_set/3
     ]
   ).

:- use_module(prolapse(util)).

% NOTE: For now this can be a simple interface
% to a "global storage"(which isn't global)
% and eventually it can be replaced with something proper
% like redis or w/e else fits our needs

:- dynamic prolapse_db/2.


% Creates new entry in db, throws exception if it already exists.
db_new(Key, _) :-
  prolapse_db(Key, _),
  throw(error(already_exists, Key)).

db_new(Key, Value) :-
  dbg(prolapse_db, "Saving ~w = ~w\n", [Key, Value]),
  asserta(prolapse_db(Key, Value)).
  
db_get(Key, Value) :-
  dbg(prolapse_db, "Getting ~w = ~w\n", [Key, Value]),
  prolapse_db(Key, Value).

db_del(Key) :-
  retractall(prolapse_db(Key, _)).

db_set(Key, New, Old) :-
  db_get(Key, Old),
  db_del(Key),
  db_new(Key, New).
  
  


