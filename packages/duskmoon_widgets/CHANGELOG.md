## Unreleased

- Support touch drag selection in the chat navigation rail: highlight on press
  and move, then jump once on release, with cancellation and a larger hit area.
- Reveal overflowed markers while holding near an edge, preserving mouse,
  keyboard, accessibility and existing selected-turn behavior.

## 2.2.1

- Allow `DmChatView(showInput: false)` to omit its built-in composer while
  preserving message navigation, pinned scrolling and unread indicators.

## 2.2.0

- Add a compact, centered navigation rail with one tick per user message in
  `DmChatView`, enabled by default and optional with `showMessageNavigation`.
- Jump to lazy, offscreen messages by click or keyboard and preview static
  prompt/reply text on hover or focus. Adapt tick spacing to long conversations.
- Preserve chronological order and pinned/unread behavior with both scroll
  directions and in-place message appends.

## 2.1.1

- Release 2.1.1 (2026-10-19)

## 2.1.0

- Use shared Tree-sitter parsing for Markdown fenced code and the code editor.
- Automatically load bundled browser grammars, cache per-block syntax and retain
  exact source text, copy behavior, theme updates and plain-text fallbacks.
- Resolve TypeScript and C++ to their distinct editor grammars.

## 2.0.0

- Own the native math renderer and KaTeX fonts, render inline formulas, and
  update cached glyphs when text scaling changes.
- Backport three official Markdown parser fixes while retaining hosted AST types.
- Support custom inline builders returning TextSpan or WidgetSpan with the themed
  render context.
- Align declared Dart and Flutter SDK requirements with package dependencies.

## 1.12.0

- Replace the Markdown syntax highlighter with the maintained `duskmoon_highlight`
  workspace package, preserving 194 languages, aliases, and light/dark styles.

## 1.11.1

- Release 1.11.1 (2026-10-09)

## 1.11.0

- Add opt-in sidebar hide/restore controls and `DmAppBar` integration that
  composes restore beside existing leading controls in the same toolbar row.
- Support nested AppBar and SliverAppBar headers through `DmNavigationHeader`,
  preserving body state and safe-area layout.
- Preserve icon-button tooltips and accessible names in Cupertino and Fluent
  styles, including disabled controls.

## 1.10.1

- Release 1.10.1 (2026-10-09)

## 1.10.0

- Release 1.10.0 (2026-10-07)

## 1.9.2

- Release 1.9.2 (2026-10-07)

## 1.9.1

- Release 1.9.1 (2026-10-06)

## 1.9.0

- Release 1.9.0 (2026-10-05)

## 1.8.0

- Release 1.8.0 (2026-07-17)

## 1.7.1

- Release 1.7.1 (2026-07-08)

## 1.7.0

- Release 1.7.0 (2026-06-29)

## 1.6.2

- Release 1.6.2 (2026-06-18)

## 1.6.1

- Release 1.6.1 (2026-06-16)

## 1.6.0

- Release 1.6.0 (2026-04-28)

## 1.5.0

- Release 1.5.0 (2026-04-13)

## 1.4.4

- Release 1.4.4 (2026-04-13)

## 1.4.3

- Release 1.4.3 (2026-04-12)

## 1.4.2

- Release 1.4.2 (2026-04-11)

## 1.4.1

- Release 1.4.1 (2026-04-10)

## 1.4.0

- Release 1.4.0 (2026-04-08)

## 1.3.0

- Release 1.3.0 (2026-04-08)

## 1.2.3

- Release 1.2.3 (2026-04-07)

## 1.2.2

- Release 1.2.2 (2026-04-07)

## 1.2.1

- Release 1.2.1 (2026-04-07)

## 1.0.0

- First stable release

## 0.1.0

- Initial release
- 18 adaptive widgets with Material/Cupertino platform rendering
- `AdaptiveWidget` mixin and `DmPlatformOverride` infrastructure
- Scaffold: `DmScaffold`, `DmActionList`
- Buttons: `DmButton`, `DmIconButton`, `DmFab`
- Inputs: `DmTextField`, `DmCheckbox`, `DmSwitch`, `DmSlider`
- Layout: `DmCard`, `DmDivider`
- Navigation: `DmAppBar`, `DmBottomNav`, `DmTabBar`, `DmDrawer`
- Data Display: `DmBadge`, `DmChip`, `DmAvatar`
