---
title: 任务派发设计
last_verified: 2026-07-08
sources:
  - docs/00-project-brief.md 第 9 节
status: skeleton
---

# 任务派发设计：Cursor -> Codex / Claude

> 本章为 Sprint 1 骨架，正文将在 Sprint 3 补全。目标：用户能把任务写成 task package，并根据 routing matrix 选对派发路径。

## 1. 派发的核心思想

为什么"先协议后派发"：task package 是任务的唯一事实来源，谁接任务都读同一份上下文。

## 2. 角色分工

Cursor（cockpit）、Codex（executor）、Claude（reviewer/architect）各自最适合与不适合做什么。

## 3. Task Package 协议

逐字段讲解 task package 的 frontmatter schema（`task_id`、`type`、`route`、`scope`、`acceptance`、`risk_level`、`gate_required`、`protocol_version`）与正文结构。

## 4. Routing Matrix

按任务类型给出推荐路径、原因与成本档位，覆盖从"解释怎么用"到"上线前检查"的完整谱系。

## 5. 派发实操流程

从需求 intake 到派发出去的分步操作：澄清 → 拆解 → 写包 → 选路由 → 派发。

## 6. 并行派发的边界

什么任务可以 Multitask 并行、什么必须串行，如何避免多 Agent 改同一文件。

## 7. 失败与重试

FAIL 之后如何收窄任务（narrow retry）重新派发，而不是原样重跑。

## 8. 下一步

指向 `04-quality-gate.md`：派发出去的任务如何验收。
