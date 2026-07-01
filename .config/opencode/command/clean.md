---
description: Clean up code — remove debug artifacts, format, sort imports, fix lint issues
---

# Clean

When the user runs this command, clean the specified files or directories (or recently modified files if none given).

## Cleanup Pipeline

1. **Remove debug code** — Strip console.log, debugger statements, commented-out code blocks, and temporary debugging artifacts.

2. **Format** — Run the project's formatter if available (e.g., `prettier`, `rustfmt`, `gofmt`, `black`, `shfmt`). Otherwise apply consistent indentation and spacing manually.

3. **Optimize imports** — Sort, group, and remove unused imports. Use absolute paths where the project convention dictates.

4. **Fix lint issues** — Run the project's linter with auto-fix if available. Report any issues that need manual attention.

5. **Type validation** — Run the project's type checker if available. Fix obvious type issues.

6. **Tidy comments** — Remove redundant or obvious comments. Improve unclear ones. Ensure public APIs have doc comments matching the language convention.

## Report

Summarize files processed, actions taken, and any issues requiring manual intervention.
