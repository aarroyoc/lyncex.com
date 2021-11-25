:- use_module(library(charsio)).
:- use_module(library(files)).
:- use_module(library(format)).
:- use_module(library(lists)).

:- use_module('../teruel/teruel.pl').


project("Scryer HTTP Server", "https://github.com/mthom/scryer-prolog/blob/master/src/lib/http/http_server.pl").
project("PostgreSQL Prolog", "https://github.com/aarroyoc/postgresql-prolog/").
project("Teruel", "https://github.com/aarroyoc/teruel/").

run(Input, Output) :-
    portray_clause(aguasal(1:0:0)),
    portray_clause(input_directory(Input)),
    if_not_then(directory_exists(Output), make_directory(Output)),
    portray_clause(output_dir(Output)),
    copy_static_files(Input, Output),
    render_files(Input, Output).

copy_static_files(Input, Output) :-
    append_path(Input, "static", InputStatic),
    directory_exists(InputStatic),
    directory_files(InputStatic, Files),
    maplist(copy_file(InputStatic, Output), Files).

copy_file(Input, Output, File) :-
    append_path(Input, File, InputFile),
    append_path(Output, File, OutputFile),
    portray_clause(copy_file(InputFile, OutputFile)),
    atom_chars(IFAtom, InputFile),
    atom_chars(OFAtom, OutputFile),
    open(IFAtom, read, StreamIn, [type(binary)]),
    open(OFAtom, write, StreamOut, [type(binary)]),
    read_n_chars(StreamIn, _, FileContent),
    '$put_chars'(StreamOut, FileContent),
    close(StreamOut),
    close(StreamIn).

render_files(Input, Output) :-
    append_path(Input, "pages", InputPages),
    directory_exists(InputPages),
    directory_files(InputPages, Pages),
    maplist(render_file(InputPages, Output), Pages).

render_file(Input, Output, Page) :-
    append_path(Input, Page, InputPage),
    file_exists(InputPage),
    append_path(Output, Page, OutputPage),
    portray_clause(render_file(InputPage, OutputPage)),
    findall(Project, (project(Text, Link), Project = ["text"-Text, "link"-Link]), Projects),
    render(InputPage, ["projects"-Projects], RenderPage),
    atom_chars(OPAtom, OutputPage),
    open(OPAtom, write, Stream),
    format(Stream, "~s", [RenderPage]),
    close(Stream).

render_file(Input, Output, Page) :-
    append_path(Input, Page, InputPage),
    directory_exists(InputPage),
    append_path(Output, Page, OutputPage),
    if_not_then(directory_exists(OutputPage), make_directory(OutputPage)),
    directory_files(InputPage, Files),
    maplist(render_file(InputPage, OutputPage), Files).


if_then(Condition, Then) :-
    ( Condition -> Then ; true ).

if_not_then(Condition, Then) :-
    ( Condition -> true ; Then ).

append_path(X, Y, Z) :-
    path_segments(X, XS),
    path_segments(Y, YS),
    append(XS, YS, ZS),
    path_segments(Z, ZS).