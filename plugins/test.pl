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

build_definition(Def) :-
  get_stuff(plugins, Plugins),
  build_options_from_plugins(Plugins, Opts),
  app_command_dict(
    app_command(
      "run",
      "Run a command",
      Opts
    ),
    Def
  ).

build_options_from_plugins(Plugins, Opts) :-
  findall(
    option(string, Prefix, Prefix),
    (
      member(P, Plugins),
      P = plugin(prefix(Prefix), _),
      dbg(foo, "~w", [P])
    ),
    Opts
  ).

app_command_dict(
  app_command(Name, Description, Options),
  _{
    name: Name,
    description: Description,
    options: Commands
  }
) :-
  maplist(option_dict, Options, Commands).

option_dict(
  option(Type, Name, Description),
  _{
    type: IType,
    name: Name,
    description: Description
  }
) :-
  option_type(IType, Type).

option_type(1, subcommand).
option_type(2, subcommand_group).
option_type(3, string).
option_type(4, integer).
option_type(5, boolean).
option_type(6, user).
option_type(7, channel).
option_type(8, role).
  

handler(Msg) :-
  reply(Msg, "Test works").
  
