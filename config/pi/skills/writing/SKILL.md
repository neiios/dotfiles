---
name: writing
description: Writes and edits prose files in a concrete, human, non-AI-sounding voice. Use when writing new documents or making big changes to existing ones.
---

The goal is not to be casual for its own sake. The goal is to avoid generic AI polish and produce writing with a clear point, real texture, and the user's voice.

Default posture

- Treat polished first drafts as suspicious.
- Prefer plain, specific words over impressive ones.
- Preserve the user's wording, rhythm, and irritations when editing their text.
- If details are missing, ask for the important ones or use precise placeholders like `[version]`, `[log line]`, or `[screenshot]`. Do not invent scars.
- Do not make every point equally important. Let the structure follow the substance.

Workflow

1. Identify the audience, purpose, and constraints. Ask only when missing context would change the result.
2. Draft around concrete facts: filenames, numbers, errors, tradeoffs, version constraints, failed attempts, screenshots, risks.
3. Run a de-slop pass using the checklist below.
4. Put the revised text first. Add notes only if they help the user decide what changed.

Words and phrases

- Cut the classic AI vocabulary cluster unless a word is truly the right word: delve, tapestry, realm, leverage, robust, seamless, intricate, nuanced, multifaceted, underscore, pivotal, testament, landscape, foster, figurative "navigate", boasts, elevate, harness, unlock, embark, crucial, vital.
- Remove boilerplate: "It's important to note that", "In today's fast-paced world", "When it comes to", "In conclusion", "I hope this helps", "Feel free to".
- Avoid the reflexive contrast move: "It's not just X, it's Y".

Punctuation and formatting

- Avoid em dashes as a default flourish. Use commas, periods, parentheses, or a plain hyphen when that matches the medium.
- Do not use curly quotes in Slack-like messages, commits, issue comments, or other places where typed text would use straight quotes.
- Avoid repeated bold-label bullets like `**Short Label**: polished sentence.`.

Structure

- Do not force symmetry. Human writing is lumpy: one important point may need three paragraphs; another may need half a sentence.
- Avoid convenient 3-item or 5-item lists unless the content really has that shape.
- Skip intro/recap sandwiches when the answer can start with the point.
- Avoid evenly covering every angle. State priorities and tradeoffs.

Tone

- Default to direct, concrete, and mildly opinionated.
- Do not be relentlessly polite, measured, or enthusiastic.
- Avoid unsupported superlatives like "game-changing" or "massive" in factual writing.
- If something is uncertain, say what is uncertain instead of smoothing it over.

Specificity

- Replace vague value claims with the thing that actually happened.
- Prefer "stop doing three Redis round-trips in `loadUser()`" over "improve performance" when that detail is available.

Code-adjacent writing

For comments, docs, PRs, commits:
- Match the surrounding repo's conventions, even if they are messy.
- Do not add full-sentence comments explaining obvious code.
- Do not add exhaustive docstrings or type commentary in a codebase that does not use them.
- For PR descriptions, explain why the change exists, what was risky, and any migration note. Do not merely summarize the diff.
- For commits, prefer why over "Implemented/Enhanced/Improved" summaries.
- For small, self-explanatory changes you can even omit the description and make the title very short. Being terse is preferred over a wall of text.
- Only add descriptions to commits if this is a common practice in the project. In all other cases commit descrtiption should be omitted.

Output rules

- If asked for variants, make them meaningfully different in stance, length, or audience.
- Keep useful rough edges. Do not sand everything into corporate paste.
