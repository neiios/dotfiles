import { execFile } from "node:child_process";
import { constants } from "node:fs";
import { access, readFile } from "node:fs/promises";
import { join } from "node:path";
import { promisify } from "node:util";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const execFileAsync = promisify(execFile);

async function findGitRoot(cwd: string): Promise<string | undefined> {
	try {
		const { stdout } = await execFileAsync("git", ["-C", cwd, "rev-parse", "--show-toplevel"], {
			encoding: "utf8",
		});
		const root = stdout.trim();
		return root.length > 0 ? root : undefined;
	} catch {
		return undefined;
	}
}

function escapeXmlAttribute(value: string): string {
	return value
		.replaceAll("&", "&amp;")
		.replaceAll('"', "&quot;")
		.replaceAll("<", "&lt;")
		.replaceAll(">", "&gt;");
}

async function readPiMdAtGitRoot(cwd: string): Promise<{ path: string; content: string } | undefined> {
	const gitRoot = await findGitRoot(cwd);
	if (!gitRoot) return undefined;

	const piMdPath = join(gitRoot, "PI.md");
	try {
		await access(piMdPath, constants.R_OK);
		return {
			path: piMdPath,
			content: await readFile(piMdPath, "utf8"),
		};
	} catch {
		return undefined;
	}
}

export default function gitRootPiMd(pi: ExtensionAPI) {
	let piMd: { path: string; content: string } | undefined;

	pi.on("session_start", async (_event, ctx) => {
		piMd = await readPiMdAtGitRoot(ctx.cwd);
		if (piMd && ctx.hasUI) {
			ctx.ui.notify(`Loaded ${piMd.path}`, "info");
		}
	});

	pi.on("before_agent_start", async (event) => {
		if (!piMd) return;

		return {
			systemPrompt: `${event.systemPrompt}\n\n<context-file path="${escapeXmlAttribute(piMd.path)}">\n${piMd.content}\n</context-file>`,
		};
	});
}
