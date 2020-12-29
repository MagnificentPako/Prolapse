:- module(
     plugins,
     [
       load_plugins/2,
       plugin_type/1,
       load_bot_plugins/0,
       run_plugins/1
     ]
   ).

:- use_module(prolapse(http_lib)).
:- use_module(prolapse(util)).

% TODO: refactor to new file and improve
plugin_type(raw(_)).
plugin_type(prefix(_)).
plugin_type(slash_command(_)).

error:has_type(plugin_type, X) :-
  plugin_type(X).

valid_plugin(plugin(Type, _)) :-
  must_be(plugin_type, Type).

load_modules_and_exports(BasePath, Modules) :-
  string_concat(BasePath, "/*.pl", GlobPath),
  expand_file_name(GlobPath, Files),
  findall(
    module(Module, Exports),
    (
      % for every file
      member(File, Files),
      absolute_file_name(File, AbsPath),
      %% dbg(plugins, "Checking file ~w", [AbsPath]),
      % load the file without any imports
      load_files(
        File,
        [
          if(true),
          redefine_module(true),
          imports([]),
          must_be_module(true)
        ]
      ),
      % this is required to recover the module identifier from the file path
      module_property(Module, file(AbsPath)),
      % get the module exports
      module_property(Module, exports(Exports))
    ),
    Modules
  ).

slash_run_handler(OrigHandler, Msg) :-
  dbg(plugins, "Inside eval slash handler"),
  call(OrigHandler, Msg).

slash_register(BuildDef, ReadyMsg) :-
  call(BuildDef, Definition),
  dbg(plugins, "~w", [Definition]),
  get_dict(guilds, ReadyMsg.d, RawGuilds),
  maplist(get_dict(id), RawGuilds, Guilds),
  forall(
    member(Guild, Guilds),
    register_slash_command(Guild, Definition)
  ).

% process_plugin takes a plugin and returns a list of handlers
process_plugin(P, [P]) :-
  P = plugin(PT, _),
  (
    PT = raw(_) ;
    PT = prefix(_)
  ).
process_plugin(plugin(slash_command(BuildDefinition), Handler), [Register, Handle]) :-
  Register =
  plugin(
    raw("READY"),
    plugins:slash_register(BuildDefinition)
  ),
  Handle =
  plugin(
    raw("INTERACTION_CREATE"),
    plugins:slash_run_handler(Handler)
  ).
  


load_plugins(BasePath, Plugins) :-
  load_modules_and_exports(BasePath, Modules),
  findall(
    Plugs,
    ( 
      member(module(Module, Exports), Modules),
      member(plugin/2, Exports),
      Module:plugin(PluginType, Handler),
      valid_plugin(plugin(PluginType, Handler)),
      Handler = _:_,
      process_plugin(plugin(PluginType, Handler), Plugs)
    ),
    NestedPlugins
  ),
  flatten(NestedPlugins, Plugins),
  dbg(plugins, "Loaded plugins:" ),
  sort(Plugins, Sorted),
  forall(
    member(plugin(Type, Handler), Sorted),
    dbg(plugins, "~5+~w ~30+~w", [Type, Handler])
  ).

load_bot_plugins :-
  dbg(plugins, "-- Loading plugins"),
  load_plugins("plugins",  Ps),
  save_stuff(plugins, Ps),
  dbg(plugins, "-- Plugins loaded.").

run_plugins(Msg) :-
  get_stuff(plugins, Plugins),
  forall(
    ( member(P, Plugins)
    ),
    catch(
      run_if_match(P, Msg),
      E,
      handle_plugin_exception(E, Msg)
    )
  ).

handle_plugin_exception(Exception, _Msg) :-
    message_to_string(Exception, AsString),
    dbg(plugins, "~s", AsString).
    %% codeblock(AsString, "prolog", CB),
    %% format(string(Error), "An error occurred:\n ~s", [CB]),
    %% reply(Msg, Error).

run_if_match(plugin(Type, Handler), Msg) :-
  %% dbg(plugins, "Matching ~w <-> ~w", [Type, Msg.t]),
  match(Type, Msg),
  %% not_from_me(Msg),
  dbg(plugins, "t = ~w h = ~w", [Type, Handler]),
  call(Handler, Msg).
% either we match and call the plugin or we don't match and don't
% but neither is a failure
run_if_match(_, _).


match(raw(MsgType), Msg) :-
  MsgType = Msg.t.
match(prefix(Cmd), Msg) :-
  get_dict(t, Msg, "MESSAGE_CREATE"),
  % TODO: get prefix from config
  format(string(WithPrefix), "::~w", [Cmd]),
  string_concat(WithPrefix, _, Msg.d.content).
  
      
