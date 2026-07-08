---
# Task Package —— 任务的唯一事实来源
# 用法：复制本文件，替换所有示例值；人读正文，工具读 frontmatter。
task_id: EX-001                # 任务唯一 ID，建议 <前缀>-<序号> 或 <日期>-<slug>
type: feature                  # 任务类型：feature | bugfix | refactor | docs | research | qa
route: codex                   # 派发路径：cursor | cursor-multitask | codex | claude | codex+claude-gate
risk_level: low                # 风险等级：low | medium | high（涉及 auth/payment/data/deployment 至少 medium）
gate_required: human           # 门禁要求：none | claude | human（high 风险必须 human）
protocol_version: "0.1"        # 协议版本，勿手改；schema 变更时由维护者升级
scope:
  allow:                       # 允许修改的文件/目录（glob），执行方不得越界
    - src/feature-x/**
    - tests/feature-x/**
  deny:                        # 明确禁止触碰的文件/目录，优先级高于 allow
    - src/auth/**
    - .env*
acceptance:                    # 验收标准列表，每条必须可执行、可判定
  - "npm test -- feature-x 全部通过"
  - "页面 /feature-x 可正常渲染（附截图）"
---

# Task Package: <任务标题>

> 以下每节都需填写。写不出"验收"的任务说明还没准备好派发。

## 背景

为什么要做这个任务：问题现状、触发原因、关联 issue/讨论链接。
示例：用户反馈列表页加载超过 3 秒，定位为未分页。

## 目标

用 1-3 句话描述完成后的状态，必须可验证。
示例：列表接口支持分页，首屏加载 < 1 秒。

## 范围

frontmatter `scope` 的人话版：允许改什么、禁止改什么，以及为什么这样划。
示例：只改 `src/feature-x/**`；不得触碰认证模块。

## 非目标

明确本次不做的事，防止执行方顺手扩展。
示例：不重构现有数据层；不升级依赖版本。

## 上下文

执行方需要预先阅读的文件、文档、约定与相关历史决策。
示例：先读 `docs/architecture.md` 第 3 节；数据模型见 `src/models/item.ts`。

## 验收

frontmatter `acceptance` 的展开：每条验收的具体命令、路径、预期输出、截图要求。
示例：`npm test -- feature-x` 退出码 0；截图存入 review packet。

## 风险

已知风险与缓解方式；判断是否需要升级 `risk_level` 与 `gate_required`。
示例：分页改动影响移动端调用方，需同步验证 app 接口契约。

## 交付

要求执行方回传的内容：改动摘要、验证证据、review packet 路径。
示例：完成后填写 `templates/review-packet.md` 并提交至 `runs/<日期>-<slug>/`。
