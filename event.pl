:- module(
     event,
     [on_event/4, run_listeners/1]
   ).

:- use_module(library(broadcast)).
:- use_module(library(clpfd)).


:- use_module(prolapse(util)).

integer_time(IT) :-
  get_time(FT),
  IT is round(FT).

run_listeners(Msg) :-
  get_dict(message_id, Msg.d, MsgId),
  dbg(event, "Running listeners for msg ~w", [MsgId]),
  % TODO: run through each listener, call handler, cleanup
  forall(
    (
      Listener = listener(LT, msg(Msg.t, MsgId), Msg),
      listening(prolapse, Listener, _),
      broadcast_request(Listener),
      dbg(event, "Running listener listener(~w, ~w, ~w)", [LT, Msg.t, MsgId])
    ),
    maybe_cleanup_listener(Listener)
  ).
run_listeners(_).

listener_type(once).
listener_type(forever).
listener_type(time(_Seconds, _Created)).

maybe_cleanup_listener(X) :-
  dbg(event, "cleanup: ~w", [X]), fail.
maybe_cleanup_listener(listener(once, MsgTemplate, _)) :-
  dbg(event, "Cleaning up once listener ~w", [MsgTemplate]),
  unlisten(listener(once, MsgTemplate, _)).
maybe_cleanup_listener(listener(time(Seconds, Then), MsgTemplate, Goal)) :-
  integer_time(Now),
  Now #>= Then + Seconds,
  true.
  %% unlisten(listener(time)).
  

on_event(LT, MsgType, MsgId, Handler) :-
  Listener = listener(LT, msg(MsgType, MsgId), Msg),
  dbg(event, "Adding listener ~w", [Listener]),
  listen(
    prolapse,
    Listener,
    (
      call(Handler, Msg)
    )
  ).
  
