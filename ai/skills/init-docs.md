---
description: (dotfiles) Init docs folder — PVD, requirements, decisions; gated
---

# Init Docs

Stand up or refresh `docs/` from source material. Living requirements reflect built state; decisions record material divergences only.

Entry: user supplies source PVD and/or requirements — paths, files, or pasted content. Gather any other docs they point at.

## 1. Scout

- claude-mem (`search`, `get_observations`) — past work, decisions, what shipped to this phase
- Source PVD and requirements
- Repo as built — code, configs, READMEs, existing `docs/` if any

## 2. Brief

Synthesize: built vs source, material divergences, open questions.

**USER CHECK** — confirm before writing files.

## 3. Build `docs/`

| File | Role |
|------|------|
| `docs/README.md` | Folder index; change process (decision first, then requirements) |
| `docs/pvd.md` | Product vision — rationale and principles |
| `docs/requirements.md` | Living requirements — what exists now |
| `docs/decisions/` | Material divergences — short name, timestamp inside, one concern each |

Draft `pvd.md` and `requirements.md` per `/write-pvd` and `/write-requirements`. Markdown source — PDF or Word via `/write-doc` on request.

### Docs discipline

- Each doc stands alone — no cross-routing ("rationale in X", "see Y")
- No version labels — git history holds snapshots
- No duplicate inventories — point at source of truth (`install.ps1`, convention index, etc.)
- Decisions via claude-mem + judgment — only what shaped the outcome; merge related calls into one file

## 4. README touch

If needed: root README gets a Contents entry; collection README stays bootstrap-only — no doc inventories or cross-links.

**USER CHECK** — user owns headlines and vision wording; don't override without ask.

## 5. Gate

- Self-review per `/review-this` on doc and README changes
- `/meta-review` on any `ai/` or `.claude/` changes
- Update `requirements.md` when harness changed; decision file first if diverging from prior spec

Fix, shrink, re-run until clean.

## 6. Ship

Present what changed and how to verify. **Do not commit or push without explicit user ask.**

Done when docs match built state, decisions capture material divergences, gates pass, user satisfied.
