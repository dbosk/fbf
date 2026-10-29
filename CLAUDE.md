# fbf

Extracts detailed FeedbackFruits (FBF) data by playing the browser's part in
the Canvas → FBF LTI 1.3 launch, then using FBF's private JSON:API.

## Layout

Literate programs (noweb). Edit the `.nw` files, never the tangled `.py`/`.tex`
(gitignored). Load the `literate-programming` skill before editing `.nw`.

- `src/fbf/init.nw`: overview chapter, `__init__.py`.
- `src/fbf/launch.nw`: Canvas API token → FBF tokens (sessionless launch,
  hops 0–3, `LaunchError` names the hop).
- `src/fbf/api.nw`: thin JSON:API client (`FBF`, `Document`), bearer auth,
  renewal via `/oauth/token`, else relaunch.
- `src/fbf/canvas.nw`: Canvas assignment → FBF activity (launch-URL `code` =
  placement code), one launch for all.
- `src/fbf/discussions.nw`: `fbf discussions`: threads in video/document
  activities (comments, questions, answers, replies, positions).
- `src/fbf/cli.nw`: standalone `fbf` and `add_command(subp)` for canvaslms;
  commands follow canvaslms's `(config, canvas, args)` convention.
- `src/fbf/har.nw`: `har-shape`/`har-diff`: value-free shapes of HAR captures;
  ends with the **recovery procedure** (section `Recovery`) for when FBF changes.
- `src/fbf/schema.nw`: `REQUIRED` FBF names; extractors read through
  `attribute`/`relationship` (raise `SchemaError`). Each chapter declares its
  names in a `<<required names>>` chunk, tangled into `schema.py` (add the
  chapter to `schema.py:` in `src/fbf/Makefile`); that chunk must not use the
  chapter's own constants.
- `doc/fbf-api-shape.txt`: committed reference shape (names only, no values).
- `doc/fbf.tex`: wraps the woven chapters into `doc/fbf.pdf`.

## Build and test

    make compile                 # tangle + weave src/fbf
    make test                    # tangle tests from <<test [[x.py]]>> chunks, run pytest
    make -C doc fbf.pdf LATEXFLAGS="-interaction=nonstopmode"

## Privacy and secrets

- HAR files hold live session cookies and student data: never in the repo
  (`*.har` is gitignored); keep them in `~/private/fbf-hars/`.
- Never print HAR or API values to inspect them; use `har-shape`/`har-diff`
  or print keys, counts and statuses only.
- Code never prints tokens; `APIError` never includes response bodies.

## FBF API quirks (learned live)

- Bearer `access_token` is enough; one launch covers all the user's courses.
- One `include=` per request; two give HTTP 500. Some endpoints ignore
  `include=user` (questions, answers): fetch missing users by
  `v1/users?filter[id]=...`.
- Unsupported `filter[...]` is silently ignored (returns everything): always
  check results against the filter.
- Some relationships are bare references without links (activity `tasks`):
  use `include=`; `FBF.related` raises `LookupError` there.
