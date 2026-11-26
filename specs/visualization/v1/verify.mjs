import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const root = fileURLToPath(new URL(".", import.meta.url));
const sha256 = (bytes) => createHash("sha256").update(bytes).digest("hex");
const readJson = (path) => JSON.parse(readFileSync(join(root, path), "utf8"));

function filesIn(directory) {
  return readdirSync(join(root, directory), { withFileTypes: true }).flatMap((entry) => {
    const path = [directory, entry.name].filter(Boolean).join("/");
    if (entry.isDirectory()) return filesIn(path);
    assert(entry.isFile(), `Expected a regular file at ${path}`);
    return [path];
  });
}

const manifestBytes = readFileSync(join(root, "manifest.json"));
const manifest = JSON.parse(manifestBytes);
const paths = filesIn("").filter((path) => path !== "manifest.json").sort();
assert.deepEqual(manifest.files.map(({ path }) => path), paths, "Manifest file list differs");
for (const file of manifest.files) {
  const bytes = readFileSync(join(root, file.path));
  const contents = new TextDecoder("utf-8", { fatal: true }).decode(bytes);
  assert(Buffer.from(contents).equals(bytes) && !contents.includes("\r") && contents.endsWith("\n"),
    `${file.path} must use UTF-8 and LF with a final newline`);
  assert.equal(sha256(bytes), file.sha256, `SHA-256 mismatch for ${file.path}`);
}

const groups = paths.filter((path) => path.startsWith("fixtures/")).map((path) => path.slice("fixtures/".length));
assert(groups.length > 0, "Expected fixture groups");
assert.deepEqual(groups.map((name) => `expected/${name}`), paths.filter((path) => path.startsWith("expected/")));
let cases = 0;
for (const name of groups) {
  const fixtures = Object.keys(readJson(`fixtures/${name}`)).sort();
  const expected = Object.keys(readJson(`expected/${name}`)).sort();
  assert(fixtures.length > 0, `Expected test cases in ${name}`);
  assert.deepEqual(fixtures, expected, `Test case IDs differ in ${name}`);
  cases += fixtures.length;
}
assert.equal(readJson("capabilities.json").version, manifest.version);

if (process.argv[2]) {
  const lock = JSON.parse(readFileSync(process.argv[2], "utf8"));
  assert.equal(lock.version, manifest.version);
  assert.equal(lock.source, manifest.source);
  assert.match(lock.sourceCommit, /^[0-9a-f]{40}$/);
  assert.equal(lock.manifestSha256, sha256(manifestBytes), "Locked manifest SHA-256 differs");
}

console.log(`${manifest.version} verified (${paths.length} files, ${cases} cases)`);
console.log(`manifest SHA-256 ${sha256(manifestBytes)}`);
