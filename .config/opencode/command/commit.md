---
description: Commit staged changes, or stage all changes when nothing is staged
---

# Commit

Create a commit from the current worktree changes.

**Input**: Optionally specify the commit type after `/commit` (for example, `/commit fix`).

## Workflow

1. **Stage changes**: Run `git diff --cached --quiet`. If no files are staged, run `git add .` to stage all modified and untracked files. If files are already staged, commit only those.

2. **Analyze staged changes**: Run `git diff --cached` to inspect only the staged files. Determine the primary change type from the diff unless the user supplied a type.

3. **Generate and commit**: Format the message as `<type>: <description>` in imperative mood. Keep it specific and under 80 characters. Run `git commit -m "<message>"` immediately without asking for confirmation.

4. **Report**: Display the commit hash and summary. Do not push.

## Commit Type Reference

| Type      | When to use                                             |
| --------- | ------------------------------------------------------- |
| feat      | A new feature                                           |
| fix       | A bug fix                                               |
| docs      | Documentation changes                                   |
| style     | Formatting, whitespace (no code logic change)           |
| refactor  | Code change that neither fixes a bug nor adds a feature |
| perf      | Performance improvement                                 |
| test      | Adding or updating tests                                |
| chore     | Maintenance, tooling, dependencies, config              |
| wip       | Work in progress (not ready for review)                 |

## Behavior

- Do not run build, check, lint, or test commands.
- Auto-stage all changes if nothing is staged; respect existing staged files otherwise.
- If the user supplies a type after `/commit`, use it as the commit type rather than inferring one from the diff.
- Generate the commit message and commit without confirmation.
- Only commit - never push.
