:- module(
     test_plugin,
     [plugin/2]
   ).

:- use_module(prolapse(http_lib), [register_slash_command/2]).


plugin(prefix("test"), test_plugin:handler).

handler(_Args, Msg) :-
  register_slash_command(
    Msg.d.guild_id,
    _{
      name: "unit",
      description: "Convert units",
      options: [
        _{
          name: "Unit",
          description: "Unit",
          type: 3,
          required: true,
          choices: [
            _{ name: "Meter", value: m }
          ]
        }
      ]
    }
  ),
  reply(Msg, "Test works").
  
