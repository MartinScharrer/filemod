CONTRIBUTION  = filemod
NAME          = Martin Scharrer
EMAIL         = martin.scharrer@web.de
DIRECTORY     = /macros/latex/contrib/${CONTRIBUTION}
LICENSE       = free
FREEVERSION   = lppl
FILE          = ${CONTRIBUTION}.tar.gz
export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION FILE


MAINDTX    = ${CONTRIBUTION}.dtx
DTXFILES   = ${MAINDTX}
INSFILES   =
SRCFILES   = ${CONTRIBUTION}.sty filemod-expmin.sty
DOCFILES   = ${CONTRIBUTION}.pdf README
PLAINFILES = ${CONTRIBUTION}.tex filemod-expmin.tex
SCRFILES    =
CTANFILES  = ${DTXFILES} ${INSFILES} ${DOCFILES} \
			 $(addsuffix =tex/generic/${CONTRIBUTION}/, ${PLAINFILES}) \
			 $(addsuffix =scripts/${CONTRIBUTION}/, ${SCRFILES})
	

TEXMF    = ${HOME}/texmf
SRCDIR   = ${TEXMF}/tex/latex/${CONTRIBUTION}/
DOCDIR   = ${TEXMF}/doc/latex/${CONTRIBUTION}/
PLAINDIR = ${TEXMF}/tex/generic/${CONTRIBUTION}/
SCRDIR   = ${TEXMF}/scripts/${CONTRIBUTION}/

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

${CONTRIBUTION}.pdf: ${DTXFILES} ${SRCFILES} ${INSFILES}
	${MAKE} --no-print-directory build


build:
	-mkdir ${BUILDDIR} 2>/dev/null || true
	cp ${INSFILES} README ${BUILDDIR}/
	tex '\input ydocincl\relax\includefiles{${CONTRIBUTION}.dtx}{${BUILDDIR}/${CONTRIBUTION}.dtx}' && ${RM} ydocincl.log
	cd ${BUILDDIR} && tex ${CONTRIBUTION}.dtx
	cd ${BUILDDIR} && ${LATEXMK} ${CONTRIBUTION}.dtx
	cd ${BUILDDIR} && ctanify --pkgname "${CONTRIBUTION}" ${CTANFILES}
	cd ${BUILDDIR} && cp ${CONTRIBUTION}.tar.gz ${CONTRIBUTION}.pdf ..


clean:
	latexmk -C ${CONTRIBUTION}.dtx
	${RM} ${CLEANFILES}
	${RM} -r build ${FILE}


distclean:
	latexmk -c ${CONTRIBUTION}.dtx
	${RM} ${CLEANFILES}
	${RM} -r build

install: build $(addprefix ${BUILDDIR}/,${SRCFILES} ${DOCFILES} ${PLAINFILES} ${SCRFILES})
ifneq ($(strip $(DOCFILES)),)
		test -d "${DOCDIR}" || mkdir -p "${DOCDIR}"
		cd ${BUILDDIR} && cp ${DOCFILES} "${DOCDIR}"
endif
ifneq ($(strip $(SRCFILES)),)
		test -d "${SRCDIR}" || mkdir -p "${SRCDIR}"
		cd ${BUILDDIR} && cp ${SRCFILES} "${SRCDIR}"
endif
ifneq ($(strip $(PLAINFILES)),)
		test -d "${PLAINDIR}" || mkdir -p "${PLAINDIR}"
		cd ${BUILDDIR} && cp ${PLAINFILES} "${PLAINDIR}"
endif
ifneq ($(strip $(SCRFILES)),)
		test -d "${SCRDIR}" || mkdir -p "${SCRDIR}"
		cd ${BUILDDIR} && cp ${SCRFILES} "${SCRDIR}"
endif
	test -f ${TEXMF}/ls-R && texhash ${TEXMF}


installsymlinks:
	test -d "${SRCDIR}" || mkdir -p "${SRCDIR}"
	-cd ${SRCDIR} && ${RM} ${SRCFILES}
	ln -s $(addprefix ${PWD}/,${SRCFILES}) ${SRCDIR}
	test -f ${TEXMF}/ls-R && texhash ${TEXMF}


uninstall:
	${RM} ${SRCDIR} ${DOCDIR} ${PLAINDIR} ${SCRDIR}
	test -f ${TEXMF}/ls-R && texhash ${TEXMF}

