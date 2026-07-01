---
description: Analyze code for performance, security, and potential issues
---

# Optimize

When the user runs this command, analyze the specified files (or the current context if none given) for performance, security, and maintainability improvements.

## Analysis Process

### 1. Performance
- Identify algorithmic inefficiencies (nested loops, redundant computation, unnecessary allocations)
- Check for blocking I/O where async would fit
- Spot missing caching opportunities
- Look for framework-specific anti-patterns (excessive re-renders, N+1 queries, chunky bundles)

### 2. Security
- Check for missing or weak input validation (injection vectors, path traversal, XSS)
- Verify authentication and authorization checks are in place
- Spot sensitive data in logs, errors, or client bundles
- Flag outdated or vulnerable dependencies

### 3. Reliability
- Find missing error handling (uncaught exceptions, silent failures, poor error messages)
- Identify edge-case gaps (null/undefined, empty collections, race conditions, network failures)
- Spot hard-coded limits and single points of failure

### 4. Maintainability
- Detect code duplication and overly complex functions
- Find tight coupling between modules
- Note missing documentation on critical logic

## Report

Structure findings by priority:
- **Critical** — Security vulnerabilities and performance bottlenecks that need immediate attention
- **Important** — Significant improvements and edge cases to handle
- **Nice to have** — Code quality improvements and minor optimizations

Include file:line references and concrete recommendations.
