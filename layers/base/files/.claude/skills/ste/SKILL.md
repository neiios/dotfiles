---
name: ste
description: Write or rewrite technical prose in the ASD-STE100 (Simplified Technical English) style. Use for documentation, procedures, code comments, commit messages, pull-request descriptions, and other technical text.
---

Apply these rules to prose and code comments.
Do not enforce the ASD-STE100 approved-word dictionary.
Focus on clear structure and grammar, not dictionary compliance.

When you rewrite text:
- Do not add facts, requirements, recommendations, or assumptions.
- You can split, combine, or reorder sentences when their meaning does not change.

## Word choice

- Use one term for one meaning.
- Use short, common words and established technical terms.
- Prefer verbs to related nouns: "Install the package", not "Perform the installation".
- Avoid vague pronouns. Repeat the noun when "it", "this", "that", or "they" can be ambiguous.
- Define an unfamiliar abbreviation at its first use.
- Do not replace a precise technical term only to make it short

## Grammar

- Prefer active voice and identify the actor when the actor is important.
- Use passive voice only when the actor is unknown, unimportant, or clear from context.
- Use simple present, simple past, simple future, or the imperative.
- Avoid "-ing" verb forms when a clear finite verb is available.
- Keep an "-ing" form when it is part of an established technical term or name.
- Write instructions in the imperative.
- Use "must" for a requirement.
- Use "should" for a recommendation.
- Use "may" for permission.
- Use "can" for capability or possibility.

## Procedures and conditions

- Put a condition before the action that depends on it: "If the test fails, inspect the log."
- Put one action in each procedural step.
- Put steps in execution order.
- State prerequisites before the procedure.
- Put warnings before the step that can cause harm or data loss.
- Distinguish instructions, expected results, warnings, and notes.
- Do not convert explanatory text into an instruction.

## Structure

- Limit instructions to 20 words and descriptions to 25 words when they can be split safely.
- Treat a code span, path, URL, or identifier as one word.
- Keep one topic in each paragraph and put the topic sentence first.
- Use no more than three nouns in a noun cluster.
- Use "that" when its omission can cause ambiguity.
- Use a vertical list for a sequence or for more than three related items.

## Check

Review the result and verify that:
- The technical meaning, conditions, and scope are unchanged.
- Terms are consistent and references are unambiguous.
- Procedures are complete and remain in the correct order.
- Sentence limits are met or a stated exception applies.
- The result is natural and easy to understand.
