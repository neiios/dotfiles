const ONBOARDING_NOTE = "Pi can explain its own features and look up its docs. Ask it how to use or extend Pi.";
const ANSI_ESCAPE = /\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])/g;
const PATCHED = Symbol.for("dotfiles.pi.no-onboarding-header.patched");

function stripAnsi(text: string): string {
	return text.replace(ANSI_ESCAPE, "");
}

function isBlankLine(line: string | undefined): boolean {
	return stripAnsi(line ?? "").trim() === "";
}

function removeBlankBeforeFirstLoadedLine(lines: string[]): string[] {
	const loadedIndex = lines.findIndex((line) => stripAnsi(line).includes("Loaded "));
	if (loadedIndex <= 0) return lines;

	let firstBlankIndex = loadedIndex;
	while (firstBlankIndex > 0 && isBlankLine(lines[firstBlankIndex - 1])) {
		firstBlankIndex--;
	}

	const blankCount = loadedIndex - firstBlankIndex;
	if (blankCount <= 1) return lines;

	const next = [...lines];
	next.splice(firstBlankIndex, blankCount - 1);
	return next;
}

function removeOnboardingNote(lines: string[]): string[] {
	const noteIndex = lines.findIndex((line) => stripAnsi(line).includes(ONBOARDING_NOTE));
	let next = [...lines];

	if (noteIndex !== -1) {
		next.splice(noteIndex, 1);

		const previousIndex = noteIndex - 1;
		if (previousIndex >= 0 && stripAnsi(next[previousIndex] ?? "").trim() === "") {
			next.splice(previousIndex, 1);
		}
	}

	next = removeBlankBeforeFirstLoadedLine(next);
	return next;
}

interface HeaderMatch {
	header: any;
	parent?: any;
	index?: number;
}

function findExpandableHeaderWithNote(root: unknown, parent?: any, index?: number, seen = new Set<object>()): HeaderMatch | undefined {
	if (!root || typeof root !== "object" || seen.has(root)) return undefined;
	seen.add(root);

	const children = Array.isArray((root as any).children) ? (root as any).children : [];
	for (let childIndex = 0; childIndex < children.length; childIndex++) {
		const found = findExpandableHeaderWithNote(children[childIndex], root, childIndex, seen);
		if (found) return found;
	}

	if (typeof (root as any).render !== "function" || typeof (root as any).setExpanded !== "function") {
		return undefined;
	}

	try {
		const lines = (root as any).render(200);
		if (Array.isArray(lines) && lines.some((line) => stripAnsi(String(line)).includes(ONBOARDING_NOTE))) {
			return { header: root, parent, index };
		}
	} catch {
		// Ignore components that cannot be rendered while searching.
	}

	return undefined;
}

function findFirstExpandableHeader(root: unknown, parent?: any, index?: number, seen = new Set<object>()): HeaderMatch | undefined {
	if (!root || typeof root !== "object" || seen.has(root)) return undefined;
	seen.add(root);

	const children = Array.isArray((root as any).children) ? (root as any).children : [];
	for (let childIndex = 0; childIndex < children.length; childIndex++) {
		const found = findFirstExpandableHeader(children[childIndex], root, childIndex, seen);
		if (found) return found;
	}

	return typeof (root as any).render === "function" && typeof (root as any).setExpanded === "function"
		? { header: root, parent, index }
		: undefined;
}

function rendersOnlyBlankLine(component: any): boolean {
	if (typeof component?.render !== "function") return false;
	try {
		const rendered = component.render(200);
		return Array.isArray(rendered) && rendered.length === 1 && isBlankLine(String(rendered[0]));
	} catch {
		return false;
	}
}

function removeSpacerAfterHeader(match: HeaderMatch): void {
	const children = match.parent?.children;
	if (!Array.isArray(children) || match.index === undefined) return;

	const next = children[match.index + 1];
	if (rendersOnlyBlankLine(next)) {
		children.splice(match.index + 1, 1);
	}
}

function patchHeaderRender(match: HeaderMatch): any {
	const header = match.header;
	if (!header[PATCHED]) {
		const originalRender = header.render.bind(header);
		header.render = (width: number) => removeOnboardingNote(originalRender(width));
		header[PATCHED] = true;
	}

	removeSpacerAfterHeader(match);
	return header;
}

export default function noOnboardingHeader(pi: any) {
	pi.on("session_start", (_event: unknown, ctx: any) => {
		if (!ctx.hasUI) return;

		ctx.ui.setHeader((tui: unknown) => {
			const builtInHeader = findExpandableHeaderWithNote(tui) ?? findFirstExpandableHeader(tui);
			if (!builtInHeader) {
				throw new Error("Could not find Pi startup header to patch");
			}

			return patchHeaderRender(builtInHeader);
		});
	});
}
