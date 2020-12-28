:- module(
     opcodes,
     [gateway_op/2]
   ).

gateway_op(0, dispatch).
gateway_op(1, heartbeat).
gateway_op(2, identify).
gateway_op(3, presence_update).
gateway_op(4, voice_status_update).
gateway_op(6, resume).
gateway_op(7, reconnect).
gateway_op(8, request_guild_members).
gateway_op(9, invalid_session).
gateway_op(10, hello).
gateway_op(11, heartbeat_ack).
