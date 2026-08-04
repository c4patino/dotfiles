---
description: Create well-formatted commits with semantic conventional commit messages
---

# Commit

Create a commit from the current worktree changes.

1. **Pre-commit validation**: Run the project's build/check/lint commands if they exist (e.g., `pnpm check`, `make`, `cargo check`, `go build`, etc.). If any fail, ask whether to proceed or fix first.

2. **Stage changes**: Run `git status --porcelain`. If no files are staged, run `git add .` to stage all modified files. If files are already staged, commit only those.

3. **Analyze the diff**: Run `git diff --cached` and determine the primary change type (feat, fix, docs, chore, refactor, perf, test, style).

4. **Generate commit message**: Format as `<type>: <description>` in imperative mood. Make the description specific enough to be as close to 80 total characters as possible - never exceed 80, but don't be too terse either. Show the proposed message for confirmation.

5. **Execute**: Run `git commit -m "<message>"` (no push). Display the commit hash and summary.

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

- If validation fails, give the option to proceed or fix first.
- Auto-stage all changes if nothing is staged; respect existing staged files otherwise.
- Only commit - never push.
