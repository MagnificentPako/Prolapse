:- module(
     plugins,
     [load_plugins/3]
   ).

load_plugins(BasePath, Predicate, Plugins) :-
  string_concat(BasePath, "/*.pl", GlobPath),
  expand_file_name(GlobPath, Files),
  findall(
    plugin(Message, Handler),
    (
      member(File, Files),
      absolute_file_name(File, AbsPath),
      format("Loading file ~w\n", [AbsPath]),
      load_files(
        File,
        [
          if(true),
          redefine_module(true),
          %% module(blah),
          imports([]),
          must_be_module(true)
        ]
      ),
      module_property(Module, file(AbsPath)),
      module_property(Module, exports(E)),
      format("Loaded module '~w' with exports ~w\n", [Module, E]),
      member(Predicate/2, E),
      call(Module:Predicate, Message, Handler),
      Handler = _:_
    ),
    Plugins
  ).
