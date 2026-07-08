---
# Cursor Prompt Snippets —— 常用 prompt 片段库
# 用法：按场景复制片段，替换 <> 占位符；可自由组合。
snippet_count: 6
protocol_version: "0.1"
last_verified: 2026-07-08
---

# Cursor Prompt Snippets

> 每个片段给出适用场景与模板，`<>` 内为需替换的占位符。核心原则：给上下文、给范围、给验收标准。

## 1. 需求澄清（intake）

适用：需求模糊时，先让 Cursor 帮你把任务问清楚，而不是直接开工。

```text
我想做：<一句话需求>。
在动手之前，请先列出你需要澄清的问题（范围、边界、验收），不要写任何代码。
```

## 2. 小范围修改

适用：明确的小改动，限定文件范围防止越界。

```text
只修改 <文件路径>，实现：<具体改动>。
不要改动其他任何文件。完成后说明改了什么、如何验证。
```

## 3. Bug 定位（先 trace 后修改）

适用：修 bug 时强制先分析根因，避免瞎改。

```text
现象：<报错信息/异常行为>。复现方式：<步骤>。
请先定位根因并解释，得到我确认后再修改。先 trace，后修改。
```

## 4. 生成 task package

适用：任务需要派发给 executor / reviewer（默认 Codex / Claude，双工具模式见立项书 9.4）时，让 Cursor 按协议模板产出任务包。

```text
把下面的需求整理成 task package，使用 templates/task-package.md 的结构，
frontmatter 字段填全（task_id、type、route、scope、acceptance、risk_level、gate_required）：
<需求描述>
```

## 5. Plan 模式拆解大任务

适用：大功能先规划再执行。

```text
用 Plan 模式拆解这个需求：<需求>。
输出：步骤列表、每步的文件范围、依赖关系、每步的验收方式。先不要实现。
```

## 6. Review 派发

适用：把 diff 交给 reviewer 角色做独立审查（审查会话不得复用执行会话的上下文）。

```text
请 review 以下改动（对应任务包 <task_id>）：
关注点：正确性、范围是否越界（scope.deny：<列表>）、遗漏的验收项、安全风险。
输出按 templates/review-packet.md 的结构给出结论（PASS/FAIL）与证据。
```
