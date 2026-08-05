---
name: code-style-js
description: Use when writing or editing JavaScript or TypeScript code (including JSX/TSX), or when asked to format, clean up, or style-review JS/TS changes
---

# JS/TS Code Style

## Overview

My personal code style for JavaScript/TypeScript: one predictable form for naming, ordering, and structure, with everything that does not earn its place removed.

The rule catalog lives in [RULES.md](RULES.md). Read it in full before applying the skill. Rules marked ★ are the ones professional habit gets wrong — check the code against them explicitly; the unmarked rules mostly confirm what good taste already does.

## Modes

1. **While writing.** Apply the whole catalog to all JS/TS you produce.
2. **Formatting pass.** On request, apply the catalog to the user's changed code only — the working diff, the branch diff against the default branch, or the files they name. Never touch lines outside the change. Apply behavior-preserving rules directly; for findings whose fix changes behavior (async batching, dependency-injection moves, module-boundary changes), report them as suggestions instead of applying them.

## Precedence

1. The file's or team's existing convention beats the catalog. When a file already mixes two forms, unify on the catalog-compliant one — within the boundary of the change.
2. The project's Prettier/ESLint/Stylelint config wins on everything it covers: whitespace, wrapping, indentation, quotes, semicolons, import order. Run the project's formatter after editing when one is configured.
3. The catalog is the default for new code and unsettled patterns.

## Philosophy

1. **Reduce the chaos factor.** One predictable form — sorted, named by fixed convention, laid out the same way every time.
2. **Be relentlessly consistent.** Match the surrounding code; never introduce a second way to do what the codebase already does one way.
3. **Remove everything that does not earn its place.** Redundant assertions, single-use indirections, narrating comments, guards for impossible cases.
4. **Declare and order things by use.** The reader meets each value where it is used, in the order the code runs.
5. **Prefer the platform.** Built-ins and the project's own utilities over hand-rolled code.

The measure of "simpler" is how fast the next reader understands the code, not line count. Simplicity never outranks safety.

## Style Decisions Worth Naming

- Boolean returns stay direct: `return (x > 0) && y;` — never the expanded if/return-true/return-false form.
- `switch` is allowed on a TypeScript discriminated union with an exhaustiveness check in `default`; otherwise use a lookup object or if/else.
- Layout, wrapping, and whitespace belong to Prettier and are not part of this skill.
