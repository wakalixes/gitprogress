# gitprogress
create a video animation of the diff changes of a tex-file in a git repository

workflow: extract_tex.sh -> diff_images.sh -> compile_movie.sh

this collection of bash scripts was used to create an animation of the editing progress of a tex-file within a git repository

supports automatic concatenation of included tex-files using the \input{} command

uses a patched version of diffuse for creating the diff image

**requirements:**

* git repository

* modified copy of diffuse

* imagemagick

* ffmpeg

relative paths have to be customized
