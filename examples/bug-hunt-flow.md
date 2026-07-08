---
title: Bug Hunt Flow
last_verified: 2026-07-08
sources:
  - docs/00-project-brief.md 第 8.2 节
status: skeleton
suited_route: "Codex（trace + 修复 + 测试）-> Claude review"
---

# 案例：Bug 排查修复流程（bug-hunt-flow）

> 场景：线上/本地出现一个可复现的 bug，需要定位根因、修复并验证。适用路径：Codex 执行 trace 与修复，Claude review gate。本案例计划包含真实 FAIL → narrow retry → PASS 记录。骨架，Sprint 4 补全。

## 1. 场景与输入 prompt

bug 现象、复现步骤与用户的初始 prompt。

## 2. 先 trace 后修改

根因定位过程：如何要求 agent 先给出分析再动手。

## 3. Task package 与派发

修复任务的任务包与派发给 Codex 的记录。

## 4. FAIL 与 narrow retry

第一次验收失败的证据、收窄后的 retry 任务包、第二次结果。

## 5. Review 与 gate

Claude review 结论与最终 human gate 判定。

## 6. 复盘

根因分类、重试成本、防复发措施。
