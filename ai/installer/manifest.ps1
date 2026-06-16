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
    @{ src = 'ai/hooks/statusline.ps1';       dest = 'hooks\statusline.ps1';         label = 'hooks/statusline.ps1' }
)

$script:CursorConventions = [ordered]@{
    'index.mdc'       = @{ src = 'ai/conventions/index.md';       desc = 'Convention index — routes tasks to convention files' }
    'engineering.mdc' = @{ src = 'ai/conventions/engineering.md'; desc = 'Engineering conventions' }
    'git.mdc'         = @{ src = 'ai/conventions/git.md';         desc = 'Git conventions' }
    'ui.mdc'          = @{ src = 'ai/conventions/ui.md';           desc = 'UI conventions' }
}

$script:ExcludeEntries = @('.cursor/rules/agents.mdc', '.cursor/rules/conventions/')
