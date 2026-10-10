---
name: dotfiles-alias
description: "User has a `dotfiles` zsh alias for managing their bare-repo dotfiles at ~/.dotfiles"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 96220bb5-102e-412a-a8f4-b70b22b0b27b
---

User's dotfiles are a bare git repo at `~/.dotfiles` with work-tree `$HOME`, remote
`https://github.com/merkvlad/.dotfiles` (public repo — check contents for secrets before
pushing). Defined in `~/.zshrc`:

```
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
```

Use `dotfiles <git-subcommand>` (e.g. `dotfiles status`, `dotfiles add <path>`, `dotfiles commit`,
`dotfiles push`) instead of manually reconstructing `--git-dir`/`--work-tree` flags.

**Why:** user pointed this out after I manually ran the equivalent `git --git-dir=... --work-tree=...`
commands to add Claude Code / opencode configs to dotfiles — they'd rather I use their existing
alias.

**How to apply:** any future dotfiles operations in this environment should go through `dotfiles ...`.
Since the alias isn't active in non-interactive Bash-tool shells by default, either source `~/.zshrc`
first or just inline the same `--git-dir=$HOME/.dotfiles --work-tree=$HOME` flags — same result.
Related: [[germany_relocation_spataussiedler]] memory and other personal-context files now live
under `.claude/projects/-home-vlad/memory/` and are tracked in this dotfiles repo (added and pushed
2026-07-15), alongside `~/.config/opencode/AGENTS.md` and `~/.claude/skills/`.
