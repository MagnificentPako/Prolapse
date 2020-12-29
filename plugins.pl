:- module(
     plugins,
     [
       load_plugins/2,
       plugin_type/1,
       load_bot_plugins/0,
       run_plugins/1
     ]
   ).

:- use_module(prolapse(util)).

plugin_type(raw(_)).
plugin_type(prefix(_)).
plugin_type(slash_command(_)).

valid_plugin(plugin(Type, _)) :-
  plugin_type(Type), !.
valid_plugin((plugin(Type, _))) :-
  \+ plugin_type(Type),
  throw(error(invalid_plugin_type, Type)).

load_plugins(BasePath, Plugins) :-
  string_concat(BasePath, "/*.pl", GlobPath),
  expand_file_name(GlobPath, Files),
  findall(
    plugin(Type, Handler),
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
      module_property(Module, exports(E)),
      member(plugin/2, E),
      Module:plugin(Type, Handler),
      Handler = _:_,
      dbg(plugins, "Loaded plugin ~w ~w", [Type, Handler])
    ),
    Plugins
  ).

load_bot_plugins :-
  dbg(plugins, "Loading bot plugins"),
  load_plugins("plugins",  Ps),
  save_stuff(plugins, Ps).


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
    debug(plugins, "~s", AsString).
    %% codeblock(AsString, "prolog", CB),
    %% format(string(Error), "An error occurred:\n ~s", [CB]),
    %% reply(Msg, Error).

run_if_match(plugin(Type, Handler), Msg) :-
  %% dbg(plugins, "Matching ~w <-> ~w", [Type, Msg.t]),
  match(Type, Msg),
  not_from_me(Msg),
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
  
      
%% match(T, _) :- dbg(plugins, "Couldn't match type ~w", [T]), fail.
