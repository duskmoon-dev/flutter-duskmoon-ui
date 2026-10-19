# Bundled Tree-sitter grammars

The runtime ships 95 grammars. Names and aliases are case insensitive.
All names in this table use the same pinned grammar on native and web.
Markdown inline is a separate grammar; embedded-language injection is not
automatically orchestrated. Generic editor support has no additional
language-specific editing metadata.

| Grammar | Aliases and file extensions |
| --- | --- |
| `abnf` |  |
| `actionscript` | `as` |
| `ada` | `adb`, `ads` |
| `applescript` | `osascript`, `scpt` |
| `arduino` | `ino` |
| `asciidoc` | `adoc` |
| `awk` |  |
| `bash` | `sh`, `shell`, `zsh` |
| `batch` | `bat`, `cmd`, `dos` |
| `c` | `h` |
| `clojure` | `clj`, `cljc`, `cljs`, `edn` |
| `cmake` | `cmake.in` |
| `commonlisp` | `cl`, `lisp` |
| `cpp` | `c++`, `cc`, `cxx`, `h++`, `hh`, `hpp`, `hxx` |
| `crystal` | `cr` |
| `csharp` | `c#`, `cs` |
| `css` |  |
| `d` |  |
| `dart` |  |
| `diff` | `patch` |
| `dockerfile` | `docker` |
| `ebnf` |  |
| `elixir` | `ex`, `exs` |
| `elm` |  |
| `erlang` | `erl`, `hrl` |
| `fortran` | `f`, `f03`, `f08`, `f90`, `f95` |
| `fsharp` | `f#`, `fs`, `fsx` |
| `gcode` | `cnc`, `gco`, `nc`, `ngc`, `tap` |
| `gherkin` | `feature` |
| `glsl` |  |
| `gn` | `gni` |
| `go` | `golang` |
| `graphql` | `gql` |
| `haml` |  |
| `haskell` | `hs` |
| `haxe` | `hx` |
| `html` | `htm` |
| `http` | `https` |
| `ini` | `cfg`, `toml` |
| `java` | `jsp` |
| `javascript` | `cjs`, `javascriptreact`, `js`, `jsx`, `mjs` |
| `json` | `json5`, `jsonc` |
| `julia` | `jl` |
| `kotlin` | `kt`, `ktm`, `kts`, `ktx` |
| `latex` | `tex` |
| `less` |  |
| `lua` | `pluto` |
| `make` | `mak`, `makefile`, `mk` |
| `markdown` | `md`, `mkd`, `mkdown` |
| `markdown_inline` |  |
| `matlab` |  |
| `nginx` | `conf`, `nginxconf` |
| `nim` | `nims` |
| `nix` | `nixos` |
| `objc` | `m`, `mm`, `obj-c`, `obj-c++`, `objective-c++`, `objectivec` |
| `ocaml` |  |
| `openscad` | `scad` |
| `perl` | `pl`, `pm` |
| `php` |  |
| `pony` |  |
| `powershell` | `ps`, `ps1`, `psd1`, `psm1`, `pwsh` |
| `prolog` | `pro` |
| `properties` |  |
| `proto` | `protobuf` |
| `puppet` | `pp` |
| `python` | `gyp`, `ipython`, `py`, `pyi`, `pyw` |
| `qmljs` | `qml`, `qt` |
| `r` |  |
| `reason` | `re`, `reasonml`, `rei` |
| `ruby` | `gemspec`, `irb`, `podspec`, `rb`, `thor` |
| `rust` | `rs` |
| `sas` |  |
| `scala` |  |
| `scheme` | `scm` |
| `scss` |  |
| `smali` |  |
| `smalltalk` | `st` |
| `sml` | `fun`, `ml`, `sig` |
| `sql` |  |
| `stan` | `stanfuncs` |
| `swift` |  |
| `tcl` | `tk` |
| `thrift` |  |
| `tsx` | `typescriptreact` |
| `twig` | `craftcms` |
| `typescript` | `cts`, `mts`, `ts` |
| `vala` | `vapi` |
| `verilog` | `sv`, `svh`, `v` |
| `vhdl` | `vhd` |
| `vue` |  |
| `wat` | `wasm` |
| `xml` | `atom`, `plist`, `rss`, `svg`, `wsf`, `xhtml`, `xjb`, `xsd`, `xsl`, `xslt` |
| `xquery` | `xpath`, `xq`, `xqm`, `xqy` |
| `yaml` | `yml` |
| `zig` |  |

## Coverage changes

The previous Highlight.js registry advertised 195 languages. Only supported
Tree-sitter equivalents are registered here. These previous names have no
bundled equivalent and render as plain text:

`1c`, `accesslog`, `angelscript`, `apache`, `arcade`, `armasm`, `aspectj`, `autohotkey`, `autoit`, `avrasm`, `axapta`, `basic`, `bnf`, `brainfuck`, `cal`, `capnproto`, `ceylon`, `clean`, `clojure-repl`, `coffeescript`, `coq`, `cos`, `crmsh`, `csp`, `delphi`, `django`, `dns`, `dsconfig`, `dts`, `dust`, `erb`, `erlang-repl`, `excel`, `fix`, `flix`, `freedesktop`, `gams`, `gauss`, `gml`, `golo`, `gradle`, `groovy`, `handlebars`, `hsp`, `hy`, `inform7`, `irpf90`, `isbl`, `jboss-cli`, `julia-repl`, `lasso`, `ldif`, `leaf`, `livecodeserver`, `livescript`, `llvm`, `lsl`, `mathematica`, `maxima`, `mel`, `mercury`, `mipsasm`, `mizar`, `mojolicious`, `monkey`, `moonscript`, `n1ql`, `nestedtext`, `node-repl`, `nsis`, `oxygene`, `parser3`, `pf`, `pgsql`, `php-template`, `plaintext`, `processing`, `profile`, `purebasic`, `python-repl`, `q`, `rib`, `roboconf`, `routeros`, `rsl`, `ruleslanguage`, `scilab`, `sqf`, `stata`, `step21`, `stylus`, `subunit`, `taggerscript`, `tp`, `vbnet`, `vbscript`, `vbscript-html`, `vim`, `wren`, `x86asm`, `xl`, `zephir`.

LLVM, Vim and x86asm are excluded because their generated lexers caused
pathological LLVM Wasm compilation and fatal V8 compiler memory exhaustion.
Groovy was not included because its selected source had no license grant.
The selected PostgreSQL-specific source had an unresolved Git LFS parser
pointer; general SQL remains supported by the `sql` grammar.

See `grammars.json` for source revisions, archive/source/asset hashes, query
provenance and explicit exclusions. Unknown names also render as plain text.
