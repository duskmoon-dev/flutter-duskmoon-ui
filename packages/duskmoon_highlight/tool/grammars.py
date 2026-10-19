#!/usr/bin/env python3
"""Build and verify the pinned Tree-sitter source/asset inventory."""
import argparse
import concurrent.futures
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / 'grammars.json'
GENERATED = ROOT / 'lib/src/tree_sitter/generated/grammars.dart'


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inventory(manifest):
    files = set()
    for folder in ('vendor', 'assets', 'queries', 'patches', 'src'):
        files.update(p for p in (ROOT / folder).rglob('*') if p.is_file())
    return {str(p.relative_to(ROOT)): digest(p) for p in sorted(files)}


def dart_source(manifest):
    def literal(value):
        return json.dumps(value, ensure_ascii=False).replace('$', r'\$')
    lines = ['// GENERATED CODE - run python3 tool/grammars.py generate.', '',
             'const treeSitterGrammarData =',
             '    <String, ({String symbol, String highlights, String wasmAsset})>{']
    for grammar in manifest['grammars']:
        query = (ROOT / grammar['highlights']).read_text()
        lines.append(f'  {literal(grammar["id"])}: (')
        lines.append(f'    symbol: {literal(grammar["symbol"])},')
        lines.append(f'    highlights: {literal(query)},')
        lines.append(f'    wasmAsset: {literal(grammar["wasm"])},')
        lines.append('  ),')
    lines.extend(['};', 'const treeSitterAliases = <String, String>{'])
    lines.extend(f'  {literal(alias)}: {literal(language)},'
                 for alias, language in sorted(manifest['aliases'].items()))
    lines.extend(['};', ''])
    dart = os.environ.get('DART') or shutil.which('dart')
    if not dart:
        raise SystemExit('Dart is required to format the generated inventory.')
    with tempfile.TemporaryDirectory() as temporary:
        path = Path(temporary) / 'grammars.dart'
        path.write_text('\n'.join(lines))
        subprocess.run([dart, 'format', '--language-version=3.6', str(path)],
                       check=True, stdout=subprocess.DEVNULL)
        return path.read_text()


def licenses(manifest):
    notices = ['Tree-sitter third-party source inventory', '',
               'Original notices are retained in the paths below.',
               'Source revisions and archive SHA-256 values: grammars.json.', '']
    texts = []
    seen = set()
    components = [('Tree-sitter / web-tree-sitter 0.27.1',
                   ['vendor/tree-sitter/LICENSE'])]
    components.extend((g['id'] + ' (' + g['repository'] + '@' + g['revision'] + ')',
                       g['licenses']) for g in manifest['grammars'])
    for component, paths in components:
        notices.append(component)
        for relative in paths:
            path = ROOT / relative
            notices.append('  ' + relative)
            content = path.read_text()
            key = digest(path)
            if key not in seen:
                seen.add(key)
                texts.extend([component, relative, '', content.rstrip(), '',
                              '=' * 72, ''])
        notices.append('')
    return '\n'.join(notices), '\n'.join(texts)


def build_wasm(manifest, executable, jobs):
    version = subprocess.check_output([executable, '--version'], text=True)
    if f'tree-sitter {manifest["toolchain"]["cli"]}' not in version:
        raise SystemExit('Use the CLI version pinned in grammars.json.')
    def build(grammar):
        output = ROOT / grammar['wasm']
        cpp = [ROOT / source for source in grammar['sources']
               if source.endswith(('.cc', '.cpp'))]
        if cpp:
            # CLI 0.26.8 detects scanner.c only. Compile C and C++ separately
            # with its same WASI/PIC/shared-module contract, retaining scanners.
            sdk = Path(os.environ.get('TREE_SITTER_WASI_SDK_PATH') or
                       os.environ.get('WASI_SDK_PATH') or
                       Path.home() / '.cache/tree-sitter/wasi-sdk')
            clang = sdk / 'bin/clang'
            clangpp = sdk / 'bin/clang++'
            if not clang.is_file() or not clangpp.is_file():
                return grammar['id'] + ': set WASI_SDK_PATH to the pinned WASI SDK'
            version_file = sdk / 'VERSION'
            if (not version_file.is_file() or
                    version_file.read_text().splitlines()[0] !=
                    manifest['toolchain']['wasi_sdk']):
                return grammar['id'] + ': use WASI SDK ' + manifest['toolchain']['wasi_sdk']
            common = ['--target=wasm32-unknown-wasi', '-fPIC', '-Os',
                      '-fno-exceptions', '-fno-rtti', '-DNDEBUG',
                      '-fvisibility=hidden']
            includes = [argument for directory in grammar['includeDirectories']
                        for argument in ('-I', str(ROOT / directory))]
            sources = [ROOT / source for source in grammar['sources']]
            if cpp:
                sources.append(ROOT / 'src/wasm/cpp_scanner_support.cc')
            try:
                with tempfile.TemporaryDirectory() as temporary:
                    objects = []
                    for index, source in enumerate(sources):
                        obj = Path(temporary) / f'{index}.o'
                        is_cpp = source.suffix in ('.cc', '.cpp')
                        subprocess.run([str(clangpp if is_cpp else clang),
                                        *common, *(['-std=c++17'] if is_cpp else []),
                                        *includes, '-c', str(source), '-o', str(obj)],
                                       check=True, text=True, capture_output=True)
                        objects.append(str(obj))
                    subprocess.run([str(clang), '--target=wasm32-unknown-wasi',
                                    '-fPIC', '-shared', '-Os', '-nostdlib',
                                    '-Wl,--export=' + grammar['symbol'],
                                    '-Wl,--allow-undefined', '-Wl,--no-entry',
                                    *objects, '-o', str(output)],
                                   check=True, text=True, capture_output=True)
            except subprocess.CalledProcessError as error:
                output.unlink(missing_ok=True)
                return grammar['id'] + ': ' + error.stdout + error.stderr
            print('Built ' + grammar['id'], flush=True)
            return None
        result = subprocess.run([executable, 'build', '--wasm', '--output',
                                 str(output), str(ROOT / grammar['source_root'] /
                                                  grammar['directory'])],
                                text=True, capture_output=True)
        if result.returncode:
            output.unlink(missing_ok=True)
            return grammar['id'] + ': ' + result.stdout + result.stderr
        print('Built ' + grammar['id'], flush=True)
        return None
    with concurrent.futures.ThreadPoolExecutor(max_workers=jobs) as pool:
        failures = [error for error in pool.map(build, manifest['grammars']) if error]
    if failures:
        raise SystemExit('\n'.join(failures))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command', choices=('generate', 'verify', 'build-wasm'))
    parser.add_argument('--tree-sitter', default='tree-sitter')
    parser.add_argument('--jobs', type=int, default=3)
    parser.add_argument('--languages', nargs='+', help='Build only these grammar IDs')
    args = parser.parse_args()
    manifest = json.loads(MANIFEST.read_text())
    if args.command == 'build-wasm':
        if args.languages:
            unknown = set(args.languages) - {g['id'] for g in manifest['grammars']}
            if unknown:
                raise SystemExit('Unknown grammars: ' + ', '.join(sorted(unknown)))
            manifest['grammars'] = [g for g in manifest['grammars']
                                    if g['id'] in args.languages]
        build_wasm(manifest, args.tree_sitter, args.jobs)
        return
    source = dart_source(manifest)
    notices, license_text = licenses(manifest)
    if args.command == 'generate':
        manifest['sha256'] = inventory(manifest)
        MANIFEST.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + '\n')
        GENERATED.write_text(source)
        (ROOT / 'THIRD_PARTY_NOTICES').write_text(notices)
        (ROOT / 'THIRD_PARTY_LICENSES').write_text(license_text)
    else:
        expected = inventory(manifest)
        assert manifest['sha256'] == expected, 'Source/asset hashes differ from grammars.json'
        assert GENERATED.read_text() == source, 'Regenerate the Dart query inventory'
        assert (ROOT / 'THIRD_PARTY_NOTICES').read_text() == notices, 'Regenerate notices'
        assert (ROOT / 'THIRD_PARTY_LICENSES').read_text() == license_text, 'Regenerate licenses'
        for grammar in manifest['grammars']:
            assert (ROOT / grammar['wasm']).is_file(), grammar['id']
            assert (ROOT / grammar['highlights']).read_text().strip(), grammar['id']
        print(f'Verified {len(manifest["grammars"])} pinned grammars and assets')


if __name__ == '__main__':
    main()
