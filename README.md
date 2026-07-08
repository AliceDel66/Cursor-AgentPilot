# Cursor AgentPilot（光标驾驶舱）

从 Cursor 新手入门，到把任务稳定派发给 Codex / Claude 的实战工作流手册，并沉淀为一套可被工具消费的派发协议。

**一句话：别让 Agent 替你猜任务。先把任务变成协议，再把协议派给合适的 Agent。**

## 这是什么

Cursor 已经从代码编辑器演进为 agentic coding 工作台，但新手的真实痛点不是"不会点按钮"，而是：

- 不知道什么时候用 Chat、Agent、Plan、Multitask、Worktree。
- 不知道怎么描述任务，导致 Agent 改错范围或漏验收标准。
- 不知道 Cursor、Codex、Claude 各自适合承担什么角色。
- 多工具协作时，任务上下文、验收标准、review 结论容易丢。

本项目是 **工作流手册 + 派发协议**，不是官方文档翻译，也不是泛 AI 工具测评。协议按 **角色** 设计，不绑定具体工具：

- **Coordinator（cockpit）**：输入、理解、拆解、协调、轻量执行。默认由 Cursor 承担。
- **Executor**：本地 repo 修改、跑测试、验证、交付总结。默认由 Codex 承担。
- **Reviewer / Architect**：方案评审、代码 review、风险发现、gate 判断。默认由 Claude 承担；没有 Claude 也能用（见立项书 9.4 双工具降级模式）。
- **Markdown task package 是跨工具交接协议**：谁接任务都先读同一份上下文。

## 适合谁

- 刚开始用 Cursor 的开发者。
- 想从"让 AI 写代码"升级到"用 AI 管理开发流程"的独立开发者。
- 只有 Cursor + Codex 的双工具用户（走立项书 9.4 降级模式，工作流完整可用）。
- 同时使用 Cursor + Codex + Claude 的多模型用户。
- 需要为团队定义 agentic coding 规范的技术负责人。
- 需要把需求、开发、review、验收串起来的产品型开发者。

## 5 分钟快速开始

1. **读定位**：花 1 分钟读完本 README 的"这是什么"，确认你的场景匹配。
2. **挑一个真实小任务**：比如"修一个已知 bug"或"加一个小函数"，不要从大重构开始。
3. **复制模板**：把 `templates/task-package.md` 复制一份，按字段说明填写背景、目标、范围（allow/deny）、验收标准。
4. **选路径派发**：对照 `docs/03-dispatch-design.md` 的 routing matrix（骨架期可先看 `docs/00-project-brief.md` 第 9.2 节），判断这个任务该交给 Cursor 直接改、Codex 执行，还是需要 reviewer 审查（默认 Claude，双工具模式见立项书 9.4）。
5. **验收与留档**：执行完成后对照验收标准逐条检查；如果走了 executor / reviewer 派发，用 `templates/review-packet.md` 汇总证据，由你做最终 human gate。

跑完一次闭环，你就理解了本项目的全部核心概念：task package → routing → 执行 → review → gate。

## 新手路径

按顺序阅读，每一步都有明确产出：

| 步骤 | 阅读 | 你将学会 |
| --- | --- | --- |
| 1 | `docs/01-cursor-beginner-guide.md` | Cursor 基础界面与核心能力，完成第一次 AI 辅助修改 |
| 2 | `docs/02-agent-mode-map.md` | Chat / Agent / Plan / Multitask / Worktree 各自的使用边界 |
| 3 | `docs/03-dispatch-design.md` | 把任务拆成 task package，派发给 executor / reviewer |
| 4 | `docs/04-quality-gate.md` | 用验收标准、review、human gate 控制质量 |
| 5 | `docs/05-cost-and-risk.md` | 控制多 Agent 协作的成本与风险 |
| 6 | `examples/` 任意案例 | 端到端复制一次完整派发闭环 |

## 目录导航

```text
cursor-agentpilot/
  README.md                        # 本文件：定位、快速开始、导航
  docs/
    00-project-brief.md            # 立项书：架构、护城河、协议规范（已定稿）
    01-cursor-beginner-guide.md    # Cursor 新手手册
    02-agent-mode-map.md           # Chat/Agent/Plan/Multitask/Worktree 使用边界
    03-dispatch-design.md          # coordinator -> executor/reviewer 任务派发设计
    04-quality-gate.md             # 验收、review、human gate
    05-cost-and-risk.md            # 成本与风险控制
    changelog-watch.md             # Cursor 更新对手册的影响追踪
  templates/
    task-package.md                # 任务包模板（任务的唯一事实来源）
    review-packet.md               # 审查包模板（执行证据与审查结论）
    acceptance-checklist.md        # 验收清单模板
    cursor-prompt-snippets.md      # Cursor 常用 prompt 片段
  examples/
    feature-flow.md                # 功能开发端到端案例
    bug-hunt-flow.md               # bug 排查修复案例
    ui-polish-flow.md              # UI 打磨案例
    refactor-flow.md               # 重构案例
    docs-flow.md                   # 文档任务案例
  runs/                            # 真实派发留档（P2 起启用）
  plans/
    plan.md                        # 开发计划与任务拆解
```

## 项目状态

当前处于 Sprint 1（文档骨架）阶段：README 与模板可用，`docs/01~05` 与 `examples/` 为章节骨架，正文将在 Sprint 2-4 补全。每篇文档头部的 `last_verified` 标注最近核验日期，`docs/changelog-watch.md` 追踪 Cursor 更新对手册的影响。
