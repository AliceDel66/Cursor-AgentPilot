---
title: Changelog Watch
last_verified: 2026-07-08
sources:
  - https://cursor.com/changelog
  - https://cursor.com/changelog/04-24-26
status: active
---

# Changelog Watch：Cursor 更新对手册的影响追踪

> 追踪 Cursor changelog 对本手册的影响面，标注"哪个功能更新影响哪一章"。承诺：每个 Cursor 大版本发布后 7 天内核验受影响章节。

## 1. 核验机制说明

- **录入**：Cursor 发布 changelog 后，在下方影响追踪表新增一行，标注变更点、来源链接与受影响章节，状态置为"待核验"。
- **核验**：对照实际产品行为逐节检查受影响章节，必要时修订内容。
- **收口**：核验完成后更新该行状态为"已核验（YYYY-MM-DD）"，并同步更新受影响章节 frontmatter 的 `last_verified` 日期。

## 2. 影响追踪表

| 日期 | Cursor 变更 | 来源 | 受影响章节 | 核验状态 |
| --- | --- | --- | --- | --- |
| 2026-04-24 | Multitask（`/multitask` 并行 async subagents）、Worktrees、Multi-root Workspaces | [changelog/04-24-26](https://cursor.com/changelog/04-24-26) | docs/01 第 3 节（Agent Window）；docs/02 第 5、6、7 节（Multitask/Worktree/Multi-root 全部依赖此版本能力） | 已核验（2026-07-08，随 Sprint 2 正文撰写完成） |

## 3. 待核验队列

当前无待核验条目。新条目按第 1 节机制录入。
