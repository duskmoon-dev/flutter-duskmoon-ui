import { cpSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { resolve } from 'node:path';
import { spawnSync } from 'node:child_process';

const root = resolve(import.meta.dir, '..');
const design = resolve(process.argv[2] ?? resolve(root, '../design'));
const output = resolve(root, 'packages/duskmoon_theme/lib/src/generated');
const staging = mkdtempSync(resolve(tmpdir(), 'duskmoon-design-'));

function run(command: string[], cwd: string): void {
  const result = spawnSync(command[0], command.slice(1), { cwd, stdio: 'inherit' });
  if (result.status !== 0) throw new Error(`Failed: ${command.join(' ')}`);
}

function argb(color: { hex: string; alpha?: number }): string {
  const alpha = Math.round((color.alpha ?? 1) * 255).toString(16).padStart(2, '0');
  return `0x${alpha}${color.hex.slice(1)}`.toUpperCase().replace('0X', '0x');
}

try {
  writeFileSync(resolve(staging, 'codegen.yaml'), JSON.stringify({
    input: resolve(design, 'tokens'),
    output: 'json',
    targets: {
      dart: { output_dir: 'dart', file_pattern: '{theme}_tokens.g.dart', class_prefix: '' },
      json: { output_dir: 'json', file_pattern: '{theme}.json' },
    },
  }));
  run(['bun', resolve(design, 'scripts/codegen.ts'), 'generate', '--target', 'dart,json'], staging);

  const files = readdirSync(resolve(staging, 'dart')).filter(file => file.endsWith('_tokens.g.dart'));
  for (const file of files) {
    const path = resolve(staging, 'dart', file);
    const source = JSON.parse(readFileSync(resolve(staging, 'json', file.replace('_tokens.g.dart', '.json')), 'utf8'));
    let dart = readFileSync(path, 'utf8');
    // TODO(upstream): duskmoon-dev/design#2 — remove when Dart emits both surface tokens.
    // WORKAROUND(upstream): duskmoon-dev/design#2 — retain the public API and canonical colors.
    if (!dart.includes('static const Color surfaceVariant')) {
      dart = dart.replace(/^  static const Color surfaceContainerHighest = Color\(0x[0-9A-F]+\);$/m,
        `  static const Color surfaceContainerHighest = Color(${argb(source.colors['surface-container-highest'])});\n` +
        `  static const Color surfaceVariant = Color(${argb(source.colors['surface-variant'])});`);
    }

    const colors = new Map([...dart.matchAll(/static const Color (\w+) = Color\((0x[0-9A-F]+)\)/g)]
      .map(match => [match[1], match[2]]));
    for (const [name, color] of Object.entries(source.colors)) {
      const field = name.replace(/-([a-z0-9])/g, (_, letter) => letter.toUpperCase());
      if (colors.get(field) !== argb(color as { hex: string; alpha?: number })) {
        throw new Error(`${file}: ${name} differs from upstream`);
      }
    }
    if (colors.size !== Object.keys(source.colors).length) throw new Error(`${file}: token count differs`);
    writeFileSync(path, dart);
    console.log(`Verified ${colors.size} colors in ${file}`);
  }
  run(['dart', 'format', resolve(staging, 'dart')], root);
  for (const file of files) cpSync(resolve(staging, 'dart', file), resolve(output, file));
} finally {
  rmSync(staging, { recursive: true, force: true });
}
