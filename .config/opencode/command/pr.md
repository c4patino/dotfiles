---
description: Create a pull request using the project's PULL_REQUEST_TEMPLATE.md
---

# PR

When the user runs this command, create a pull request from the current branch.

## Workflow

1. **Check branch** — Run `git branch --show-current`. If on `main`/`master`/`develop`/`staging`, warn and ask if they're sure.

2. **Resolve base branch** — Determine the PR base branch before gathering context:
   - If the user passed an argument (for example `/pr develop`), use it as the base branch.
   - Otherwise, if an open PR already exists for the current branch, use that PR's base branch.
   - Otherwise, use the remote's default branch.
   - Verify `origin/<base>` exists with `git rev-parse --verify origin/<base>`. If it does not, fetch or ask the user which base branch to use.

3. **Find PR template** — Check the conventional directories directly; do not use a recursive `**/` glob because it may skip dot-prefixed directories:
   - First, directly read `.github/PULL_REQUEST_TEMPLATE.md`; then `.forgejo/PULL_REQUEST_TEMPLATE.md`.
   - If neither exact path exists, list `.github/` and `.forgejo/` directly when present and locate a case-insensitive filename match there.
   - Verify the selected path exists, then read it. Only use a minimal default template after both directories and their case variants have been checked.

4. **Gather context** — Run `git log origin/<base>..HEAD --oneline` to collect recent commits and `git diff origin/<base>..HEAD --stat` for a file-level summary.

5. **Execute checklist** — Parse the template for markdown checklists (`- [ ] ...`). For each item:
   - If the item contains a runnable command (in backticks), execute it and check the box if it passes (exit 0), leave it unchecked if it fails.
   - If the item is about checking for changed files (e.g., "CAPI client changes follow docs/capi/README.md"), examine the diff to determine if the relevant files changed and apply the check if they conform.
   - If the item cannot be verified programmatically (e.g., "manual testing performed"), ask the user for the status.

6. **Draft the PR** — Fill in the rest of the template using the commit log and diff. Include:
   - Title from the branch name or first commit message
   - Description summarizing what changed and why
   - Pre-filled checkboxes based on step 4
   - Mention any breaking changes or migration steps

7. **Show and confirm** — Present the full PR body to the user for editing before creation, including the selected base branch.

8. **Create** — Use `gh pr create --base <base>` (GitHub) or `fj pr create --base <base>` (Forgejo). Detect which tool is available. If neither is installed, print the markdown to stdout and suggest manual creation.

## Behavior

- Accept an optional base branch argument, e.g. `/pr develop`, `/pr main`, or `/pr staging`.
- Default to the current PR's base branch when one exists; otherwise default to the remote's default branch.
- Always create the PR against the resolved base branch, not a hard-coded branch.
- Do not push before creating — assume the branch is already pushed or ask if needed.
- If a checklist item command fails, leave it unchecked and note the failure in the PR body so reviewers know.
