import { execFileSync } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import { DefaultResourceLoader } from "@earendil-works/pi-coding-agent";
import type { ExtensionAPI, ExtensionCommandContext, ExtensionContext } from "@earendil-works/pi-coding-agent";

const STATE_TYPE = "repo-context-on-demand-state";
// Temporarily disable app-market repo context autoloading; /userepo still enables it on demand.
const AUTOLOAD_APP_MARKET_REPO_CONTEXT = false;
const DEFAULT_ENABLED_REMOTE_URL = "https://github.com/wix-private/app-market";

interface RepoContextState {
	enabled: boolean;
}

interface ContextFile {
	path: string;
	content: string;
}

const CONTEXT_FILE_CANDIDATES = ["AGENTS.md", "AGENTS.MD", "CLAUDE.md", "CLAUDE.MD"];
const SKILL_BLACKLIST = new Set([
	"ai-verify:ai-verify-feedback",
	"ai-verify:ai-verify-pr-review",
	"ai-verify:ai-verify-rules",
	"bazel-split-test-ci-optimization:analyze-profile",
	"bazel-split-test-ci-optimization:analyze-test-setup",
	"bazel-split-test-ci-optimization:split-and-optimize-test-target",
	"bazel-split-test-ci-optimization:split-test-target",
	"domain-modeling:mermaid-link-generator",
	"domain-modeling:validating-mermaid",
	"wix-flow:reflect",
]);

function existsDirectory(p: string): boolean {
	try {
		return fs.statSync(p).isDirectory();
	} catch {
		return false;
	}
}

function existsFile(p: string): boolean {
	try {
		return fs.statSync(p).isFile();
	} catch {
		return false;
	}
}

function findRepoRoot(cwd: string): string {
	let current = path.resolve(cwd);

	while (true) {
		if (existsDirectory(path.join(current, ".git")) || existsFile(path.join(current, ".git"))) {
			return current;
		}

		const parent = path.dirname(current);
		if (parent === current) {
			return path.resolve(cwd);
		}
		current = parent;
	}
}

function dirsFromRepoRootToCwd(cwd: string): string[] {
	const resolvedCwd = path.resolve(cwd);
	const repoRoot = findRepoRoot(resolvedCwd);
	const dirs: string[] = [];
	let current = resolvedCwd;

	while (true) {
		dirs.push(current);
		if (current === repoRoot) break;

		const parent = path.dirname(current);
		if (parent === current) break;
		current = parent;
	}

	return dirs.reverse();
}

function loadContextFileFromDir(dir: string): ContextFile | undefined {
	for (const fileName of CONTEXT_FILE_CANDIDATES) {
		const filePath = path.join(dir, fileName);
		if (!existsFile(filePath)) continue;

		try {
			return { path: filePath, content: fs.readFileSync(filePath, "utf8") };
		} catch {
			return undefined;
		}
	}

	return undefined;
}

function loadRepoContextFiles(cwd: string): ContextFile[] {
	const seen = new Set<string>();
	const files: ContextFile[] = [];

	for (const dir of dirsFromRepoRootToCwd(cwd)) {
		const file = loadContextFileFromDir(dir);
		if (!file || seen.has(file.path)) continue;
		seen.add(file.path);
		files.push(file);
	}

	return files;
}

function findRepoSkillDirs(cwd: string): string[] {
	const dirs: string[] = [];
	const seen = new Set<string>();

	for (const dir of dirsFromRepoRootToCwd(cwd)) {
		for (const relative of [path.join(".agents", "skills"), path.join(".pi", "skills")]) {
			const skillDir = path.join(dir, relative);
			if (!existsDirectory(skillDir) || seen.has(skillDir)) continue;
			seen.add(skillDir);
			dirs.push(skillDir);
		}
	}

	return dirs;
}

function restoreEnabledFromBranch(ctx: ExtensionContext): boolean | undefined {
	let enabled: boolean | undefined;
	for (const entry of ctx.sessionManager.getBranch()) {
		if (entry.type !== "custom" || entry.customType !== STATE_TYPE) continue;
		const data = entry.data as RepoContextState | undefined;
		if (typeof data?.enabled === "boolean") {
			enabled = data.enabled;
		}
	}
	return enabled;
}

function normalizeRemoteUrl(url: string): string {
	return url.trim().replace(/\.git$/, "").replace(/\/$/, "");
}

function repoHasDefaultEnabledRemote(cwd: string): boolean {
	if (!AUTOLOAD_APP_MARKET_REPO_CONTEXT) return false;

	try {
		const output = execFileSync("git", ["-C", cwd, "remote", "-v"], {
			stdio: ["ignore", "pipe", "ignore"],
		}).toString("utf8");
		return output
			.split(/\s+/)
			.some((token) => normalizeRemoteUrl(token) === DEFAULT_ENABLED_REMOTE_URL);
	} catch {
		return false;
	}
}

const SKILL_DIAGNOSTICS_PATCH = Symbol.for("load-repo-context.skill-filter-and-diagnostics-patch");
const REPO_SKILL_ROOTS = Symbol.for("load-repo-context.repo-skill-roots");

interface SkillDiagnostic {
	type: string;
	message: string;
	path?: string;
}

interface SkillLike {
	name?: string;
	filePath?: string;
}

interface SkillDiagnosticsPatchState {
	roots: Set<string>;
}

function patchState(): SkillDiagnosticsPatchState {
	const globalObject = globalThis as Record<symbol, SkillDiagnosticsPatchState | undefined>;
	globalObject[REPO_SKILL_ROOTS] ??= { roots: new Set<string>() };
	return globalObject[REPO_SKILL_ROOTS];
}

function pathIsUnder(child: string, parent: string): boolean {
	const relativePath = path.relative(parent, child);
	return relativePath === "" || (!!relativePath && !relativePath.startsWith("..") && !path.isAbsolute(relativePath));
}

function isSkillNameValidationWarning(diagnostic: SkillDiagnostic): boolean {
	return (
		diagnostic.type === "warning" &&
		(
			diagnostic.message.startsWith("name ") ||
			diagnostic.message === "name contains invalid characters (must be lowercase a-z, 0-9, hyphens only)"
		)
	);
}

function isRepoSkillNameValidationWarning(diagnostic: SkillDiagnostic): boolean {
	if (!diagnostic.path || !isSkillNameValidationWarning(diagnostic)) return false;
	const resolvedPath = path.resolve(diagnostic.path);
	return Array.from(patchState().roots).some((root) => pathIsUnder(resolvedPath, root));
}

function installSkillDiagnosticsPatch() {
	const proto = DefaultResourceLoader.prototype as any;
	if (proto[SKILL_DIAGNOSTICS_PATCH]) return;

	const originalGetSkills = proto.getSkills;
	proto.getSkills = function patchedGetSkills(this: unknown) {
		const result = originalGetSkills.call(this) as { skills: SkillLike[]; diagnostics: SkillDiagnostic[] };
		const blacklistedSkillPaths = new Set(
			result.skills
				.filter((skill) => skill.name && SKILL_BLACKLIST.has(skill.name))
				.map((skill) => skill.filePath && path.resolve(skill.filePath))
				.filter((filePath): filePath is string => Boolean(filePath)),
		);

		return {
			...result,
			skills: result.skills.filter((skill) => !skill.name || !SKILL_BLACKLIST.has(skill.name)),
			diagnostics: result.diagnostics.filter((diagnostic) => {
				if (diagnostic.path && blacklistedSkillPaths.has(path.resolve(diagnostic.path))) return false;
				return !isRepoSkillNameValidationWarning(diagnostic);
			}),
		};
	};
	proto[SKILL_DIAGNOSTICS_PATCH] = true;
}

function formatContextFiles(cwd: string, files: ContextFile[]): string {
	const parts = files.map((file) => {
		const relativePath = path.relative(cwd, file.path) || path.basename(file.path);
		return `<context_file path=${JSON.stringify(relativePath)} absolute_path=${JSON.stringify(file.path)}>\n${file.content}\n</context_file>`;
	});

	return `\n\n## Repository context\n\nTreat the following files as repository instructions for this session.\n\n<repo_context_files>\n${parts.join("\n\n")}\n</repo_context_files>\n`;
}

function startupLoadedFilePaths(cwd: string): string[] {
	const repoRoot = findRepoRoot(cwd);
	const piMdPath = path.join(repoRoot, "PI.md");
	const paths = existsFile(piMdPath) ? [piMdPath] : [];

	for (const file of loadRepoContextFiles(cwd)) {
		if (!paths.includes(file.path)) paths.push(file.path);
	}

	return paths;
}

function formatLoadedResourcesMessage(cwd: string, contextFiles: ContextFile[], skillDirs: string[]): string {
	const contextList =
		contextFiles.length > 0
			? contextFiles.map((file) => `- ${path.relative(cwd, file.path) || path.basename(file.path)}`).join("\n")
			: "- none";
	const skillList =
		skillDirs.length > 0
			? skillDirs.map((dir) => `- ${path.relative(cwd, dir) || path.basename(dir)}`).join("\n")
			: "- none";

	return `Repository context enabled.\n\nContext files:\n${contextList}\n\nSkill directories:\n${skillList}`;
}

export default function loadRepoContextExtension(pi: ExtensionAPI) {
	installSkillDiagnosticsPatch();

	let enabled = false;
	let explicitEnabledState: boolean | undefined;

	function isRepoContextEnabled(cwd: string): boolean {
		return explicitEnabledState ?? repoHasDefaultEnabledRemote(cwd);
	}

	function persistState(value: boolean) {
		explicitEnabledState = value;
		enabled = value;
		pi.appendEntry<RepoContextState>(STATE_TYPE, { enabled: value });
	}

	async function enableRepoContext(ctx: ExtensionCommandContext) {
		persistState(true);
		const contextFiles = loadRepoContextFiles(ctx.cwd);
		const skillDirs = findRepoSkillDirs(ctx.cwd);
		const message = formatLoadedResourcesMessage(ctx.cwd, contextFiles, skillDirs);

		pi.sendMessage({
			customType: "repo-context-loaded",
			content: message,
			display: true,
		});
		ctx.ui.notify(
			`Repository context enabled (${contextFiles.length} context file(s), ${skillDirs.length} skill dir(s)). Reloading resources...`,
			"info",
		);
		await ctx.reload();
	}

	async function disableRepoContext(ctx: ExtensionCommandContext) {
		persistState(false);
		ctx.ui.notify("Repository context disabled. Reloading resources...", "info");
		await ctx.reload();
	}

	pi.registerCommand("userepo", {
		description: "Load AGENTS.md/CLAUDE.md and repo skills from the current repository",
		handler: async (_args, ctx) => enableRepoContext(ctx),
	});

	pi.registerCommand("nouserepo", {
		description: "Stop injecting current repository context and unload repo skills",
		handler: async (_args, ctx) => disableRepoContext(ctx),
	});


	pi.registerCommand("load-repo-context", {
		description: "Alias for /userepo",
		handler: async (_args, ctx) => enableRepoContext(ctx),
	});

	pi.registerCommand("unload-repo-context", {
		description: "Alias for /nouserepo",
		handler: async (_args, ctx) => disableRepoContext(ctx),
	});

	pi.registerCommand("repo-context-status", {
		description: "Show whether repository context is enabled",
		handler: async (_args, ctx) => {
			const currentEnabled = isRepoContextEnabled(ctx.cwd);
			const contextCount = currentEnabled ? loadRepoContextFiles(ctx.cwd).length : 0;
			const skillDirCount = currentEnabled ? findRepoSkillDirs(ctx.cwd).length : 0;
			ctx.ui.notify(
				currentEnabled
					? `Repository context is enabled (${contextCount} context file(s), ${skillDirCount} skill dir(s)).`
					: "Repository context is disabled.",
				"info",
			);
		},
	});

	pi.on("session_start", async (_event, ctx) => {
		explicitEnabledState = restoreEnabledFromBranch(ctx);
		enabled = isRepoContextEnabled(ctx.cwd);

		if (enabled && ctx.hasUI) {
			const loadedFilePaths = startupLoadedFilePaths(ctx.cwd);
			if (loadedFilePaths.length > 0) {
				ctx.ui.notify(loadedFilePaths.map((filePath) => `Loaded ${filePath}`).join("\n") + "\n", "info");
			}
		}
	});

	pi.on("session_tree", async (_event, ctx) => {
		explicitEnabledState = restoreEnabledFromBranch(ctx);
		enabled = isRepoContextEnabled(ctx.cwd);
	});

	pi.on("resources_discover", async (event) => {
		enabled = isRepoContextEnabled(event.cwd);
		if (!enabled) return;

		const skillPaths = findRepoSkillDirs(event.cwd);
		if (skillPaths.length === 0) return;

		const state = patchState();
		for (const skillPath of skillPaths) {
			state.roots.add(path.resolve(skillPath));
		}

		return { skillPaths };
	});

	pi.on("before_agent_start", async (event, ctx) => {
		enabled = isRepoContextEnabled(ctx.cwd);
		if (!enabled) return;

		const contextFiles = loadRepoContextFiles(ctx.cwd);
		if (contextFiles.length === 0) return;

		return {
			systemPrompt: event.systemPrompt + formatContextFiles(ctx.cwd, contextFiles),
		};
	});
}
