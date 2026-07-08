---
title: 任务派发设计
last_verified: 2026-07-08
sources:
  - docs/00-project-brief.md 第 5、9 节
  - templates/task-package.md
  - https://cursor.com/changelog/04-24-26
status: complete
---

# 任务派发设计：coordinator -> executor / reviewer

> 目标：读完本章你能独立写出一份合格的 task package，为它选对派发路径与隔离级别，并把任务稳定地交出去。核心思想一句话：**先协议，后派发**——task package 是任务的唯一事实来源，谁接任务都读同一份上下文。

## 1. 派发的核心思想

跨工具协作最常见的失败不是"AI 能力不够"，而是**上下文在交接时丢了**：你在 Cursor 里讨论清楚的范围和验收，到了执行方那里只剩一句"帮我实现 X"。派发协议解决的就是这件事：

- 任务先落成一份结构化的 Markdown 文件（task package），人读正文、工具读 frontmatter。
- 派发、执行、审查、gate 全部围绕这份文件进行，谁接手都从同一份事实出发。
- 执行结果同样落成结构化文件（review packet），gate 判定有据可查。

写不出验收标准的任务，说明还没准备好派发——先回到澄清阶段。

## 2. 角色模型展开

协议按角色设计（见立项书第 5 节），三个角色的职责边界与交接物：

| 角色 | 职责 | 输入 | 输出（交接物） | 默认承担者 |
| --- | --- | --- | --- | --- |
| **Coordinator** | 需求 intake、澄清、拆解、路由、轻量执行、协调重试 | 用户需求 | task package | Cursor |
| **Executor** | 按任务包实现、本地验证、交付总结 | task package | 代码改动 + review packet | Codex |
| **Reviewer / Architect** | 独立审查、风险发现、gate 建议 | diff + task package + review packet | 审查结论（PASS/FAIL + 理由） | Claude（可降级，见第 5 节） |

merge 与最终判定属于 **human gate**，不属于任何 AI 角色。

常见误用：

- **把 coordinator 当 executor 用**：在 Cursor 里直接做长时间、多文件的 repo-wide 修改。Cursor 适合轻量执行；重执行任务应落包派给 executor，否则上下文越滚越长、范围越改越飘。
- **把 executor 当 coordinator 用**：给 Codex 一句模糊需求让它"自己看着办"。executor 的强项是按明确验收标准执行，不是替你想清楚需求。
- **让 reviewer 持有执行状态**：让审查方一边改代码一边审。审查者不得复用执行者的同一份上下文，这是硬约束（"自己改自己审"等于没审）。
- **跳过交接物口头派发**：聊天里说清楚了就直接开工。没有 task package，FAIL 之后你连"当初约定了什么"都无法回溯。

## 3. Task Package 逐字段写作指南

以下与 `templates/task-package.md` 完全一致，逐字段说明怎么填、填错的典型后果。

### `task_id`

任务唯一 ID，建议 `<前缀>-<序号>`（如 `EX-001`）或 `<日期>-<slug>`。
**填错的后果**：ID 不唯一或随手起名，review packet 和 runs 留档无法对应回任务，复盘时对不上号。

### `type`

枚举：`feature | bugfix | refactor | docs | research | qa`。
**填错的后果**：type 影响路由直觉（research 基本走只读并行，refactor 默认要求隔离）；乱填会误导后续自动化路由。

### `route`

枚举：`cursor | cursor-multitask | codex | codex+reviewer-gate`。reviewer 为角色名，默认由 Claude 承担；无 Claude 时按 9.4 映射（见第 5 节）。
**填错的后果**：该走 gate 的任务填了 `codex`，改动没人独立审查就进了主干；只读调研填了 `codex`，白白多花一轮交接成本。选择方法见第 4 节 routing matrix。

### `risk_level`

枚举：`low | medium | high`。涉及 auth/payment/data/deployment 至少 `medium`。
**填错的后果**：risk_level 驱动 gate 与 isolation 的强制规则；低估风险等于关掉了保险丝。

### `gate_required`

枚举：`none | reviewer | human`。`high` 风险必须 `human`。
**填错的后果**：`none` 用在高风险任务上，出问题时没有任何独立检查环节；反过来，每个小改动都上 `human` 会把你自己变成瓶颈。

### `isolation`

枚举：`none | branch | worktree`。强制升级规则：并行写同一 repo → `worktree`；`high` 风险 → 至少 `branch`（并行时必须 `worktree`）。
**填错的后果**：两个并行写任务都填 `none`，必然在同一工作区互相覆盖，返工成本远超 worktree 的创建成本。选择流程见第 6 节。

### `worktree.branch` / `worktree.merge_by`

`isolation: worktree` 时必填：分支名约定 `task/<task_id>`；`merge_by` 枚举 `human | coordinator`，声明谁有权执行 merge。
**填错的后果**：不写 `merge_by`，executor 可能自行 merge——merge 即 gate 的机制就失效了。

### `scope.allow` / `scope.deny`

允许与禁止修改的文件/目录（glob），deny 优先级高于 allow。
**填错的后果**：allow 写太宽（如 `src/**`），executor "顺手优化"了不相关模块；忘写 deny，敏感文件（`.env*`、auth 模块）暴露在修改范围内。

### `acceptance[]`

验收标准列表，每条必须可执行、可判定（命令、路径、预期输出）。
**填错的后果**：写成"代码质量要好"这类不可判定的标准，验收时只能凭感觉，gate 形同虚设（写作法详见 docs/04 第 2 节）。

### `protocol_version`

协议版本号，勿手改；schema 变更时由维护者统一升级。
**填错的后果**：私自改版本号会让工具侧无法判断字段兼容性。

正文八节（背景/目标/范围/隔离/非目标/上下文/验收/风险/交付）是 frontmatter 的人话展开，模板内已附逐节填写说明与示例，此处不重复。

## 4. Routing Matrix 实操版

以立项书 9.2 为基础，每行补一个真实场景：

| 任务类型 | 推荐路径 | 隔离级别 | 成本 | 场景示例 |
| --- | --- | --- | --- | --- |
| "解释 Cursor 怎么用" | Cursor | none | 低 | "Worktree 和 branch 有什么区别？"——直接在 Chat 里问，交互式追问最快。 |
| "帮我写一个小函数" | Cursor 或 Codex | none | 低 | 给 `utils` 加一个 `slugify`：Cursor 直接写；如果要求跑通现有测试套件再交付，落包给 Codex。 |
| "修一个 bug" | Codex -> reviewer gate | none / branch | 中 | "表单重复提交"：Codex 先 trace 根因再修复并跑测试，reviewer 审 diff。改动面大时升 branch。 |
| "大功能拆解" | Cursor Plan -> task package -> Codex | branch / worktree | 中 | "增加导出 PDF 功能"：先 Plan 拆成 3 个子任务，逐个落包派发；子任务并行时各自 worktree。 |
| "多个独立调研" | Cursor Multitask | none（只读） | 中 | 同时调研三个图表库的 API 差异——只读并行，产出对比报告。 |
| "并行开发多个功能" | 多个 Codex，每个独立 worktree | worktree | 高 | 两个功能同仓同期开发：各开一个 worktree（`task/EX-001`、`task/EX-002`），互不可见，merge 时逐个 gate。 |
| "跨前后端联调" | Codex implementation + reviewer gate | branch / worktree | 高 | 订单接口加字段、前端同步展示：契约变更多，executor 实现后 reviewer 必须核对两侧一致性。 |
| "架构方案比较" | reviewer 辨析 -> Cursor/Codex 落地；需实证时 best-of-N worktree | worktree | 中 | "状态管理选 Zustand 还是 Redux Toolkit"：先让 reviewer 做利弊辨析；需要实证就两个 worktree 各做原型，取优淘汰。 |
| "上线前检查" | Codex verify -> reviewer review | none | 高 | 发布前让 Codex 跑全量验收命令产出证据，reviewer 独立审一遍，最后 human gate 放行。 |

成本列的含义与省钱手段详见 docs/05 第 2 节。

## 5. 双工具降级模式（无 Claude）

reviewer 是角色不是工具。只有 Cursor + Codex 时，按立项书 9.4 把 reviewer 角色重新映射，工作流其余部分完全不变。三种承担方式的具体操作：

### 5.1 Codex 双会话

适用：代码 review、上线前检查。

1. 执行会话交付 review packet 后，**关闭或离开该会话**。
2. 另开一个**全新 Codex 会话**（只读，不授予写权限）。
3. 只喂三样东西：diff（或分支名）、task package、review packet。
4. **禁止给**：执行会话的对话历史、执行过程的中间产物、任何"我刚才是这么想的"类上下文——审查者一旦继承执行立场，审查就失效了。
5. 要求输出：PASS/FAIL + 理由 + 风险清单（格式见 docs/04 第 4 节）。

### 5.2 Cursor 审查

适用：中低风险任务的常规 gate。

1. Cursor 作为 coordinator，新开对话（不复用派发时的会话上下文）。
2. 核对三件事：交付物与 task package 的 acceptance 逐条对应；验收命令输出真实存在；改动未越出 `scope.allow`、未触碰 `scope.deny`。
3. 结论写回 review packet 的 gate 建议节。

### 5.3 Human gate 加重

适用：高风险任务（auth/payment/data/deployment/shared contract）。

人工逐条核对验收标准、**亲自跑验收命令**（不只看 executor 贴的输出）、逐文件读 diff。双工具模式下高风险任务的 human gate 不可省略。

通用规则：上下文隔离是硬约束——review 会话不得复用实现会话；宁可信息少，不可立场同。

## 6. 执行隔离与 Worktree 策略

### 6.1 isolation 三级别选择流程

按顺序问三个问题：

1. **有没有别的写任务和它并行、目标同一 repo？** 有 → `worktree`，结束。
2. **是不是 high 风险，或涉及 auth/payment/data/deployment/shared contract？** 是 → 至少 `branch`（如果同时并行，回到问题 1 升 `worktree`）。
3. **改动大吗、需要干净 diff 或"随时整个丢弃"的能力吗？** 需要 → `branch`；只读调研或低风险小改 → `none`。

方案对比（同一任务派发多个实现取优）是第四种触发：每个实现一个 worktree，best-of-N 后淘汰其余。

### 6.2 Worktree 生命周期五步（命令与话术）

**① 创建**（coordinator 执行，或在任务包里指令 executor 执行）：

```bash
git worktree add ../<repo>-<task_id> -b task/<task_id>
```

任务包 frontmatter 同步声明：

```yaml
isolation: worktree
worktree:
  branch: task/EX-001
  merge_by: human
```

**② 执行**。派发话术模板：

```text
你的工作目录是 ../<repo>-EX-001（分支 task/EX-001）。
全程只在该目录内工作，禁止 cd 回主工作区修改任何文件。
task package 的 scope.allow/deny 在 worktree 内同样生效。
```

**③ 交付**。review packet 必须附：worktree 分支名（frontmatter `worktree_branch` 字段）+ diff 摘要：

```bash
git diff main...task/EX-001 --stat   # 文件清单
git diff main...task/EX-001          # reviewer 审查用全量 diff
```

**④ 合并即 gate**。merge 动作只能由 `worktree.merge_by` 声明的 gate 方（通常 human）执行：

```bash
# PASS：
git merge task/EX-001
git worktree remove ../<repo>-EX-001
git branch -d task/EX-001
```

executor 无权 merge。这不是流程洁癖：merge 权限收在 gate 方手里，"未经审查的改动进不了主干"才是机制保障而非口头约定。

**⑤ 留档**。runs 记录写入：worktree 分支名、合并 commit、丢弃原因（如有）。

### 6.3 FAIL 丢弃流程

FAIL 后二选一：

- **收窄重试**：在**同一个 worktree** 里继续（上下文和半成品都在），任务包按第 8 节收窄。
- **整个丢弃**：判断方向错了就直接扔——

```bash
git worktree remove --force ../<repo>-EX-001
git branch -D task/EX-001
```

丢弃即回滚，主工作区从头到尾没被碰过。worktree 的可丢弃性就是它最大的价值。

## 7. 派发实操流程

从需求到派发出去的完整五步：

1. **澄清**：在 Cursor 里把模糊需求问清楚（目标、边界、已知约束）。产出：一段明确的需求描述。
2. **拆解**：超过一次交付能力的需求先拆（Plan 模式），每个子任务独立可验收。
3. **写包**：复制 `templates/task-package.md`，按第 3 节字段指南填写。自查工具：`templates/acceptance-checklist.md` 的"派发前检查"。
4. **选路由与隔离**：对照第 4 节 matrix 与第 6.1 节流程，填 `route` 与 `isolation`。
5. **派发**：把 task package 全文交给 executor，附一句边界提醒（prompt 模板见 `templates/cursor-prompt-snippets.md` 片段 4）。

## 8. 失败与重试：narrow retry 写法

FAIL 之后最大的错误是把原任务包原样重跑——同样的输入大概率得到同样的失败。narrow retry 的三个动作：

1. **范围减半**：从失败证据里找出"实际卡住的那一小块"，新任务包只做这一块。`scope.allow` 相应收窄。
2. **验收聚焦**：只保留与失败点直接相关的验收条目，其余移出本轮。
3. **附上一轮失败证据**：把上一轮 review packet 的 FAIL 理由与关键报错放进新任务包的"上下文"节——executor 不知道上次怎么失败的，就会再失败一次。

同时在新任务包沿用同一 `task_id` 并让 review packet 的 `retries` 计数 +1，留档才能反映真实重试成本。连续两轮 FAIL 后停止自动重试，转 human 接管分析。

## 9. 下一步

任务派出去了，怎么判断交付能不能要？进入 [`04-quality-gate.md`](04-quality-gate.md)：验收标准写作法、review packet 组织、gate 判定与状态机。
