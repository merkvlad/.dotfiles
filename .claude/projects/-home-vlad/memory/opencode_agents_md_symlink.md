---
name: opencode-agents-md-symlink
description: ~/.claude/CLAUDE.md is a symlink to ~/.config/opencode/AGENTS.md — one shared rules file for both tools
metadata: 
  node_type: memory
  type: reference
  originSessionId: f813270a-6986-4d2a-bce4-0e164aa318f9
---

`/home/vlad/.claude/CLAUDE.md` is a symlink pointing to
`/home/vlad/.config/opencode/AGENTS.md`. Edits to global personal rules
must target the real file path (`readlink -f` first — Edit/Write refuse to
write through the symlink directly) but conceptually there is only one
global rules file, shared by Claude Code and opencode. Relevant to
[[opencode-claude-handoff-pipeline]] — no need to duplicate rules across
tools when building a hybrid workflow.
