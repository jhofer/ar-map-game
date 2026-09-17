// Resolves every relative link and anchor in docs/**/*.md and root *.md.
// Anchors follow GitHub's slug rules: lowercase, punctuation dropped, spaces to hyphens,
// duplicate headings get -1, -2, ...
import fs from 'node:fs';
import path from 'node:path';
import { execSync } from 'node:child_process';

const root = execSync('git rev-parse --show-toplevel').toString().trim();

function walk(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((e) => {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) return e.name === 'node_modules' ? [] : walk(p);
    return e.name.endsWith('.md') ? [p] : [];
  });
}

const files = [
  ...fs.readdirSync(root).filter((f) => f.endsWith('.md')).map((f) => path.join(root, f)),
  ...walk(path.join(root, 'docs')),
];

// Fenced blocks and inline code spans are not links, even when they quote link syntax.
function stripCode(text) {
  return text.replace(/```[\s\S]*?```/g, '').replace(/`[^`\n]*`/g, '');
}

function slug(heading) {
  let h = heading
    .replace(/`([^`]*)`/g, '$1')
    .replace(/\*\*?([^*]*)\*\*?/g, '$1')
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
    .trim()
    .toLowerCase();
  let out = '';
  for (const ch of h) {
    if (/[\p{L}\p{N}_-]/u.test(ch)) out += ch;
    else if (ch === ' ' || ch === '\t') out += '-';
  }
  return out;
}

const anchors = new Map();
for (const f of files) {
  const seen = new Map();
  const set = new Set();
  for (const line of stripCode(fs.readFileSync(f, 'utf8')).split('\n')) {
    const m = /^#{1,6}\s+(.*)$/.exec(line);
    if (!m) continue;
    const s = slug(m[1]);
    const n = seen.get(s) ?? 0;
    seen.set(s, n + 1);
    set.add(n === 0 ? s : `${s}-${n}`);
  }
  anchors.set(path.resolve(f), set);
}

const bad = [];
const linkRe = /\[[^\]]*\]\(([^)\s]+)\)/g;
for (const f of files) {
  const text = stripCode(fs.readFileSync(f, 'utf8'));
  for (const m of text.matchAll(linkRe)) {
    const target = m[1];
    if (/^(https?:|mailto:)/.test(target)) continue;
    const [p, anchor] = target.split('#');
    const resolved = p === '' ? path.resolve(f) : path.resolve(path.dirname(f), p);
    if (!fs.existsSync(resolved)) { bad.push([f, target, 'missing file']); continue; }
    if (anchor) {
      const set = anchors.get(resolved);
      if (!set) { bad.push([f, target, 'target not a scanned markdown file']); continue; }
      if (!set.has(anchor)) bad.push([f, target, 'missing anchor']);
    }
  }
}

for (const [f, t, why] of bad) console.log(`BAD ${path.relative(root, f)} -> ${t} | ${why}`);
console.log(`check-links: ${files.length} files, ${bad.length} bad links`);
process.exit(bad.length === 0 ? 0 : 1);
