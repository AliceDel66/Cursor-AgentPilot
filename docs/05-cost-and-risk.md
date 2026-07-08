---
title: 成本与风险控制
last_verified: 2026-07-08
sources:
  - docs/00-project-brief.md 第 9.2、12 节
status: skeleton
---

# 成本与风险控制

> 本章为 Sprint 1 骨架，正文将在 Sprint 3 补全。目标：用户在多 Agent 协作时能预估成本档位并规避常见风险。

## 1. 多 Agent 的成本模型

token、时间、返工三类成本，以及并行如何放大它们。

## 2. 按路径的成本档位

对照 routing matrix 的低/中/高成本标注，解释每档的典型开销与省钱手段。

## 3. 范围控制

用 `scope.allow` / `scope.deny` 限制修改面，防止 Agent 越界改动造成隐性成本。

## 4. 并行冲突风险

多 Agent 改同一文件/核心链路的冲突场景与预防（串行、worktree 隔离）。

## 5. 上下文与敏感信息

task package 不写 secrets、review packet 不贴敏感 token 的具体做法。

## 6. 输出不一致与回滚

Claude / Codex 结论冲突时以本地验证为准；保留 rollback 路径的操作习惯。

## 7. 风险速查表

风险 → 控制方式的一张总表，供派发前快速自查。
