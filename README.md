# gitprogress
create a video animation of the diff changes of a tex-file in a git repository

this collection of bash scripts was used to create an animation of the editing progress of a tex-file within a git repository

supports automatic concatenation of included tex-files using the \input{} command

uses a modified version of diffuse to create the diff image

requires
-) git repository
-) modified copy of diffuse
-) imagemagick
-) ffmpeg
