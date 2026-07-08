---
# Task Package —— 任务的唯一事实来源
# 用法：复制本文件，替换所有示例值；人读正文，工具读 frontmatter。
task_id: EX-001                # 任务唯一 ID，建议 <前缀>-<序号> 或 <日期>-<slug>
type: feature                  # 任务类型：feature | bugfix | refactor | docs | research | qa
route: codex                   # 派发路径：cursor | cursor-multitask | codex | codex+reviewer-gate
                               # reviewer 为角色名，默认由 Claude 承担；无 Claude 时按立项书 9.4 映射
                               # （Codex 双会话 / Cursor 审查 / human gate 加重）
risk_level: low                # 风险等级：low | medium | high（涉及 auth/payment/data/deployment 至少 medium）
gate_required: human           # 门禁要求：none | reviewer | human（high 风险必须 human）
isolation: none                # 隔离级别：none | branch | worktree（规则见立项书 9.5）
                               # 强制升级：并行写同一 repo → worktree；high 风险 → 至少 branch（并行时必须 worktree）
# worktree:                    # isolation: worktree 时取消注释并必填
#   branch: task/EX-001        # worktree 分支名，约定 task/<task_id>
#   merge_by: human            # 合并权限：human | coordinator（merge 即 gate）
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

## 隔离

说明 `isolation` 级别的选择依据（对照立项书 9.5 的隔离级别表与强制升级规则）：只读/低风险小改动用 `none`；改动较大需要干净 diff 用 `branch`；并行执行、长耗时后台、高风险重构、方案对比用 `worktree`。
示例：本任务与另一功能并行开发同一 repo，按强制规则取 `worktree`，分支 `task/EX-001`。

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
worktree 任务额外要求：review packet 附 worktree 分支名与 `git diff main...task/<task_id>` 摘要；merge 只能由 `worktree.merge_by` 指定的 gate 方执行，PASS 后清理 worktree。
示例：完成后填写 `templates/review-packet.md` 并提交至 `runs/<日期>-<slug>/`。
