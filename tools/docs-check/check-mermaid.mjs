// Parses every ```mermaid block in docs/**/*.md and root *.md with the real mermaid parser.
import fs from 'node:fs';
import path from 'node:path';
import { execSync } from 'node:child_process';
import { JSDOM } from 'jsdom';

const dom = new JSDOM('<!doctype html><html><body></body></html>', { pretendToBeVisual: true });
globalThis.window = dom.window;
globalThis.document = dom.window.document;
globalThis.Element = dom.window.Element;
globalThis.Node = dom.window.Node;
globalThis.DOMParser = dom.window.DOMParser;
globalThis.SVGElement = dom.window.SVGElement;
globalThis.HTMLElement = dom.window.HTMLElement;
globalThis.getComputedStyle = dom.window.getComputedStyle;

const mermaid = (await import('mermaid')).default;
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

let total = 0;
let failed = 0;
for (const f of files) {
  const text = fs.readFileSync(f, 'utf8');
  for (const m of text.matchAll(/```mermaid\n([\s\S]*?)```/g)) {
    total++;
    try {
      await mermaid.parse(m[1]);
    } catch (e) {
      failed++;
      console.log(`BAD ${path.relative(root, f)}\n  ${String(e.message ?? e).split('\n').slice(0, 4).join('\n  ')}`);
    }
  }
}
console.log(`check-mermaid: ${total} diagrams, ${failed} failed`);
process.exit(failed === 0 ? 0 : 1);
