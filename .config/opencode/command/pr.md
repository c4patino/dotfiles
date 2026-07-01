---
description: Create a pull request using the project's PULL_REQUEST_TEMPLATE.md
---

# PR

When the user runs this command, create a pull request from the current branch.

## Workflow

1. **Check branch** — Run `git branch --show-current`. If on `main`/`master`, warn and ask if they're sure.

2. **Find PR template** — Look for `PULL_REQUEST_TEMPLATE.md` in `.github/` or `.forgejo/` (case-insensitive). If found, read it. If not found, use a minimal default template.

3. **Gather context** — Run `git log origin/main..HEAD --oneline` (or the equivalent for the default branch) to collect recent commits and `git diff origin/main..HEAD --stat` for a file-level summary.

4. **Execute checklist** — Parse the template for markdown checklists (`- [ ] ...`). For each item:
   - If the item contains a runnable command (in backticks), execute it and check the box if it passes (exit 0), leave it unchecked if it fails.
   - If the item is about checking for changed files (e.g., "CAPI client changes follow docs/capi/README.md"), examine the diff to determine if the relevant files changed and apply the check if they conform.
   - If the item cannot be verified programmatically (e.g., "manual testing performed"), ask the user for the status.

5. **Draft the PR** — Fill in the rest of the template using the commit log and diff. Include:
   - Title from the branch name or first commit message
   - Description summarizing what changed and why
   - Pre-filled checkboxes based on step 4
   - Mention any breaking changes or migration steps

6. **Show and confirm** — Present the full PR body to the user for editing before creation.

7. **Create** — Use `gh pr create` (GitHub) or `forgejo pr create` (Forgejo). Detect which tool is available. If neither is installed, print the markdown to stdout and suggest manual creation.

## Behavior

- Default to the remote's default branch as the base.
- Do not push before creating — assume the branch is already pushed or ask if needed.
- If a checklist item command fails, leave it unchecked and note the failure in the PR body so reviewers know.
