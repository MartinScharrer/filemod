TEXMF=${HOME}/texmf
INSTALLDIR=${TEXMF}/tex/latex/filemod
DOCINSTALLDIR=${TEXMF}/doc/latex/filemod
CP=cp
RMDIR=rm -rf
PDFLATEX=pdflatex -interaction=batchmode
LATEXMK=latexmk -pdf -silent

PACKEDFILES=filemod.sty
DOCFILES=filemod.pdf
SRCFILES=filemod.dtx filemod.ins README Makefile


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


.PHONY: test

test: unpack
	@for T in test*.tex; do echo "-------------------------------------------------------------"; echo "${BOLD}$$T${NORMAL}"; pdflatex -interaction=batchmode $$T && echo "${OK}" || echo "${FAIL}"; done

clean:
	-latexmk -C filemod.dtx
	${RM} ${PACKEDFILES} *.zip *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo *.gls *.hd *.sta *.stp
	${RMDIR} tds

install: unpack doc ${INSTALLDIR} ${DOCINSTALLDIR}
	${CP} ${PACKEDFILES} ${INSTALLDIR}
	${CP} ${DOCFILES} ${DOCINSTALLDIR}
	texhash ${TEXMF}

${INSTALLDIR}:
	mkdir -p $@

${DOCINSTALLDIR}:
	mkdir -p $@

ctanify: ${SRCFILES} ${DOCFILES} filemod.tds.zip
	${RM} filemod.zip
	zip filemod.zip $^ 
	unzip -t filemod.zip
	unzip -t filemod.tds.zip

zip: filemod.zip

tdszip: filemod.tds.zip

filemod.zip: ${SRCFILES} ${DOCFILES} | pdfopt
	${RM} $@
	zip $@ $^ 

filemod.tds.zip: ${SRCFILES} ${PACKEDFILES} ${DOCFILES} | pdfopt
	${RMDIR} tds
	mkdir -p tds/tex/latex/filemod
	mkdir -p tds/doc/latex/filemod
	mkdir -p tds/source/latex/filemod
	${CP} ${DOCFILES}    tds/doc/latex/filemod
	${CP} ${PACKEDFILES} tds/tex/latex/filemod
	${CP} ${SRCFILES}    tds/source/latex/filemod
	cd tds; zip -r ../$@ .

