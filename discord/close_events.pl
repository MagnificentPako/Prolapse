:- module(
     close_events,
     [close_event/2]
   ).

close_event(4000, unknown_error).
close_event(4001, unknown_op).
close_event(4002, decode_error).
close_event(4003, not_authorized).
close_event(4004, auth_failed).
close_event(4005, already_authenticated).
close_event(4007, invalid_seq).
close_event(4008, rate_limited).
close_event(4009, session_timed_out).
close_event(4010, invalid_shard).
close_event(4011, sharding_required).
close_event(4012, invalid_api_version).
close_event(4013, invalid_intent).
close_event(4014, disallowed_intent).
