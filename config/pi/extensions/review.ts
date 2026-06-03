import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const REVIEW_SYSTEM_PROMPT = "# Review guidelines:\n\nYou are acting as a reviewer for a proposed code change made by another engineer.\n\nBelow are some default guidelines for determining whether the original author would appreciate the issue being flagged.\n\nThese are not the final word in determining whether an issue is a bug. In many cases, you will encounter other, more specific guidelines. These may be present elsewhere in a developer message, a user message, a file, or even elsewhere in this system message.\nThose guidelines should be considered to override these general instructions.\n\nHere are the general guidelines for determining whether something is a bug and should be flagged.\n\n1. It meaningfully impacts the accuracy, performance, security, or maintainability of the code.\n2. The bug is discrete and actionable (i.e. not a general issue with the codebase or a combination of multiple issues).\n3. Fixing the bug does not demand a level of rigor that is not present in the rest of the codebase (e.g. one doesn't need very detailed comments and input validation in a repository of one-off scripts in personal projects)\n4. The bug was introduced in the commit (pre-existing bugs should not be flagged).\n5. The author of the original PR would likely fix the issue if they were made aware of it.\n6. The bug does not rely on unstated assumptions about the codebase or author's intent.\n7. It is not enough to speculate that a change may disrupt another part of the codebase, to be considered a bug, one must identify the other parts of the code that are provably affected.\n8. The bug is clearly not just an intentional change by the original author.\n\nWhen flagging a bug, you will also provide an accompanying comment. Once again, these guidelines are not the final word on how to construct a comment -- defer to any subsequent guidelines that you encounter.\n\n1. The comment should be clear about why the issue is a bug.\n2. The comment should appropriately communicate the severity of the issue. It should not claim that an issue is more severe than it actually is.\n3. The comment should be brief. The body should be at most 1 paragraph. It should not introduce line breaks within the natural language flow unless it is necessary for the code fragment.\n4. The comment should not include any chunks of code longer than 3 lines. Any code chunks should be wrapped in markdown inline code tags or a code block.\n5. The comment should clearly and explicitly communicate the scenarios, environments, or inputs that are necessary for the bug to arise. The comment should immediately indicate that the issue's severity depends on these factors.\n6. The comment's tone should be matter-of-fact and not accusatory or overly positive. It should read as a helpful AI assistant suggestion without sounding too much like a human reviewer.\n7. The comment should be written such that the original author can immediately grasp the idea without close reading.\n8. The comment should avoid excessive flattery and comments that are not helpful to the original author. The comment should avoid phrasing like \"Great job ...\", \"Thanks for ...\".\n\nBelow are some more detailed guidelines that you should apply to this specific review.\n\nHOW MANY FINDINGS TO RETURN:\n\nOutput all findings that the original author would fix if they knew about it. If there is no finding that a person would definitely love to see and fix, prefer outputting no findings. Do not stop at the first qualifying finding. Continue until you've listed every qualifying finding.\n\nGUIDELINES:\n\n- Ignore trivial style unless it obscures meaning or violates documented standards.\n- Use one comment per distinct issue (or a multi-line range if necessary).\n- Use ```suggestion blocks ONLY for concrete replacement code (minimal lines; no commentary inside the block).\n- In every ```suggestion block, preserve the exact leading whitespace of the replaced lines (spaces vs tabs, number of spaces).\n- Do NOT introduce or remove outer indentation levels unless that is the actual fix.\n\nThe comments will be presented in the code review as inline comments. You should avoid providing unnecessary location details in the comment body. Always keep the line range as short as possible for interpreting the issue. Avoid ranges longer than 5\u201310 lines; instead, choose the most suitable subrange that pinpoints the problem.\n\nAt the beginning of the finding title, tag the bug with priority level. For example \"[P1] Un-padding slices along wrong tensor dimensions\". [P0] \u2013 Drop everything to fix.  Blocking release, operations, or major usage. Only use for universal issues that do not depend on any assumptions about the inputs. \u00b7 [P1] \u2013 Urgent. Should be addressed in the next cycle \u00b7 [P2] \u2013 Normal. To be fixed eventually \u00b7 [P3] \u2013 Low. Nice to have.\n\nAdditionally, include a numeric priority field in the JSON output for each finding: set \"priority\" to 0 for P0, 1 for P1, 2 for P2, or 3 for P3. If a priority cannot be determined, omit the field or use null.\n\nAt the end of your findings, output an \"overall correctness\" verdict of whether or not the patch should be considered \"correct\".\nCorrect implies that existing code and tests will not break, and the patch is free of bugs and other blocking issues.\nIgnore non-blocking issues such as style, formatting, typos, documentation, and other nits.\n\nFORMATTING GUIDELINES:\nThe finding description should be one paragraph.\n\nOUTPUT FORMAT:\n\n## Output schema  \u2014 MUST MATCH *exactly*\n\n```json\n{\n  \"findings\": [\n    {\n      \"title\": \"<\u2264 80 chars, imperative>\",\n      \"body\": \"<valid Markdown explaining *why* this is a problem; cite files/lines/functions>\",\n      \"confidence_score\": <float 0.0-1.0>,\n      \"priority\": <int 0-3, optional>,\n      \"code_location\": {\n        \"absolute_file_path\": \"<file path>\",\n        \"line_range\": {\"start\": <int>, \"end\": <int>}\n      }\n    }\n  ],\n  \"overall_correctness\": \"patch is correct\" | \"patch is incorrect\",\n  \"overall_explanation\": \"<1-3 sentence explanation justifying the overall_correctness verdict>\",\n  \"overall_confidence_score\": <float 0.0-1.0>\n}\n```\n\n* **Do not** wrap the JSON in markdown fences or extra prose.\n* The code_location field is required and must include absolute_file_path and line_range.\n* Line ranges must be as short as possible for interpreting the issue (avoid ranges over 5\u201310 lines; pick the most suitable subrange).\n* The code_location should overlap with the diff.\n* Do not generate a PR fix.\n";

const UNCOMMITTED_PROMPT = "Review the current code changes (staged, unstaged, and untracked files) and provide prioritized findings.";
const BASE_BRANCH_PROMPT_BACKUP = "Review the code changes against the base branch '{branch}'. Start by finding the merge diff between the current branch and {branch}'s upstream e.g. (`git merge-base HEAD \"$(git rev-parse --abbrev-ref \"{branch}@{upstream}\")\"`), then run `git diff` against that SHA to see what changes we would merge into the {branch} branch. Provide prioritized, actionable findings.";
const BASE_BRANCH_PROMPT = "Review the code changes against the base branch '{baseBranch}'. The merge base commit for this comparison is {mergeBaseSha}. Run `git diff {mergeBaseSha}` to inspect the changes relative to {baseBranch}. Provide prioritized, actionable findings.";
const COMMIT_PROMPT_WITH_TITLE = "Review the code changes introduced by commit {sha} (\"{title}\"). Provide prioritized, actionable findings.";
const COMMIT_PROMPT = "Review the code changes introduced by commit {sha}. Provide prioritized, actionable findings.";

interface ReviewRequest {
	prompt: string;
	hint: string;
}

interface ParsedReviewArgs {
	type: "help" | "uncommitted" | "base" | "commit" | "custom";
	branch?: string;
	sha?: string;
	title?: string;
	instructions?: string;
}

interface ReviewFinding {
	title?: string;
	body?: string;
	confidence_score?: number;
	priority?: number | null;
	code_location?: {
		absolute_file_path?: string;
		line_range?: { start?: number; end?: number };
	};
}

interface ReviewOutput {
	findings?: ReviewFinding[];
	overall_correctness?: string;
	overall_explanation?: string;
	overall_confidence_score?: number;
}

function usage(): string {
	return [
		"Usage:",
		"  /review                              Review staged, unstaged, and untracked changes",
		"  /review --uncommitted                Review staged, unstaged, and untracked changes",
		"  /review --base <branch>              Review changes against a base branch",
		"  /review --commit <sha> [--title ...] Review one commit",
		"  /review <instructions>               Run a custom Codex-style review",
	].join("\n");
}

function shortSha(sha: string): string {
	return sha.slice(0, 7);
}

function render(template: string, values: Record<string, string>): string {
	return template.replace(/{(\w+)}/g, (match, key: string) => values[key] ?? match);
}

function shellWords(input: string): string[] {
	const words: string[] = [];
	let current = "";
	let quote: "'" | '"' | undefined;
	let escaping = false;

	for (const char of input) {
		if (escaping) {
			current += char;
			escaping = false;
			continue;
		}

		if (char === "\\" && quote !== "'") {
			escaping = true;
			continue;
		}

		if (quote) {
			if (char === quote) {
				quote = undefined;
			} else {
				current += char;
			}
			continue;
		}

		if (char === "'" || char === '"') {
			quote = char;
			continue;
		}

		if (/\s/.test(char)) {
			if (current.length > 0) {
				words.push(current);
				current = "";
			}
			continue;
		}

		current += char;
	}

	if (escaping) current += "\\";
	if (current.length > 0) words.push(current);
	return words;
}

function parseArgs(args: string): ParsedReviewArgs {
	const trimmed = args.trim();
	if (!trimmed) return { type: "uncommitted" };

	const words = shellWords(trimmed);
	if (words.length === 0) return { type: "uncommitted" };
	if (words[0] === "--help" || words[0] === "-h" || words[0] === "help") return { type: "help" };
	if (words[0] === "--uncommitted") return words.length === 1 ? { type: "uncommitted" } : { type: "help" };

	const baseEquals = words[0].match(/^--base=(.+)$/);
	if (baseEquals) return { type: "base", branch: baseEquals[1] };
	if (words[0] === "--base") return words[1] && words.length === 2 ? { type: "base", branch: words[1] } : { type: "help" };

	const commitEquals = words[0].match(/^--commit=(.+)$/);
	if (commitEquals || words[0] === "--commit") {
		const sha = commitEquals?.[1] ?? words[1];
		if (!sha) return { type: "help" };
		const rest = words.slice(commitEquals ? 1 : 2);
		let title: string | undefined;
		if (rest[0]?.startsWith("--title=")) {
			title = rest[0].slice("--title=".length);
		} else if (rest[0] === "--title" && rest.length > 1) {
			title = rest.slice(1).join(" ");
		}
		return { type: "commit", sha, title };
	}

	return { type: "custom", instructions: trimmed };
}

async function mergeBase(pi: ExtensionAPI, cwd: string, branch: string): Promise<string | undefined> {
	try {
		const result = await pi.exec("git", ["-C", cwd, "merge-base", "HEAD", branch], { timeout: 5000 });
		if (result.code === 0) {
			const sha = result.stdout.trim();
			if (sha) return sha;
		}
	} catch {
		// Fall back to the Codex backup prompt below.
	}
	return undefined;
}

async function buildReviewRequest(pi: ExtensionAPI, cwd: string, args: string): Promise<ReviewRequest | string> {
	const parsed = parseArgs(args);

	switch (parsed.type) {
		case "help":
			return usage();
		case "uncommitted":
			return { prompt: UNCOMMITTED_PROMPT, hint: "current changes" };
		case "base": {
			if (!parsed.branch) return usage();
			const sha = await mergeBase(pi, cwd, parsed.branch);
			const prompt = sha
				? render(BASE_BRANCH_PROMPT, { baseBranch: parsed.branch, mergeBaseSha: sha })
				: render(BASE_BRANCH_PROMPT_BACKUP, { branch: parsed.branch });
			return { prompt, hint: `changes against '${parsed.branch}'` };
		}
		case "commit": {
			if (!parsed.sha) return usage();
			const prompt = parsed.title
				? render(COMMIT_PROMPT_WITH_TITLE, { sha: parsed.sha, title: parsed.title })
				: render(COMMIT_PROMPT, { sha: parsed.sha });
			const hint = parsed.title ? `commit ${shortSha(parsed.sha)}: ${parsed.title}` : `commit ${shortSha(parsed.sha)}`;
			return { prompt, hint };
		}
		case "custom": {
			const instructions = parsed.instructions?.trim();
			if (!instructions) return usage();
			return { prompt: instructions, hint: instructions };
		}
	}
}

function textFromContent(content: unknown): string {
	if (typeof content === "string") return content;
	if (!Array.isArray(content)) return "";
	return content
		.map((part) => {
			if (!part || typeof part !== "object") return "";
			const block = part as { type?: string; text?: string };
			return block.type === "text" && typeof block.text === "string" ? block.text : "";
		})
		.filter(Boolean)
		.join("\n");
}

function parseReviewOutput(text: string): ReviewOutput | undefined {
	const candidates = [text.trim()];
	const fenced = text.match(/```(?:json)?\s*([\s\S]*?)\s*```/i);
	if (fenced?.[1]) candidates.unshift(fenced[1].trim());
	const start = text.indexOf("{");
	const end = text.lastIndexOf("}");
	if (start !== -1 && end > start) candidates.push(text.slice(start, end + 1));

	for (const candidate of candidates) {
		try {
			const parsed = JSON.parse(candidate) as ReviewOutput;
			if (parsed && typeof parsed === "object" && Array.isArray(parsed.findings)) return parsed;
		} catch {
			// Try the next candidate.
		}
	}

	return undefined;
}

function priorityLabel(priority: number | null | undefined): string {
	switch (priority) {
		case 0:
			return "P0";
		case 1:
			return "P1";
		case 2:
			return "P2";
		case 3:
			return "P3";
		default:
			return "P?";
	}
}

function formatConfidence(score: number | undefined): string {
	return typeof score === "number" && Number.isFinite(score) ? `${Math.round(score * 100)}%` : "unknown";
}

function formatLocation(finding: ReviewFinding): string {
	const path = finding.code_location?.absolute_file_path;
	const start = finding.code_location?.line_range?.start;
	if (!path) return "Location: unknown";
	return typeof start === "number" ? `Location: ${path}:${start}` : `Location: ${path}`;
}

function stripPriorityPrefix(title: string): string {
	return title.replace(/^\[P[0-3]\]\s*/i, "");
}

function formatReviewOutput(output: ReviewOutput): string {
	const findings = output.findings ?? [];
	const lines: string[] = ["# Review findings", ""];

	if (findings.length === 0) {
		lines.push("No findings.", "");
	} else {
		findings.forEach((finding, index) => {
			const title = stripPriorityPrefix(finding.title ?? "Untitled finding");
			lines.push(`## ${index + 1}. [${priorityLabel(finding.priority)}] ${title}`);
			lines.push(`- ${formatLocation(finding)}`);
			lines.push(`- Confidence: ${formatConfidence(finding.confidence_score)}`);
			if (finding.body?.trim()) lines.push("", finding.body.trim());
			lines.push("");
		});
	}

	lines.push(`Overall: ${output.overall_correctness ?? "unknown"}`);
	if (output.overall_explanation?.trim()) lines.push("", output.overall_explanation.trim());
	lines.push("", `Overall confidence: ${formatConfidence(output.overall_confidence_score)}`);

	return lines.join("\n");
}

export default function codexReview(pi: ExtensionAPI) {
	let pendingReviewPrompt: string | undefined;
	let reviewInProgress = false;

	pi.registerCommand("review", {
		description: "Run a Codex-style code review",
		handler: async (args, ctx) => {
			const request = await buildReviewRequest(pi, ctx.cwd, args);
			if (typeof request === "string") {
				if (ctx.hasUI) ctx.ui.notify(request, "info");
				else pi.sendMessage({ customType: "review-help", content: request, display: true });
				return;
			}

			await ctx.waitForIdle();
			pendingReviewPrompt = request.prompt;
			if (ctx.hasUI) ctx.ui.notify(`Starting review: ${request.hint}`, "info");
			pi.sendUserMessage(request.prompt);
		},
	});

	pi.on("before_agent_start", async (event) => {
		if (!pendingReviewPrompt || event.prompt !== pendingReviewPrompt) return undefined;
		pendingReviewPrompt = undefined;
		reviewInProgress = true;

		return {
			systemPrompt: `${event.systemPrompt}

## Codex review mode

${REVIEW_SYSTEM_PROMPT}`,
		};
	});

	pi.on("message_end", async (event) => {
		if (!reviewInProgress || event.message.role !== "assistant") return undefined;

		const output = parseReviewOutput(textFromContent(event.message.content));
		if (!output) return undefined;

		reviewInProgress = false;
		return {
			message: {
				...event.message,
				content: [{ type: "text", text: formatReviewOutput(output) }],
			},
		};
	});
}
