---
title: Refactor Flow
last_verified: 2026-07-08
sources:
  - docs/00-project-brief.md 第 8.2 节
status: skeleton
suited_route: "Codex implementation + reviewer gate（行为不变是硬验收）"
isolation: worktree
---

# 案例：重构流程（refactor-flow）

> 场景：对一个模块做结构性重构，要求行为完全不变。适用路径：Codex 执行 + reviewer gate（默认 Claude，双工具模式见立项书 9.4），测试基线是硬验收；禁止与其他任务并行改同一链路。高风险重构在独立 worktree 执行、merge 即 gate（见立项书 9.5）。骨架，Sprint 4 补全。

## 1. 场景与输入 prompt

重构动机（可维护性/性能/解耦）与目标模块。

## 2. 基线建立

重构前的测试基线与行为快照如何固定。

## 3. Task package

重构任务的 scope 划分与"行为不变"的验收写法。

## 4. 执行与验证

分步重构记录与每步的测试结果。

## 5. Review 与 gate

Reviewer 对结构变化的审查与 gate 结论。

## 6. 复盘

重构任务粒度控制与回滚经验。
