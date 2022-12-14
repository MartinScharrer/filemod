The filemod Package
~~~~~~~~~~~~~~~~~~~
Copyright (c) 2011-2022 Martin Scharrer <martin.scharrer@web.de>

This package provides macros to read and compare the modification dates
of files. These files can be .tex files, images or other files as long as they can be
found by the LaTeX compiler. It uses the \pdffilemoddate primitive of pdfLaTeX
to receive the file modification date as PDF date string, parses it and returns
the value to the user.
The functionality is provided by purely expandable macros or by faster but non-expandable ones.

This package will work with LaTeX and plain eTeX as long pdf(La)TeX (in
PDF or DVI mode) or Lua(La)TeX is used. Xe(La)TeX is not supported because it
does not provide \pdffilemoddate.

Examples:
    % Prints file modification date and time of main file
    \filemodprint{\jobname}

    % Include newest of a set of files:
    \input{\filemodNewest{{file1}{file2}{file3}}}

    % Include newest of a set of images:
    % (\includegraphics doesn't expand its fully before parsing it)
    \FilemodNewest{{file1}{file2}{file3}}
    \includegraphics{\filemodresultfile}


REQUIREMENTS:
=============
pdflatex v1.30.0 or later is required.
Alternative LuaTeX can be used together with the `pdftexcmds` package.


INSTALLATION:
=============
Compile the DTX file (with included INS file) through pdflatex:

    pdflatex filemod.dtx
    pdflatex filemod.dtx
    pdflatex filemod.dtx

Copy the files to the following directories which must be created beforehand.
Example for a Unix/Linux OS, change accordantly for MS Windows and Mac, e.g.
copy it using a graphics interface.

    cp filemod*.sty ${TEXMF}/tex/latex/filemod/
    cp filemod*.tex ${TEXMF}/tex/generic/filemod/

OPTIONAL:
The documentation can be installed by:
    cp filemod.pdf README  ${TEXMF}/doc/latex/filemod/

The source can be installed by:
    cp filemod.dtx  ${TEXMF}/source/latex/filemod/

The TEXMF is /usr/local/texlive/2010/texmf-dist, ${HOME}/texmf or similar.

