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

.PHONY: publish publish-github publish-fbf
publish: publish-fbf publish-github

publish-github: doc/fbf.pdf
	git push
	gh release create -t v${version} v${version} doc/fbf.pdf

doc/fbf.pdf: $(wildcard src/fbf/*.nw)
	${MAKE} -C $(dir $@) $(notdir $@)

publish-fbf: build
	poetry publish

.PHONY: clean distclean
clean:
	${MAKE} -C tests clean
distclean:
	${RM} -Rf dist

INCLUDE_MAKEFILES=makefiles
include ${INCLUDE_MAKEFILES}/subdir.mk
