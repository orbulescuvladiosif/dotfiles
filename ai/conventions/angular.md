# Angular

## Sample

Reference only — adapt folders and paths per repo.

### Folder layout

```
src/
├── app/
│   ├── app.ts / app.routes.ts / app.config.ts   # Bootstrap
│   ├── auth/          # Auth flow, token injection, session guards
│   ├── config/        # App-wide constants, icon registry, route titles
│   ├── layout/        # Shell — navbar, topbar, chrome
│   ├── shared/        # Cross-feature: services, components, pipes, guards
│   └── [feature]/     # One folder per user-facing slice
├── assets/
│   ├── icons/         # SVG icons
│   └── i18n/          # Translation JSON files
└── styles/
    ├── _tokens.scss   # Color and font tokens
    ├── material/      # Global Material component overrides
    └── custom/        # Global utility styles
```

### Feature folders

Each feature is a self-contained routed surface (page, drawer, etc.). Multiple entry points (e.g. add vs. edit) split into sub-feature folders sharing internals.

```
[feature]/
├── [sub-feature]/     # Entry point (routed component or drawer opener)
├── components/
├── services/
├── models/
├── helpers/
└── constants/
```

## Rules

### Architecture

**Feature-first** — code lives with the feature that owns it. `shared/` only for genuinely cross-feature code.

**Sub-features** — multiple entry points into the same domain split into sibling folders sharing the feature's internals.

**Interceptors** — colocate token injection and request transforms with auth or shared concerns.

**Icons** — register at startup via a central registry; consume declaratively in templates.

**i18n** — one complete base locale with all keys. Other locales extend or override; full locales stay complete files.

**Barrels** — `index.ts` on subfolders that external callers import from (e.g. `my-feature/components/index.ts` → import from `my-feature/components`). No feature-root barrel that re-exports the whole feature. Only export what external callers need. Never `export *`

### Components and templates

- `protected` for template-accessed members. `private` for internals. Never explicit `public`
- Constructors and lifecycle hooks stay thin — delegate to named methods
- Control-flow blocks (`@if`, `@for`) wrap elements — they are not attributes
- Attribute order: **Selector** → **Static** (`class`, `aria-*`) → **Inputs** (`[prop]`) → **Outputs** (`(event)`)
- Tests: trigger through template events; never call `protected` or `private` directly
- Skip component tests that need fake timers, multi-step async chains, or extensive mocking

### Material

- Use Material components directly — no wrappers
- Don't introduce wrappers or complex theming machinery to avoid `::ng-deep` or `!important`

### Imports and exports

- Prefer relative paths (`./` or `../`). Path aliases OK when the repo defines them
- Import from the subfolder barrel when crossing into that folder — stop at the barrel, don't reach into internals
- Import directly from the file within the same folder

### Dependencies

- Runtime packages in `dependencies`. Build/test/tooling in `devDependencies`
