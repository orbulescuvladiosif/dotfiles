---
description: (dotfiles) Init docs-in-repo — vision, spec, decisions; gated
---

# Init Docs

Set up or update a `docs/` folder that lives in the repo next to the code. The goal: anyone cloning the repo gets the product story, the current spec, and a record of important design choices — without hunting through chat history.

Works in any repo. Dotfiles (`docs/pvd.md`, `docs/requirements.md`, `docs/decisions/`) is one example layout, not the only one.

## How it works

Three documents, three jobs — do not blend them:

- **Vision doc** (`pvd.md` by default) — why the thing exists, principles, product shape. Changes rarely.
- **Requirements doc** (`requirements.md` by default) — what the system actually does *right now*. Updated whenever the build changes.
- **Decisions folder** (`decisions/` by default) — short files explaining meaningful choices that diverged from an earlier plan. Timestamp inside each file.

Rules that apply in every repo:

- Requirements describe reality, not wishes. Put rationale in the vision doc or a decision file.
- Do not write "for rationale see pvd.md" — each file must stand on its own.
- When requirements need to change because of a design choice: write the decision file first, then update requirements.
- Do not put version numbers or "v1" labels in prose — git already versions the files.
- Do not copy long inventories (skill lists, file trees) into READMEs and requirements — point at the one place that owns the list (`install.ps1`, `package.json`, etc.).
- Write markdown in the repo. Export to PDF or Word only when asked (`/write-doc` if available).

A vision doc is optional. A small library might only need requirements plus decisions.

Confirm filenames and paths with the user before writing. Defaults above unless they override.

## Entry

User may provide:

- An existing vision doc and/or requirements (files, paths, pasted text), or
- Nothing — for a new repo where docs need to be created from what is already built

Also gather any other reference docs the user points at.

- **No prior docs** — write requirements from what is actually in the repo; ask whether a vision doc is needed
- **Prior docs exist** — compare them to what was built; write decision files for important gaps, not every tiny diff

## 1. Scout

- claude-mem (`search`, `get_observations`) if available — what was already decided, what shipped
- Source vision and requirements from the user
- The repo as it exists — code, config, READMEs, any current `docs/`

## 2. Brief

Summarize: what was planned vs what was built, what diverged and matters, what is still unclear.

For a repo with no source docs: describe what exists and whether a vision doc is warranted.

**USER CHECK** — confirm before creating or overwriting files.

## 3. Build

Create or update:

- `docs/README.md` — what each file is for; how to change things (decision first, then requirements)
- Vision doc — if applicable
- Requirements doc — current spec of built state
- Decision files — one concern per file, short name, date at top

Use `/write-pvd` and `/write-requirements` when those skills exist. Follow the rules in **How it works** above.

## 4. README touch

Only if needed:

- Root README: add a link to `docs/` in a Contents list
- Per-folder READMEs (e.g. `ai/README.md`): install/bootstrap info only — do not duplicate requirements or file inventories

**USER CHECK** — the user owns headlines and vision wording. Do not override without asking.

## 5. Gate

- Run `/review-this` on all doc and README changes
- If this repo has a living requirements doc and you changed code or harness config: check they still match; write a decision file first if they diverge
- If this repo has an audit command for its AI setup (e.g. `/meta-review` in dotfiles): run it on harness changes
- Fix problems and re-run until clean

## 6. Ship

Tell the user what changed and how to check it. **Do not commit or push unless they explicitly ask.**

Finished when requirements match what is built, important decisions are recorded, gates pass, and the user is satisfied.
