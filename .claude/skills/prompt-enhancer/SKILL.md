---
name: prompt-enhancer
description: Improve rough, overloaded, contradictory, under-specified, or factually suspect prompts before they are given to an LLM or agent. Use when the user asks to enhance, refine, decompose, sanity-check, or rewrite a prompt; when a task request mixes many goals without clear decomposition; when assumptions about code, architecture, or a domain may be wrong; or when the user invokes "Prompt Enhancer" to produce either a precise final prompt or a few blocking clarification questions.
---

# Prompt Enhancer

## Goal

Turn an imperfect task request into a prompt that another LLM or agent can execute with minimal ambiguity. Preserve the user's intent and language, but make hidden goals, constraints, assumptions, verification, and success criteria explicit.

Do not execute the underlying task unless the user explicitly asks for execution. Focus on prompt quality.

## Workflow

1. Identify the real objective.
   - Extract the intended outcome, target artifact, audience, scope, constraints, and deadline if present.
   - Separate "must have" requirements from preferences, guesses, examples, and background.
   - Preserve explicit user constraints, including negative constraints.

2. Check whether the prompt is safe to finalize.
   - Look for contradictions, missing inputs, vague verbs, mixed priorities, undefined terms, and impossible success criteria.
   - If the request mentions a local codebase, architecture, config, docs, or file path, inspect the relevant local source before treating factual claims as true when that inspection is cheap and available.
   - If the request depends on current external facts or library behavior, use the appropriate current source only when needed; otherwise mark the assumption as unverified.

3. Decide the output path.
   - If the objective can be made actionable without user input, produce a copy-ready improved prompt.
   - If missing information would materially change the correct task, ask 1-3 concise clarification questions.
   - If both are useful, provide a best-effort prompt with clearly marked placeholders, then ask only the blocking questions.

4. Decompose overloaded work.
   - Split broad tasks into phases or ordered subtasks.
   - Make dependencies explicit: what must be inspected first, what can be parallelized, and what should wait for confirmation.
   - Include expected deliverables and verification steps for each meaningful phase.

5. Tighten the prompt.
   - Replace vague instructions with observable actions.
   - Add success and failure criteria when the original request implies them.
   - Add "do not" constraints only when they prevent likely harm or unwanted scope expansion.
   - Keep the prompt as short as possible while still being executable.

## Output Format

When enough information is available:

```markdown
**Improved Prompt**
[copy-ready prompt]

**Why This Version**
- [1-3 short notes about major fixes: decomposition, assumptions, constraints, verification]

**Assumptions To Verify**
- [only include if there are unverified factual assumptions]
```

When information is blocking:

```markdown
**Clarification Needed**
1. [question]
2. [question]
3. [question]

**Draft Prompt After Answers**
[optional skeleton with placeholders]
```

Match the user's language unless they ask for another language.

## Quality Checklist

Before finalizing, verify that the improved prompt answers:

- What is the final outcome?
- What context or files should be inspected first?
- What is in scope and out of scope?
- What assumptions are known, uncertain, or user-provided?
- What should the agent produce?
- How should the result be verified?
- What should the agent avoid doing?

## Boundaries

- Do not conduct a relentless interview. Ask only blocking questions and stop at 3 unless the user requests deeper interrogation.
- Do not copy the behavior of `grill-me`; this skill optimizes prompts, not shared-understanding interviews.
- Do not invent requirements, facts, repository state, API behavior, or domain rules.
- Do not over-engineer simple prompts. If the original request is already clear, make only minimal improvements.
- Do not bury unresolved uncertainty inside the improved prompt. Mark it plainly or ask a question.
