%% :- set_prolog_flag(verbose_file_search, true).
prolapse_version(1.0).

% The file_search_path/2 predicate is a built in which
% lets you bind an alias to a search directory.
% Here we are binding 'prolapse' to the current directory
% which we retrieve by using a unique predicate prolapse_version/1
% in this file and getting that file's path & directory
% This is required for proper use of modules (unfortunately)
% but it also allows us some flexibility, like aliasing
% `plugins` to the plugin subdir and such.
file_search_path(prolapse, Dir) :-
    source_file(prolapse_version(_), File),
    file_directory_name(File, Dir).

:- use_module(library(prolog_stack)).

:- use_module(prolapse(http_lib)).
:- use_module(prolapse(ws_client)).
:- use_module(prolapse(config)).
:- use_module(prolapse(plugins/raw_plugins)).
:- use_module(prolapse(plugins/user_plugins)).


:- initialization(main, main).

run_bot :-
    load_token,
    load_raw_plugins,
    load_user_plugins,
    start_ws.

main :-
    catch_with_backtrace(
      run_bot,
      E,
      writeln(E)
    ).


%% :- use_module(library(pprint)).
%% :- use_module(library(aggregate)).
%% :- use_module(library(dcg/basics)).
%% :- use_module(library(dcg/high_order)).
%% :- use_module(library(quasi_quotations)).
