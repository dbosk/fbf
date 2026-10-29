# FeedbackFruits: detailed FeedbackFruits data through Canvas

FeedbackFruits (FBF) sends Canvas only an aggregate: one grade per student
and assignment. This package fetches the details behind it, using nothing
but your Canvas API token:

- **peer reviews**: who reviewed whom, the level and score on each rubric
  criterion, the comments, the reviewees' ratings of their reviews and the
  students' reflections;
- **grade breakdowns**: what each student's FBF grade is made of, facet by
  facet, checked against the score Canvas holds;
- **discussions**: the threads of comments, questions and answers in video
  and document activities, with their positions.

It is not made by, or affiliated with, FeedbackFruits. It plays the
browser's part in the LTI launch from Canvas and then reads FBF's own API,
which is not public and changes without notice; see *When FeedbackFruits
changes* below.

## Installation

```
pip install FeedbackFruits
```

This installs the `fbf` command. It uses the configuration of
[canvaslms](https://github.com/dbosk/canvaslms), so log in once with

```
canvaslms login
```

Your token must be a manually generated user token (the usual kind), since
Canvas grants the launch only to unscoped tokens.

## Usage

The commands select courses and assignments with the same options as
canvaslms: `-c` for courses, `-a` for assignments, `-A` for assignment
groups and `-M` for modules, each a regular expression. They print
tab-separated rows (`-d` sets the delimiter), or JSON with `--json`.

```
fbf reviews -c DD1310 -a "Peer review"            # one row per criterion
fbf reviews -c DD1310 -a "Peer review" --long     # one row per comment
fbf reviews -c DD1310 --feedback                  # reviewees' ratings
fbf reviews -c DD1310 --reflections

fbf progress -c DD1310 -a "Video 1"               # grade per student
fbf progress -c DD1310 --long                     # one row per facet
fbf progress -c DD1310 --mismatch                 # Canvas differs from FBF
fbf progress -c DD1310 --unpublished              # points not yet sent

fbf discussions -c DD1310 -a "Lecture video"      # one row per thread
fbf discussions -c DD1310 -a "Lecture video" -l   # one row per post
```

The output contains the students' names and texts: treat it as the
personal data it is.

Only assignments that someone has opened in FBF in this course round have
data; the commands say which have none yet. One launch per Canvas course
gives access to all of its FBF activities.

## When FeedbackFruits changes

When FBF changes its API, the commands stop with an error that names what
changed: the step of the launch, or the name in the data that is missing.
The documentation describes how to recover. In short:

1. In the browser, open the FBF assignment from Canvas with the developer
   tools' network tab recording, and save it as a HAR file, outside any
   repository: it contains your session cookies and students' data.
2. Run `fbf har-diff capture.har`. It compares the capture with the
   shape this version of the package was written for (names only, no
   values) and marks with `!!` the removed names that the package reads.
3. Report it, or fix it, with the diff (the diff holds no values).
4. Delete the HAR file and log out of Canvas and FBF.

## Development

The package is written as literate programs ([noweb](https://www.cs.tufts.edu/~nr/noweb/)):
edit the `.nw` files in `src/fbf/`, never the generated `.py` files.

```
make compile          # tangle and weave
make test             # offline tests, replaying recorded responses
make -C doc fbf.pdf   # the documentation, with the recovery procedure
```

The tests replay pseudonymized recordings of a real course, which are not
in the repository. `CLAUDE.md` and the Testing chapter of the documentation
describe how to record them and how to check for changes in FBF
(`make test PYTESTFLAGS=--live`).
