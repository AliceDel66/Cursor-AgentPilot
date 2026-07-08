---
title: 质量门禁
last_verified: 2026-07-08
sources:
  - docs/00-project-brief.md 第 6.2、9.3、11 节
status: skeleton
---

# 质量门禁：验收、review、human gate

> 本章为 Sprint 1 骨架，正文将在 Sprint 3 补全。目标：用户能用验收标准 + review packet + human gate 完成一次质量闭环。

## 1. 为什么需要 gate

说明 agent 输出不可直接信任的原因，以及 gate 在闭环中的位置。

## 2. 验收标准怎么写

可执行的验收标准：命令、路径、截图、预期输出，写在 task package 里而不是事后补。

## 3. Review Packet 协议

逐字段讲解 review packet 的 frontmatter（`task_id`、`verdict`、`evidence`、`retries`）与正文结构（改动摘要/验证证据/风险发现/gate 建议）。

## 4. Reviewer gate 的用法

把 diff 与 review packet 交给 reviewer 角色（默认 Claude）做独立审查：怎么给上下文、要求什么输出。本节同时覆盖双工具降级模式（无 Claude 时的 Codex 双会话 / Cursor 审查 / human gate 加重，见立项书 9.4）。

## 5. Human Gate

哪些任务必须人工 gate（auth、payment、data、deployment、shared contract），PASS/FAIL 的判定以验收标准和本地验证为准。

## 6. FAIL 之后

FAIL → narrow retry → 重新 review 的循环，以及何时应该放弃自动化改为人工接管。

## 7. 留档

gate 结论如何写入 `runs/`，成为复盘与度量的数据。

## 8. 下一步

指向 `05-cost-and-risk.md`：质量之外的成本与风险控制。
