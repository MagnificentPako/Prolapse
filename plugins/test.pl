:- module(
     test_plugin,
     [plugin/2]
   ).

:- use_module(prolapse(http_lib), [register_slash_command/2]).
:- use_module(prolapse(util)).
:- use_module(library(http/json)).



plugin(prefix("test"), test_plugin:handler).
plugin(slash_command(test_plugin:build_definition), test_plugin:slash_handler).

slash_handler(Msg) :-
  json_write(current_output, Msg),
  writeln("Slash handler").

build_definition(
  _{
    name: "prolord",
    description: "Interact with prolord",
    options: Opts 
  }
) :-
  RunCommand =
  _{
    type: 1,
    name: "Command",
    description: "Run a command",
    options: Opts
  },
  get_stuff(plugins, Plugins),
  build_options_from_plugins(Plugins, Opts).

build_options_from_plugins(Plugins, Opts) :-
  findall(
    P,
    (
      member(P, Plugins),
      P = plugin(prefix(_), Handler)
    ),
    PrefixPlugins
  ),
  maplist(to_option, PrefixPlugins, Opts).


:- begin_tests(foo).

test(foo) :-
  build_options_from_plugins(
    [plugin(prefix(foo), handler)],
    X
  ).

:- end_tests(foo).
  

to_option(
  plugin(prefix(C), _),
  _{
    name: C,
    description: C,
    type: 1
  }
).

handler(Msg) :-
  reply(Msg, "Test works").
  
