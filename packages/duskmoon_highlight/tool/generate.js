// Copyright (c) 2026 DuskMoon contributors. MIT licensed.
const path = require('path');
const { execFileSync } = require('child_process');

process.chdir(__dirname);
(async () => {
  await require('./gen_modes').exec();
  require('./gen_styles').exec();
  require('./gen_notices').exec();
  execFileSync(process.env.DART || 'dart', ['format', '../lib'], { stdio: 'inherit' });
})().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
