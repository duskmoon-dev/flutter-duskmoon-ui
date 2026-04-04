#!/usr/bin/env node
/**
 * Compiles a Lezer .grammar file to a JSON intermediate format.
 * Usage: node compile_grammar.mjs <input.grammar> [output.json]
 */

import { buildParser } from "@lezer/generator";
import { readFileSync, writeFileSync } from "fs";
import { basename } from "path";

const args = process.argv.slice(2);
if (args.length < 1) {
  console.error("Usage: node compile_grammar.mjs <input.grammar> [output.json]");
  process.exit(1);
}

const inputFile = args[0];
const outputFile = args[1] || inputFile.replace(/\.grammar$/, ".json");
const grammarSource = readFileSync(inputFile, "utf-8");

try {
  const parser = buildParser(grammarSource);
  const serialized = {
    nodeNames: parser.nodeSet.types.map(t => t.name),
    states: Array.from(parser.states),
    stateData: Array.from(parser.stateData),
    goto: Array.from(parser.goto),
    tokenData: Array.from(parser.tokenData),
    topRuleIndex: parser.topNode
      ? parser.nodeSet.types.findIndex(t => t.name === parser.topNode.name)
      : 0,
    skippedNodes: parser.nodeSet.types
      .filter(t => t.isSkipped)
      .map(t => t.id),
    tokenPrec: parser.tokenPrec || 0,
    nodeProps: {},
  };

  for (let i = 0; i < parser.nodeSet.types.length; i++) {
    const type = parser.nodeSet.types[i];
    const props = {};
    if (type.isTop) props.top = true;
    if (type.isError) props.error = true;
    if (type.isSkipped) props.skipped = true;
    if (Object.keys(props).length > 0) serialized.nodeProps[i] = props;
  }

  writeFileSync(outputFile, JSON.stringify(serialized, null, 2));
  console.log(`Compiled ${basename(inputFile)} → ${basename(outputFile)}`);
  console.log(`  ${serialized.nodeNames.length} node types`);
  console.log(`  ${serialized.states.length} state entries`);
} catch (err) {
  console.error(`Error compiling ${inputFile}:`, err.message);
  process.exit(1);
}
