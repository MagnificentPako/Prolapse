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
:- use_module(library(debug)).

:- use_module(prolapse(http_lib)).
:- use_module(prolapse(config)).
:- use_module(prolapse(plugins)).
:- use_module(prolapse(discord/shard)).

:- initialization(main, main).

:- debug(prolapse(_)).

run_bot :-
    load_token,
    load_bot_plugins,
    start_shards.

main :-
    catch_with_backtrace(
      run_bot,
      E,
      handle_main_exception(E)
    ).

handle_main_exception(E) :-
    print_message(errror, E).

%% :- check.


%% :- multifile check:checker/2.
%% mychecker :-
%%     writeln("mychecker").
%% check:checker(main:mychecker, "usages of writeln").
