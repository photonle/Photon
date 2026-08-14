#!/usr/bin/env node

// Turns a release-please generated release body into the three changelog formats
// we publish: Steam Workshop BBCode, the photonle/menu Jekyll update page, and
// Discord markdown.
//
// Input comes from RELEASE_CONTEXT (the `github.event.release` object).
// Usage: node build.mjs --out-dir dist

import { mkdir, writeFile } from 'node:fs/promises';
import { join } from 'node:path';

// release-please section name -> the type keys the menu site styles entries by.
const SECTION_TYPES = {
	'Features': 'new',
	'Bug Fixes': 'fix',
	'Performance': 'change',
	'Internal Changes': 'change',
	'Dependencies': 'change',
	'Documentation': 'change',
	'Miscellaneous': 'change',
	'Removals': 'remove',
	'Deprecations': 'warn'
};

// Section name -> the menu site's category keys (mirrors the old categories.json).
const SECTION_CATEGORIES = {
	'Features': 'features',
	'Bug Fixes': 'fixes',
	'Performance': 'changes',
	'Internal Changes': 'changes',
	'Dependencies': 'changes',
	'Documentation': 'changes',
	'Miscellaneous': 'changes',
	'Removals': 'changes',
	'Deprecations': 'deprecated'
};

const DEFAULT_TYPE = 'change';
const DEFAULT_CATEGORY = 'changes';

function parseArgs(argv) {
	const args = { outDir: 'dist' };
	for (let i = 0; i < argv.length; i++) {
		if (argv[i] === '--out-dir') {
			args.outDir = argv[++i];
		}
	}
	return args;
}

// Strips the trailing "([abc1234](url))" commit and "([#12](url))" pull request
// references release-please appends; an entry can carry both.
function stripCommitRefs(text) {
	let out = text.trim();
	let previous;
	do {
		previous = out;
		out = out.replace(/\s*\(\[(?:#\d+|[0-9a-f]{6,})\]\([^)]*\)\)$/i, '').trimEnd();
	} while (out !== previous);
	return out;
}

function stripLinks(text) {
	return text.replace(/\[([^\]]*)\]\([^)]*\)/g, '$1');
}

function stripEmphasis(text) {
	return text.replace(/\*\*([^*]+)\*\*/g, '$1').replace(/(?<!\*)\*([^*]+)\*(?!\*)/g, '$1');
}

function emphasisToBBCode(text) {
	return text.replace(/\*\*([^*]+)\*\*/g, '[b]$1[/b]').replace(/(?<!\*)\*([^*]+)\*(?!\*)/g, '[i]$1[/i]');
}

// release-please bodies are a flat list of "### Section" headings followed by
// "* item" bullets. Anything before the first heading (or a body with no
// headings at all, e.g. a hand-written release) lands in a nameless section.
function parseBody(body) {
	const sections = [];
	let current = null;

	for (const rawLine of (body ?? '').split('\n')) {
		const line = rawLine.trim();
		if (line === '') { continue; }

		const heading = line.match(/^#{2,4}\s+(.*)$/);
		if (heading) {
			const name = stripLinks(stripEmphasis(heading[1])).trim();
			// The "## [76.4.0](compare) (date)" version heading is not a section.
			if (/^\[?\d+\.\d+\.\d+/.test(name)) { continue; }
			current = { name, items: [] };
			sections.push(current);
			continue;
		}

		const bullet = line.match(/^[*-]\s+(.*)$/);
		if (!bullet) { continue; }

		const text = stripCommitRefs(bullet[1]);
		if (text === '') { continue; }

		if (!current) {
			current = { name: '', items: [] };
			sections.push(current);
		}
		current.items.push(text);
	}

	return sections.filter((section) => section.items.length > 0);
}

function formatDate(published) {
	const date = new Date(published);
	const pad = (value) => String(value).padStart(2, '0');
	return `${date.getUTCFullYear()}-${pad(date.getUTCMonth() + 1)}-${pad(date.getUTCDate())} ` +
		`${pad(date.getUTCHours())}:${pad(date.getUTCMinutes())}`;
}

function yamlString(value) {
	return `'${String(value).replace(/'/g, "''")}'`;
}

function buildWorkshop(sections, title) {
	const lines = [`[h1]${title}[/h1]`, ''];
	for (const section of sections) {
		if (section.name !== '') {
			lines.push(`[b]${section.name}[/b]`);
		}
		lines.push('[list]');
		for (const item of section.items) {
			lines.push(`[*]${emphasisToBBCode(stripLinks(item))}`);
		}
		lines.push('[/list]', '');
	}
	return lines.join('\n').trimEnd() + '\n';
}

function buildDiscord(sections, title, url) {
	const lines = [`## ${title}`, ''];
	for (const section of sections) {
		if (section.name !== '') {
			lines.push(`**${section.name}**`);
		}
		for (const item of section.items) {
			lines.push(`- ${item}`);
		}
		lines.push('');
	}
	if (url) {
		lines.push(`<${url}>`);
	}
	return lines.join('\n').trimEnd() + '\n';
}

// Jekyll page for photonle/menu's _updates collection: YAML frontmatter only,
// matching the shape the old PHP builder produced.
function buildMenuPage(sections, { title, date }) {
	const categories = new Map();
	for (const section of sections) {
		const category = SECTION_CATEGORIES[section.name] ?? DEFAULT_CATEGORY;
		const type = SECTION_TYPES[section.name] ?? DEFAULT_TYPE;
		if (!categories.has(category)) { categories.set(category, []); }
		const entries = categories.get(category);
		for (const item of section.items) {
			entries.push({ change: stripEmphasis(stripLinks(item)), type });
		}
	}

	const lines = ['---'];
	if (title) { lines.push(`name: ${yamlString(title)}`); }
	lines.push(`date: ${yamlString(date)}`);
	if (categories.size > 0) {
		lines.push('changes:');
		for (const [category, entries] of categories) {
			lines.push(`  ${category}:`);
			for (const entry of entries) {
				lines.push(`    - change: ${yamlString(entry.change)}`);
				lines.push(`      type: ${yamlString(entry.type)}`);
			}
		}
	}
	lines.push('---');
	return lines.join('\n') + '\n';
}

const { outDir } = parseArgs(process.argv.slice(2));

if (!process.env.RELEASE_CONTEXT) {
	console.error('RELEASE_CONTEXT is not set.');
	process.exit(1);
}

const release = JSON.parse(process.env.RELEASE_CONTEXT);
const tag = release.tag_name ?? '';
const version = tag.replace(/^v/i, '');
// The menu site indexes updates by the two-part id (76.4), not the full semver.
const shortVersion = version.match(/^(\d+\.\d+)/)?.[1] ?? version;
const sections = parseBody(release.body);
const title = release.name && release.name !== '' ? release.name : `Photon ${version}`;

if (sections.length === 0) {
	console.warn('No changelog entries were parsed from the release body.');
}

await mkdir(outDir, { recursive: true });
await Promise.all([
	writeFile(join(outDir, 'workshop.bbcode.txt'), buildWorkshop(sections, title)),
	writeFile(join(outDir, 'discord.md'), buildDiscord(sections, `Photon ${tag || version}`, release.html_url)),
	writeFile(join(outDir, `${shortVersion}.html`), buildMenuPage(sections, {
		title,
		date: formatDate(release.published_at ?? release.created_at)
	}))
]);

console.log(`Wrote workshop.bbcode.txt, discord.md and ${shortVersion}.html to ${outDir}/`);
console.log(`Parsed ${sections.length} section(s): ${sections.map((s) => s.name || '(untitled)').join(', ')}`);
