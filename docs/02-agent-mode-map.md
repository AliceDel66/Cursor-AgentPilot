---
title: Agent 模式地图
last_verified: 2026-07-08
sources:
  - https://cursor.com/docs
  - https://cursor.com/changelog/04-24-26
  - https://forum.cursor.com/t/multitask-in-agents-window/158955
status: skeleton
---

# Agent 模式地图：Chat / Agent / Plan / Multitask / Worktree

> 本章为 Sprint 1 骨架，正文将在 Sprint 2 补全。目标：用户面对任何任务，能在 30 秒内判断该用哪种模式。

## 1. 为什么需要模式地图

说明模式选错的代价：范围失控、上下文丢失、并行冲突。

## 2. Chat：交互式问答

Chat 适合的场景（解释、学习、快速咨询）与不适合的场景。

## 3. Agent：单任务自主执行

Agent 模式的能力边界、适合的任务粒度、如何控制修改范围。

## 4. Plan：先规划后执行

Plan 模式的触发时机：大任务、多方案、需求不清时先出计划再动手。

## 5. Multitask：并行子任务

`/multitask` 与 async subagents 的适用条件：多个互不依赖的调研/小任务；以及禁止并行的场景（同文件、核心链路）。

## 6. Worktree：后台分支任务

Worktrees / multi-root workspaces 如何承载后台分支和跨仓库任务。本节将结合派发协议的 `isolation` 隔离级别（none / branch / worktree，见立项书 9.5）说明何时必须用 worktree：并行写任务、长耗时后台任务、高风险重构与方案对比。

## 7. 模式选择速查表

一张决策表：任务特征 → 推荐模式 → 原因，配典型例子。

## 8. 下一步

指向 `03-dispatch-design.md`：当任务超出 Cursor 单模式能力时，如何派发给 executor / reviewer（默认 Codex / Claude）。
