CONTRIBUTION  = filemod
NAME          = Martin Scharrer
EMAIL         = martin@scharrer-online.de
DIRECTORY     = /macros/latex/contrib/${CONTRIBUTION}
LICENSE       = free
FREEVERSION   = lppl
FILE          = ${CONTRIBUTION}.tar.gz
export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION FILE


MAINDTX    = ${CONTRIBUTION}.dtx
DTXFILES   = ${MAINDTX}
INSFILES   = ${CONTRIBUTION}.ins
SRCFILES   = ${CONTRIBUTION}.sty filemod-expmin.sty
DOCFILES   = ${CONTRIBUTION}.pdf README
PLAINFILES = ${CONTRIBUTION}.tex filemod-expmin.tex
SCRIPTS    =
CTANFILES  = ${DTXFILES} ${INSFILES} ${DOCFILES} \
			 $(addsuffix =tex/generic/${CONTRIBUTION}/, ${PLAINFILES}) \
			 $(addsuffix =scripts/${CONTRIBUTION}/, ${SCRIPTS})
	

TEXMF    = ${HOME}/texmf
LATEXMK  = latexmk -pdf
BUILDDIR = build
AUXEXTS  = .aux .bbl .blg .cod .exa .fdb_latexmk .glo .gls .lof .log .lot .out .pdf .que .run.xml .sta .stp .svn .svt .toc
CLEANFILES = $(addprefix ${CONTRIBUTION}, ${AUXEXTS})

.PHONY: all upload doc clean install uninstall build

all: doc

${FILE}: ${CTANFILES}
	${MAKE} --no-print-directory build


upload: VERSION = $(strip $(shell grep '=\*VERSION' -A1 ${MAINDTX} | tail -n1))

upload: ${FILE}
	ctanupload -p


doc: ${CONTRIBUTION}.pdf

${CONTRIBUTION}.pdf: ${CONTRIBUTION}.dtx ${SRCFILES} ${CONTRIBUTION}.ins
	${MAKE} --no-print-directory build


build:
	-mkdir ${BUILDDIR} 2>/dev/null || true
	cp ${CONTRIBUTION}.ins README ${BUILDDIR}/
	tex '\input ydocincl\relax\includefiles{${CONTRIBUTION}.dtx}{${BUILDDIR}/${CONTRIBUTION}.dtx}' && ${RM} ydocincl.log
	cd ${BUILDDIR} && tex ${CONTRIBUTION}.ins
	cd ${BUILDDIR} && ${LATEXMK} ${CONTRIBUTION}.dtx
	cd ${BUILDDIR} && ctanify ${CTANFILES}
	cd ${BUILDDIR} && cp ${CONTRIBUTION}.tar.gz ${CONTRIBUTION}.pdf ..


clean:
	latexmk -C ${CONTRIBUTION}.dtx
	${RM} ${CLEANFILES}
	${RM} -r build ${FILE}


distclean:
	latexmk -c ${CONTRIBUTION}.dtx
	${RM} ${CLEANFILES}
	${RM} -r build


install: ${CONTRIBUTION}.pdf ${CONTRIBUTION}.sty
	-@mkdir ${TEXMF}/tex/latex/${CONTRIBUTION}/ 2>/dev/null || true
	-@mkdir ${TEXMF}/doc/latex/${CONTRIBUTION}/ 2>/dev/null || true
	-@mkdir ${TEXMF}/tex/generic/${CONTRIBUTION}/ 2>/dev/null || true
	cp ${SRCFILES} ${TEXMF}/tex/latex/${CONTRIBUTION}/
	cp ${PLAINFILES} ${TEXMF}/tex/generic/${CONTRIBUTION}/
	cp ${DOCFILES} ${TEXMF}/doc/latex/${CONTRIBUTION}/
	test -f ${TEXMF}/ls-R && texhash ${TEXMF}


installsymlinks:
	-@mkdir ${TEXMF}/tex/latex/${CONTRIBUTION}/ 2>/dev/null || true
	-cd ${TEXMF}/tex/latex/${CONTRIBUTION}/ && ${RM} ${SRCFILES}
	ln -s $(addprefix ${PWD}/,${SRCFILES}) ${TEXMF}/tex/latex/${CONTRIBUTION}/
	test -f ${TEXMF}/ls-R && texhash ${TEXMF}


uninstall:
	${RM} ${TEXMF}/tex/latex/${CONTRIBUTION}/ ${TEXMF}/doc/latex/${CONTRIBUTION}/
	test -f ${TEXMF}/ls-R && texhash ${TEXMF}

