// Copyright (c) 2026 DuskMoon contributors. MIT licensed.
const fs = require('fs');
const path = require('path');

function files(directory) {
  return fs.readdirSync(directory).sort().flatMap(name => {
    const file = path.join(directory, name);
    return fs.statSync(file).isDirectory() ? files(file) : [file];
  });
}

exports.exec = function() {
  const sourceRoot = '../vendor/highlight.js/src';
  const notices = files(sourceRoot).filter(file => /\.(css|js)$/.test(file))
    .flatMap(file => {
      const comments = fs.readFileSync(file, 'utf8').match(/\/\*[\s\S]*?\*\//g) || [];
      const retained = comments
        .filter(comment => /author|license|copyright|©|permission|Language:|theme|style/i.test(comment))
        .map(comment => comment.split('\n').map(line => line.trimEnd()).join('\n'));
      return retained.length ? [`${path.relative('..', file)}\n${retained.join('\n')}`] : [];
    });
  fs.writeFileSync('../THIRD_PARTY_NOTICES',
    'Original grammar and theme notices retained from highlight.js 11.9.0.\n' +
    'Component licenses: THIRD_PARTY_LICENSES. Theme-specific licenses apply as stated below.\n' +
    'Kimbie and NNFX themes retain CC BY-SA 4.0; full terms: CC-BY-SA-4.0.txt.\n\n' +
    notices.join('\n\n'));
};
