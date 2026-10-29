# The $(eval $(call def_target, ...)) loop below registers the per-file
# tangling rules at parse time, which makes the first generated rule the
# default goal unless we pin it explicitly.
.DEFAULT_GOAL := all

define find_tests
find ../src -type f -name '*.nw' | xargs grep "<<test \[\[[^.]*\.py\]\]>>" | \
	sed -En "s/^(.*):.*<<test \[\[([^.]*)\.py\]\]>>.*/test_\2.py:\1/p" | sort -u
endef

define def_target
$(shell echo $1 | cut -d: -f1): $(shell echo $1 | cut -d: -f2)
	notangle ${NOTANGLEFLAGS.py} "-Rtest [[$$(shell echo $$@ | sed 's/^test_//')]]" $$^ > $$@
endef

.DELETE_ON_ERROR:

PYTESTFLAGS+=
# The command that runs pytest; override it to use another environment,
# e.g. make all PYTEST="/path/to/venv/bin/python -m pytest".
PYTEST?=	poetry run pytest

TESTS=	$(shell ${find_tests})

$(foreach files,${TESTS},$(eval $(call def_target, ${files})))

.PHONY: all
all: conftest.py
all: $(foreach files,${TESTS},$(shell echo ${files} | cut -d: -f1))
	${PYTEST} ${PYTESTFLAGS}

# The Testing chapter's conftest.py also holds the example fetchers that
# the other chapters register, so it is tangled from all of them.
conftest.py: $(wildcard ../src/fbf/*.nw)
	notangle ${NOTANGLEFLAGS.py} "-R[[conftest.py]]" $^ > $@

.PHONY: clean
clean:
	${RM} conftest.py
	${RM} $(foreach files,${TESTS},$(shell echo ${files} | cut -d: -f1))
	${RM} -Rf __pycache__

.PHONY: distclean
distclean:

INCLUDE_MAKEFILES=../makefiles
include ${INCLUDE_MAKEFILES}/noweb.mk
