---
description: Analyze and understand the complete project context and structure
---

# Context

When the user runs this command, systematically analyze the project to understand its structure, purpose, stack, and current state. Use $ARGUMENTS to focus on specific aspects if provided.

## Analysis Process

1. **Project discovery** — Read README, examine build configs (package.json, Cargo.toml, pyproject.toml, Gemfile, Makefile, CMakeLists.txt, etc.), and check for documentation files.

2. **Codebase structure** — Run `git ls-files | head -60` to see the file layout. Identify main directories and their purposes. Examine key config files.

3. **Tech stack detection** — Identify languages, frameworks, build tools, package manager, containerization (Dockerfile, compose.yml), and CI/CD setup.

4. **Current state** — Check `git status`, `git log --oneline -10`, and scan for TODO items, test coverage patterns.

## Report

Provide a concise summary covering:
- Project name and purpose
- Technology stack (language, framework, build tools, package manager)
- Directory structure overview
- Development workflow (setup, build, test, deploy)
- Recent activity and any obvious issues
