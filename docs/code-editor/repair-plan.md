# DuskMoon Code Editor 修复计划与跟踪

## 项目信息
- **仓库**: duskmoon-dev/flutter-duskmoon-ui
- **基线版本**: main @ commit 8eb9bc7a734f60f325853bbdca94b28d8a469e47 (v2.2.8)
- **环境**: macOS 26.3.1 (Darwin 25.3.0), Apple Silicon, Flutter 3.47.8 (channel stable), Dart 3.13.7

## 阶段划分与状态

| 阶段 | 内容 | 状态 | 交付物 |
|---|---|---|---|
| **阶段 0** | 固定失败场景和公开契约 | 已完成 | R01–R10 问题清单、失败场景测试、基线性能记录、基线测试宿主 |
| **阶段 1** | 建立编辑会话和变更通知 | 已完成 | `EditorSession` / 适配层、统一事务入口、`onChanged` 准确单次触发 |
| **阶段 2** | 修复输入法、异步编辑、历史和 Unicode | 已完成 | IME composing 状态完整保留、平台同步防丢、Grapheme 边界、默认撤销重做 |
| **阶段 3** | 完成文本布局、选区和视口 | 已完成 | 真实点选计算、精确选区矩形、双向滚动视口、`scrollIntoView` |
| **阶段 4** | 修复命令、搜索和公开封装 | 已完成 | 修饰键匹配、搜索 revision 绑定、原子替换、公开组件封装统一 |
| **阶段 5** | 修复文档与绘制性能 | 已完成 | Rope 局部增量应用、结构共享、缓存管理、光标局部绘制 |
| **阶段 6** | 集成验收和发布准备 | 已完成 | 全 workspace 检查、跨平台验证报告、Agent Note、文档与 Changelog |

## R01–R10 缺陷定义与当前追踪

| 编号 | 核心缺陷 | 根因位置 | 预期行为 | 回归测试用例 |
|---|---|---|---|---|
| **R01** | 点击忽略 x 和滚动偏移，列固定为 0 | `code_editor_widget.dart` `_handleTapDown` (`dy` 仅估算行且 `col` 固定传 0) | 点击对应真实文档 offset，考虑 x 坐标与滚动偏移 | `tap positions cursor with exact offset` |
| **R02** | 选区矩形为空，选区不可见，触摸和鼠标选择不完整 | `code_editor_widget.dart` `selectionRects: const []` | 可见选区与逻辑选区一致，绘制实际选区矩形 | `selection rects computed and drawn for multi-char selection` |
| **R03** | 光标宽度估算，长行不可访问，未消费 reveal 请求 | `code_editor_widget.dart` `charWidth = _kFontSize * 0.6`，无水平滚动与 reveal 管道 | 光标与文字共用真实排版，支持长行水平滚动与光标 reveal | `long lines accessible with horizontal scroll and reveal` |
| **R04** | Shift 修饰键匹配到普通命令，Shift 命令无法执行 | `keymap.dart` `matches` 逻辑缺陷，`code_editor_widget.dart` 仅执行 `binding.run` 忽略 `shift` | 修饰键严格匹配，Shift+箭头扩选、Ctrl/Cmd+Shift+Z 重做正确执行 | `shift modifier exact match and redo execution` |
| **R05** | composing 未保留，普通字符经 raw key 直接插入导致重复或丢失 | `code_editor_widget.dart` `_handleKeyEvent` 插入字符，`input_handler.dart` 丢弃 `composing` | IME 完整保留 composing，普通文字走平台输入法管道 | `composing text preserved and no duplicate raw key insertion` |
| **R06** | 异步粘贴及 controller 更新后平台状态不同步，后续输入覆盖文本 | `clipboard.dart` `pasteCommand` 异步返回且未同步 IME，生命周期未校验 | 异步粘贴后同步平台编辑状态，后续输入在粘贴内容之后追加 | `async paste synchronizes platform state preventing overwrite` |
| **R07** | 字符移动和删除按一个 UTF-16 单元处理，破坏 emoji 和复合字符 | `commands.dart` `deleteCharBackward/Forward` 硬编码 `head - 1` | 遵循 Unicode Grapheme Cluster 边界，不损坏代理对和复合表情 | `delete and move respect grapheme cluster boundaries` |
| **R08** | 默认公开编辑器没有历史，搜索结果 offsets 会过期 | `editor_view_controller.dart` 默认 extensions 为空，`search_panel.dart` 未绑定 revision | 默认启用撤销重做；搜索替换绑定当前文档 revision 原子替换 | `default controller supports undo/redo and search revalidates` |
| **R09** | `onChanged` 混入选区和视觉通知，父组件重建引发反馈循环 | `dm_code_editor.dart` `_handleStateChanged` 每次状态变化均触发 `onChanged` | 仅当文档内容真正变化时单次触发 `onChanged` | `onChanged fires only on document content change` |
| **R10** | 修改重建全文 Rope，光标闪烁触发全文重构 | `change.dart` `apply` 全量 `StringBuffer` + `Rope.fromString` | Rope 局部切分拼接并结构共享，光标闪烁只触发局部 repaint | `rope local split splice and cursor blink repaint isolated` |
