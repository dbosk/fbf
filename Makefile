SUBDIR_GOALS=	all clean distclean

SUBDIR+=	src/fbf
SUBDIR+=	doc

version=$(shell sed -n 's/^ *version *= *"\([^"]\+\)"/\1/p' pyproject.toml)

.PHONY: all
all: compile

.PHONY: compile
compile:
	${MAKE} -C src/fbf all

.PHONY: test
test: compile
	${MAKE} -C tests all

.PHONY: build
build: compile
	poetry build

.PHONY: clean distclean
clean:
	${MAKE} -C tests clean
distclean:
	${RM} -Rf dist

INCLUDE_MAKEFILES=makefiles
include ${INCLUDE_MAKEFILES}/subdir.mk
