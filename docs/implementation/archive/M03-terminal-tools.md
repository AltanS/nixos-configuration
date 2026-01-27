# M03: Terminal Tools

**Status:** Complete
**Priority:** High
**Created:** 2026-01-27

## Objective

Enhance the terminal experience with modern CLI tools, shell integrations, and quality-of-life aliases. All tools should integrate with configured terminal emulators (ghostty, kitty).

## Specs

### S01: Shell Prompt (Starship) ✓
- [x] Install starship prompt
- [x] Enable starship integration for bash/zsh
- [x] Configure minimal prompt theme (or use default)

**Files:**
- `home/terminal/starship.nix`
- `home/terminal/default.nix`

### S02: Shell History (Atuin) ✓
- [x] Install atuin for shell history sync/search
- [x] Enable atuin integration for bash/zsh
- [x] Configure local-only mode (no sync) or sync if desired

**Files:**
- `home/terminal/atuin.nix`
- `home/terminal/default.nix`

### S03: Modern CLI Replacements ✓
- [x] Install zoxide (smart cd)
- [x] Configure zoxide with `cd` alias
- [x] Install bat (cat replacement)
- [x] Configure bat with `cat` alias
- [x] Install eza (ls replacement)
- [x] Configure eza with `ls` alias
- [x] Install ripgrep (rg) for fast search

**Files:**
- `home/terminal/cli-tools.nix`
- `home/terminal/default.nix`

### S04: Developer Tools ✓
- [x] Install GitHub CLI (gh)
- [x] Install jq for JSON processing
- [x] Install direnv for per-directory environments
- [x] Enable direnv hook for automatic loading

**Files:**
- `home/terminal/dev-tools.nix`
- `home/terminal/default.nix`

## Verification

- [x] `starship` prompt appears in new terminal sessions
- [x] `cd` uses zoxide (try `cd` to a frequently visited dir by partial name)
- [x] `cat` uses bat with syntax highlighting
- [x] `ls` uses eza with icons
- [x] `rg` available for searching
- [x] `atuin` searchable with Ctrl+R
- [ ] `gh auth status` works after login (requires user auth)
- [x] `jq` available for JSON parsing
- [x] Entering a directory with `.envrc` auto-loads environment

## Dependencies

- M02: Desktop Polish (complete)

## Notes

- All shell integrations should work with both bash and zsh
- Consider using `programs.zoxide.enableBashIntegration` etc. in home-manager
- Direnv needs `eval "$(direnv hook bash)"` or home-manager's `programs.direnv.enable`
- Aliases can be set via `home.shellAliases` for shell-agnostic config
