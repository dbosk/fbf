.PHONY: all
all: fbf.pdf

fbf.pdf: preamble.tex
fbf.pdf: ../src/fbf/init.tex
fbf.pdf: ../src/fbf/launch.tex
fbf.pdf: ../src/fbf/api.tex
fbf.pdf: ../src/fbf/har.tex
fbf.pdf: ../src/fbf/schema.tex
fbf.pdf: ../src/fbf/canvas.tex
fbf.pdf: ../src/fbf/discussions.tex
fbf.pdf: ../src/fbf/cli.tex

# The woven .tex files need their .nw as prerequisite for an edited source
# to trigger a re-weave.
../src/fbf/%.tex: ../src/fbf/%.nw
	${MAKE} -C ../src/fbf $*.tex

.PHONY: clean
clean:
	${RM} fbf.pdf

.PHONY: distclean
distclean:

INCLUDE_MAKEFILES=../makefiles
include ${INCLUDE_MAKEFILES}/tex.mk
