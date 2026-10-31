# DuskMoon Code Editor 架构设计与状态所有权规范

## 1. 架构总览与核心原则

DuskMoon Code Editor 遵循不可变状态（Immutable State）与单向数据流架构，参考 CodeMirror 6 与 Flutter 原生文本输入系统的优秀实践。

```
┌────────────────────────────────────────────────────────┐
│                   公开封装与视图层                        │
│  DmCodeEditor (duskmoon_widgets) / CodeEditorWidget   │
└──────────────────────────┬─────────────────────────────┘
                           │ 调度与通知
┌──────────────────────────▼─────────────────────────────┐
│                    编辑会话 (Session)                    │
│      管理事务派发、连接生命周期、异步命令与外部调用             │
└──────┬───────────────────┬──────────────────────┬──────┘
       │ 派发事务           │ 状态同步              │ 布局测量
┌──────▼──────┐     ┌──────▼──────┐        ┌──────▼────────┐
│ 事务与文档核 │     │ 平台适配层   │        │ 视口与排版     │
│ Document    │     │ TextInput   │        │ TextPainter   │
│ ChangeSet   │     │ Connection  │        │ Caret/Select  │
│ Selection   │     │ TextEditing │        │ Scroll/Reveal │
│ History     │     │ Value (IME) │        │ Hit-testing   │
└─────────────┘     └─────────────┘        └───────────────┘
```

### 1.1 核心不变量
1. **单一事务入口**：键盘输入、IME 提交、外部 controller API、工具栏动作、剪贴板粘贴与撤销重做全部经过唯一的事务入口（`dispatch`）。
2. **单一排版真实度**：正文文字、光标（Caret）、选区高亮（Selection boxes）、组合输入下划线（Composing underline）与点击命中测试（Hit testing）必须使用同一份精确的 `TextPainter` / `RenderEditable` 排版结果，绝不使用 `fontSize * 0.6` 等估算常量。
3. **内容通知纯粹性**：`onChanged(String text)` **仅在文档内容发生实际变更时**派发一次；光标移动、选区改变、语法高亮完成、光标闪烁、主题切换或父组件重建绝不能触发 `onChanged`。
4. **原子编辑状态**：每次语义修改原子地推进 `Document`、`Selection` 与文档内部 `revision`。
5. **UTF-16 契约与 Grapheme 边界**：文档 offset 保持现有 UTF-16 契约，高亮和 Tree-sitter 沿用 UTF-16 offset；用户级字符导航、删除（Backspace/Delete）与扩选操作严格遵循 Unicode Grapheme Cluster 边界（支持 emoji、代理对、ZWJ 序列和组合字符）。
6. **异步操作文档绑定**：剪贴板粘贴、后台解析与搜索替换均绑定发起时的文档 identity 与内部 revision，防止陈旧结果误写新文档。

---

## 2. 状态所有权与分层职责

| 模块 | 职责 | 持有状态 |
|---|---|---|
| `Document` | 不可变文档树结构（基于 Rope） | `Rope`, `lineCount`, `length` |
| `EditorState` | 不可变编辑状态快照 | `Document`, `EditorSelection`, 扩展字段（如 `HistoryState`, `SyntaxState`） |
| `EditorSession` | 编辑生命周期与会话协调 | 当前 `EditorState`, 活动连接代次 (`connectionGeneration`), 当前 `composing` 范围 |
| `EditorView` / `EditorViewController` | 公开控制器与 API 外壳 | `EditorSession`, 视图配置，监听器列表 |
| 适配器与排版层 | 平台输入对接、滚动与绘制 | 视口滚动偏移、渲染对象、光标闪烁动画 |

---

## 3. 编辑表面选型评估与设计决策

### 3.1 方案评估：`EditableText` 适配 vs 统一自定义排版编辑表面

根据计划要求，针对代码编辑器特性对两种编辑表面进行深度评估：

1. **`EditableText` 适配路线**：
   - *优势*：开箱即用支持平台级 IME 选区、手势（双击、三击、拖选放大镜、长按手柄）、可访问性语义、系统编辑菜单。
   - *代码编辑器挑战*：
     - 行号（Gutter）与代码行必须像素级精确垂直对齐；
     - 水平滚动不能换行（soft wrap 可选，但默认单行横向无限延展）；
     - 语法高亮需要自定义 `TextSpan` 构建，且必须与 IME composing 范围无缝合并（不互相覆盖或打断样式）；
     - Flutter 的 `UndoHistory` 必须与代码引擎的 `History` 统一，不能存在双重撤销栈。
2. **统一精确自定义编辑表面（Custom RenderObject / CustomPaint with exact TextPainter）**：
   - 保证行号、代码块折叠、语法高亮、精准矩形选择、虚拟滚动的完全掌控力。
   - 必须完整实现：精确点击命中、拖拽扩选、双击选词、IME `TextInputClient`、手势冲突解决。

### 3.2 最终决议
采用**统一精确排版架构**：
- 使用统一的文本排版核心（每个逻辑行或整个视口使用实际 `TextPainter` 计算 layout），提供真实 caret metrics、真实 `getBoxesForSelection` 选区矩形、真实 `getPositionForOffset` 命中测试。
- 完整实现 `TextInputClient`：严格维护 `TextEditingValue`（同步 text、selection、composing），保证 IME 状态真实无缝。
- 彻底移除 `charWidth = _kFontSize * 0.6` 估算和 `selectionRects: const []` 空桩。
- 消除两套编辑后端的维护分歧，杜绝“每行一个输入框”或“浮层盲打”反模式。

---

## 4. 输入法（IME）与事务协议

### 4.1 TextEditingValue 双向映射
- **输入法输入流程**：
  1. 平台调用 `updateEditingValue(value)`。
  2. 提取 `value.composing`。若当前处于组合输入阶段（`composing.isValid`），composing 文本属于会话临时状态，在排版中绘制下划线，但不进入历史撤销栈。
  3. 当 composition 提交完成（`composing.isCollapsed` 或非 active），提交单次原子事务，生成单一撤销记录。
- **程序化修改流程**：
  1. 外部调用 `controller.text = ...` 或 `replaceRange(...)`。
  2. 立即派发事务更新文档与选区。
  3. 若此时平台连接活跃，递增连接代次或安全更新 `TextInputConnection.setEditingState`，携带最新 text 与 selection，清空过期的 composing。

---

## 5. 历史协议（Undo / Redo）
- 默认在 `EditorViewController` 中启用 `history()` 扩展。
- 单次中文组词提交 = 1 个撤销单元。
- 连续单字敲击按时间阈值与操作类型（输入、删除、移动光标）进行分组（停顿或光标跳转切分分组）。
- 粘贴、剪切、代码替换、缩进为独立撤销单元。
- 纯光标移动和视觉变化不产生历史记录。
