---
title: 30 秒上手
last_verified: 2026-07-08
status: complete
---

# 30 秒上手

不读手册，三步发出你的第一个合规派发。

## 三步用法

1. **复制**下面的最小任务包，存为你项目里的一个文件（如 `task-fix-login.md`），
2. **填写** 5 个必填项：`task_id`、`type`、`route`、`scope.allow/deny`、`acceptance`，
3. **粘贴**派发话术给你的 Agent（Cursor Agent / Codex 均可）。

## 最小任务包示例

以下是一份真实填好值的 bugfix 示例，改成你的任务即可：

```yaml
---
task_id: FIX-001
type: bugfix                 # feature | bugfix | refactor | docs | research | qa
route: codex                 # cursor | cursor-multitask | codex | codex+reviewer-gate
scope:
  allow:
    - src/pages/login/**
    - tests/login/**
  deny:
    - src/auth/**
    - .env*
acceptance:
  - "npm test -- login 全部通过，退出码 0"
  - "快速点击登录按钮 5 次，Network 面板只出现 1 个 POST 请求（附截图）"
---
```

```markdown
## 目标

修复：连续点击登录按钮会重复提交表单。

## 上下文

登录页组件在 src/pages/login/LoginForm.tsx；测试命令 npm test -- login。

## 非目标

不重构登录页其他逻辑；不改认证模块。
```

省略的字段按默认值生效（与 [`templates/task-package.md`](templates/task-package.md) 语义一致）：
`risk_level: low`、`gate_required: human`、`isolation: none`、`protocol_version: "0.1"`。
任务涉及 auth/payment/data/deployment 或需要并行时，默认值不够用——请转完整模板。

## 派发话术（直接粘贴）

```text
请按 task-fix-login.md 的任务包执行：
只修改 scope.allow 内的文件，不得触碰 scope.deny；
完成后逐条回报 acceptance 的执行结果（贴命令原始输出，不要只说"已完成"）。
```

## 验收话术（人工 gate）

```text
逐条对照任务包 acceptance 检查回报的证据；
亲自跑其中至少一条验收命令抽查（如 npm test -- login）；
用 git diff --stat 确认没有 scope 之外的文件被改动。
通过才算完成；不通过就指出失败点，让 Agent 只修这一点。
```

## 想更进一步

- 系统学习：README 的[新手路径](README.md#%EF%B8%8F-新手路径)（5 章手册循序渐进）。
- 完整协议：[`docs/03-dispatch-design.md`](docs/03-dispatch-design.md)——全量字段、routing matrix、隔离与 worktree、失败重试。
- 全量模板：[`templates/task-package.md`](templates/task-package.md)（CC0，直接复制进私有项目）。
- 一键挂载：README 的[挂载到你的项目](README.md#-挂载到你的项目)——install.sh 或 skill 安装，装完对 Agent 只说需求即可。
