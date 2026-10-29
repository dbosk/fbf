# notangle exits with status 2 when a chunk is used but never defined, and
# tangles the use as nothing.  The shared noweb.mk pipes notangle into cpif,
# so without pipefail the pipeline reports cpif's status and the build goes
# on with code silently missing.  pipefail makes the undefined chunk fail the
# build; .DELETE_ON_ERROR removes the incomplete output.
SHELL=		/bin/bash
.SHELLFLAGS=	-o pipefail -c
.DELETE_ON_ERROR:

MODULES+=	init.nw
MODULES+=	launch.nw
MODULES+=	api.nw
MODULES+=	har.nw
MODULES+=	schema.nw

.PHONY: all
all: __init__.py ${MODULES:.nw=.tex}
all: $(filter-out init.py,${MODULES:.nw=.py})

__init__.py: init.nw
	notangle -R"[[__init__.py]]" $< | cpif $@

.PHONY: clean
clean:
	${RM} __init__.py $(filter-out init.py,${MODULES:.nw=.py})
	${RM} ${MODULES:.nw=.tex}

.PHONY: distclean
distclean:
	${RM} -Rf __pycache__

INCLUDE_MAKEFILES=../../makefiles
include ${INCLUDE_MAKEFILES}/noweb.mk
