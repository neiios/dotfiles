---
name: handoff
description: Create a concise handoff file so a fresh agent can continue the current work. Use when moving work to another session or agent.
argument-hint: "Focus for the next session"
---

Create a concise, action-oriented handoff for a fresh agent. Save it outside the workspace in the OS temporary directory as `handoff-<project>-<YYYYMMDD-HHMMSS>.md`.

Include:
- goal
- current state: completed and remaining work, todos
- next steps, in priority order
- relevant files, paths, URLs, and commands
- decisions and constraints
- open questions and failed approaches, only when relevant

Reference existing specs, plans, issues, commits, relevant file paths, links to docs, and other artifacts instead of repeating them. 
For uncommitted work, identify the relevant files and instruct the next agent to inspect the current `git status` and diff.

Include only context needed to continue the work. Never include secret values, credentials, tokens.

If arguments were provided, use them as the next session's focus.

After saving the file, respond with:
1. its absolute path
2. a ready-to-paste prompt such as: `Read <path> and continue with <focus>.`
