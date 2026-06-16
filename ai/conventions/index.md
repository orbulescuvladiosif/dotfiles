# Conventions

## Ownership

| File | Owns | Not here |
|------|------|----------|
| `engineering` | Design — structure, failure, thin shells | Test how-to, framework syntax |
| `testing` | Generic principles, unit setup, coverage | UI selectors, E2E, framework TestBed |
| `ui` | UX, a11y, component + E2E tests (framework-agnostic) | Angular `protected`, coverage thresholds |
| `angular` | Angular structure, templates, Material, Angular test mechanics | Generic E2E, SCSS technique |
| `typescript` | Pure TypeScript | Templates, framework access modifiers |
| `scss` | SCSS technique, Material styling | Material component policy |
| `git` | Commits and PRs | — |

## Authoring

- One home per rule — no same concept reworded elsewhere
- No cross-file refs — no `pull`, `see`, or `per` pointing at sibling files
- Routes below say **when** to pull — never inventory contents
- Framework API or syntax → domain file; if it names a framework, it isn't generic
- Sample blocks are reference only — rules are portable
- Multi-pull is fine when each file adds a different layer; duplication is not

## Routes

- engineering — pull when writing or reviewing code
- git — pull when writing commits or opening PRs
- typescript — pull when writing TypeScript
- angular — pull when working on Angular structure, features, templates, or Material
- scss — pull when writing styles
- ui — pull when building or reviewing UI, a11y, UX, or UI tests
- testing — pull when writing or reviewing tests
