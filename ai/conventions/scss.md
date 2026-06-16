# SCSS

## General

- BEM: `.block__element--modifier`. Flat selectors, no nesting, no IDs
- Property order: layout → box → border → background → typography → visual
- Design tokens for colors and font families. `rem` for `font-size`. `px` for spacing, borders, fixed dimensions
- No hardcoded hex/rgb/rgba — use tokens; one-off locals OK when not reusable

## Material

- Global overrides in shared material styles; component-specific overrides in the component SCSS file
- Prefer CSS custom properties (`--mat-*`) over `.mat-mdc-*` class overrides
- `::ng-deep` OK for Material internals, projected content, overlays, framework-controlled DOM
- `!important` OK for Material overrides when specificity fights back
