---
name: grilling
description: Stress-test a plan, decision, or idea by asking prerequisite questions before dependent questions. Use when the user asks to be grilled or wants to uncover gaps, risks, and weak assumptions.
---

Identify the proposal’s goal, scope, constraints, and unresolved decisions. Ask the user to correct any inaccurate summary.
Maintain a **decision graph** that connects each unresolved decision to its prerequisite facts and earlier decisions.

Organize the interview into **rounds**. 
For each round, identify the **frontier**: every unresolved, still-relevant decision whose prerequisites are settled.
Ask every question in the frontier.
Present each question with a number and a recommended answer, then wait for the user's response.
Each question must address one decision, but it may offer multiple choices.

Use this format:

```
❓ **Q1 — <title>**: <question and optional choices>

➡️ <recommended answer>
```

After each round:
1. Update the graph.
2. Discard each branch that an earlier answer rules out.
3. Recompute the frontier.

Research discoverable facts instead of asking the user, but only the user can settle decisions.
When research requires substantial work, delegate it so that independent questions can continue.

Expose every assumption that could materially affect the proposal.
When all relevant decisions are settled and all research is complete:
1. Summarize the agreement.
2. Ask the user to confirm the agreement.

Do not implement the proposal before confirmation.
