$script:DefaultRepo = 'https://raw.githubusercontent.com/orbulescuvladiosif/dotfiles/master'

$script:SkillNames = @(
    'clean-up-ai-tools',
    'reply-review-comments',
    'review-this',
    'consolidate-memories',
    'write-doc',
    'write-pvd',
    'write-requirements',
    'write-ticket',
    'sdlc',
    'init-repo-docs'
)

$script:ClaudeSyncPaths = @(
    @{ src = 'ai/AGENTS.md';                  dest = 'CLAUDE.md';                    label = 'CLAUDE.md' }
    @{ src = 'ai/conventions/index.md';      dest = 'conventions\index.md';         label = 'conventions/index.md' }
    @{ src = 'ai/conventions/engineering.md'; dest = 'conventions\engineering.md'; label = 'conventions/engineering.md' }
    @{ src = 'ai/conventions/git.md';         dest = 'conventions\git.md';           label = 'conventions/git.md' }
    @{ src = 'ai/conventions/ui.md';          dest = 'conventions\ui.md';            label = 'conventions/ui.md' }
    @{ src = 'ai/conventions/typescript.md';  dest = 'conventions\typescript.md';   label = 'conventions/typescript.md' }
    @{ src = 'ai/conventions/angular.md';    dest = 'conventions\angular.md';       label = 'conventions/angular.md' }
    @{ src = 'ai/conventions/scss.md';       dest = 'conventions\scss.md';          label = 'conventions/scss.md' }
    @{ src = 'ai/conventions/testing.md';    dest = 'conventions\testing.md';       label = 'conventions/testing.md' }
    @{ src = 'ai/hooks/statusline.ps1';       dest = 'hooks\statusline.ps1';         label = 'hooks/statusline.ps1' }
)

$script:CursorConventions = [ordered]@{
    'index.mdc'       = @{ src = 'ai/conventions/index.md';       desc = 'Convention index — routes tasks; ownership matrix and authoring rules' }
    'engineering.mdc' = @{ src = 'ai/conventions/engineering.md'; desc = 'Engineering conventions' }
    'git.mdc'         = @{ src = 'ai/conventions/git.md';         desc = 'Git conventions' }
    'typescript.mdc'  = @{ src = 'ai/conventions/typescript.md';  desc = 'TypeScript conventions' }
    'angular.mdc'     = @{ src = 'ai/conventions/angular.md';     desc = 'Angular architecture and patterns' }
    'scss.mdc'        = @{ src = 'ai/conventions/scss.md';        desc = 'SCSS and styling conventions' }
    'ui.mdc'          = @{ src = 'ai/conventions/ui.md';           desc = 'UI, UX, accessibility, and UI test conventions' }
    'testing.mdc'     = @{ src = 'ai/conventions/testing.md';       desc = 'Testing conventions' }
}

$script:ExcludeEntries = @('.cursor/rules/agents.mdc', '.cursor/rules/conventions/')
