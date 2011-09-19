TEXMF=${HOME}/texmf
INSTALLDIR=${TEXMF}/tex/latex/filemod
DOCINSTALLDIR=${TEXMF}/doc/latex/filemod
CP=cp
RMDIR=rm -rf
PDFLATEX=pdflatex -interaction=batchmode
LATEXMK=latexmk -pdf -silent

LATEXFILES=filemod.sty filemod-expmin.sty
TEXFILES=filemod.tex filemod-expmin.tex
PACKEDFILES=${LATEXFILES} ${TEXFILES}
DOCFILES=filemod.pdf README
SRCFILES=filemod.dtx filemod.ins


RED   = \033[01;31m
GREEN = \033[01;32m
BOLD  = \033[01m
NORMAL = \033[00m

OK = ${GREEN}OK${NORMAL}
FAIL = ${RED}FAILURE${NORMAL}

all: doc

package: unpack
class: unpack

${PACKEDFILES}: filemod.dtx filemod.ins
	yes | pdflatex filemod.ins

unpack:
	${PDFLATEX} filemod.dtx

# 'doc' and 'filemod.pdf' call itself until everything is stable
doc: filemod.pdf
	@${MAKE} --no-print-directory filemod.pdf

pdfopt: doc
	@-pdfopt filemod.pdf .temp.pdf && mv .temp.pdf filemod.pdf

%.pdf: %.dtx
	${PDFLATEX} $<
	-makeindex -s gind.ist -o "$@" "$<"
	-makeindex -s gglo.ist -o "$@" "$<"
	${PDFLATEX} $<
	${PDFLATEX} $<
	pdfopt $@ .$@ && mv .$@ $@


.PHONY: test

test: unpack
	@for T in test*.tex; do echo "-------------------------------------------------------------"; echo "${BOLD}$$T${NORMAL}"; pdflatex -interaction=batchmode $$T && echo "${OK}" || echo "${FAIL}"; done

clean:
	-latexmk -C filemod.dtx
	${RM} ${PACKEDFILES} *.zip *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo *.gls *.hd *.sta *.stp *.cod
	${RMDIR} tds

install: unpack doc ${INSTALLDIR} ${DOCINSTALLDIR}
	${CP} ${PACKEDFILES} ${INSTALLDIR}
	${CP} ${DOCFILES} ${DOCINSTALLDIR}
	texhash ${TEXMF}

${INSTALLDIR}:
	mkdir -p $@

${DOCINSTALLDIR}:
	mkdir -p $@

zip: filemod.zip

tdszip: filemod.tds.zip

filemod.zip: ${SRCFILES} ${DOCFILES} filemod.tds.zip
	${RM} $@
	zip $@ $^ 

filemod.tds.zip: ${SRCFILES} ${PACKEDFILES} ${DOCFILES}
	${RMDIR} tds
	mkdir -p tds/tex/latex/filemod
	mkdir -p tds/tex/generic/filemod
	mkdir -p tds/doc/latex/filemod
	mkdir -p tds/source/latex/filemod
	${CP} ${DOCFILES}    tds/doc/latex/filemod
	${CP} ${LATEXFILES}  tds/tex/latex/filemod
	${CP} ${TEXFILES}    tds/tex/generic/filemod
	${CP} ${SRCFILES}    tds/source/latex/filemod
	cd tds; zip -r ../$@ .

ctanify: filemod.zip
	# Check if PDFs are identical
	${RM} -rf .test
	mkdir .test && cd .test && unzip ../filemod.zip
	cd .test && unzip filemod.tds.zip
	cd .test && cmp -s filemod.pdf doc/latex/filemod/filemod.pdf
	${RM} -rf .test

###########################
# CTAN Upload
CTAN=http://dante.ctan.org/upload.html
CONTRIBUTION=filemod
VERSION=
NAME=Martin Scharrer
EMAIL=martin@scharrer-online.de
SUMMARY=Updated to ${VERSION}:
DIRECTORY=/macros/latex/contrib/${CONTRIBUTION}
DONOTANNOUNCE=
ANNOUNCEMENT=
NOTES=
LICENCE=free
FREEVERSION=lppl
#FILE= # can't be set because of security limitations

upload: ctanify
	${CP} filemod.zip /tmp
	firefox 'http://dante.ctan.org/upload.html?contribution=${CONTRIBUTION}&version=${VERSION}&name=${NAME}&email=${EMAIL}&summary=${SUMMARY}&directory=${DIRECTORY}&DoNotAnnounce=${DONOTANNOUNCE}&announce=${ANNOUNCEMENT}&notes=${NOTES}&license=${LICENCE}&freeversion=${FREEVERSION}' &

