// Generates CHEATSHEET.md (shown inside Neovim with <leader>K) from the key data in CHEATSHEET.html,
// so both always list the same keys. Run after editing the HTML:  node ~/dotfiles/nvim/cheatsheet-gen.js
const fs = require('fs');
const path = require('path');
const dir = __dirname;
const html = fs.readFileSync(path.join(dir, 'CHEATSHEET.html'), 'utf8');
const js = html.match(/<script>([\s\S]*)<\/script>/)[1];
const data = js.slice(js.indexOf('const FIRST'), js.indexOf('const esc'));
const { FIRST, GROUPS, MOVED } = new Function(data + '; return { FIRST, GROUPS, MOVED };')();

// "<leader>gh" -> "Space g h", "<C-s>" -> "Ctrl+s", "a|b" -> "a / b"
const NAMES = { CR: 'Enter', Esc: 'Esc', Tab: 'Tab', Up: 'Up', Down: 'Down', Left: 'Left', Right: 'Right', Space: 'Space' };
function seq(s) {
  const out = [];
  const re = /<leader>|<[^>]+>|./g;
  let m;
  while ((m = re.exec(s))) {
    const t = m[0];
    if (t === '<leader>') { out.push('Space'); continue; }
    const mod = t.match(/^<([CSA])-(.+)>$/);
    if (mod) { out.push({ C: 'Ctrl', S: 'Shift', A: 'Alt' }[mod[1]] + '+' + (NAMES[mod[2]] || mod[2])); continue; }
    const named = t.match(/^<(.+)>$/);
    if (named && t.length > 1) { out.push(NAMES[named[1]] || named[1]); continue; }
    out.push(t);
  }
  return out.join(' ');
}
function keys(spec) {
  const alts = spec.split(/\|(?=.)/).filter(Boolean);
  const fixed = [];
  for (let i = 0; i < alts.length; i++) {
    if (alts[i] === '<leader>') { fixed.push('<leader>|'); continue; }
    if (alts[i] === '<' && alts[i + 1] === '>') { fixed.push('<', '>'); i++; continue; }
    fixed.push(alts[i]);
  }
  return fixed.map(seq).join(' / ');
}
const TAG = { rust: '[rust]', c: '[c/c++]', git: '[git]', visual: '[visual]', 'n/visual': '[+visual]', insert: '[insert]' };
const W = 30;
const row = (k, d, t) => '  ' + keys(k).padEnd(W) + ' ' + d + (t ? '  ' + TAG[t] : '');

const out = [];
out.push('# Neovim Keys');
out.push('');
out.push('Space is the leader. Search this sheet with /  (n / N = next / previous match), close with q.');
out.push('Space s K = fuzzy-search these lines.   Space ? = keys of the current file.   Space s k = all live keymaps.');
out.push('Tags: [rust] Rust files  [c/c++] C and C++ files  [git] files in a git repo  [visual] after selecting  [insert] while typing');
out.push('');
out.push('## Learn these first');
for (const [k, d] of FIRST) out.push(row(k, d));
for (const g of GROUPS) {
  const label = g.keyLabel ? g.keyLabel : 'Space ' + g.key;
  out.push('');
  out.push(`## ${g.name}  (${label})${g.sub ? '  - ' + g.sub : ''}`);
  for (const [title, rows] of g.sections) {
    if (title) { out.push(''); out.push('### ' + title); }
    for (const [k, d, t] of rows) out.push(row(k, d, t));
  }
}
out.push('');
out.push('## Moved keys  (old -> new)');
for (const [o, n, d] of MOVED) out.push('  ' + (keys(o) + '  ->  ' + keys(n)).padEnd(W + 16) + ' ' + d);
out.push('');
fs.writeFileSync(path.join(dir, 'CHEATSHEET.md'), out.join('\n'));
console.log('wrote', path.join(dir, 'CHEATSHEET.md'), out.length, 'lines');
