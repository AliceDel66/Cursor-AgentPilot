# Cursor AgentPilot 开发计划

状态：Sprint 0 已完成（`docs/00-project-brief.md` v0.2）。
仓库：git@github.com:AliceDel66/Cursor-AgentPilot.git
分工：Cursor 规划与验收；Codex 实施；用户 human gate。

## Sprint 总览

| Sprint | 内容 | 状态 |
| --- | --- | --- |
| 0 | 立项书 v0.2 → v0.2.1（架构、护城河、协议角色化 + 9.4 双工具降级模式） | 完成 |
| 1 | 文档骨架 + 模板 frontmatter schema + README（含角色化对齐，commit 65b2fa7 / 074c2d4） | 完成，已验收 |
| 2 | 新手手册正文（docs/01、02）+ README 开源化美化 + LICENSE（commit 803d13e） | 完成，已验收 |
| 3 | 派发设计正文（docs/03、04、05）（commit ea28934） | 完成，已验收 |
| 3.5 | QUICKSTART 极简用法 + README 声明（commit 49cd744） | 完成，已验收 |
| 3.6 | AgentPilot skill + install.sh 一键挂载（commit 39252d5） | 完成，已验收 |
| 4 | 示例闭环（examples + runs 首批留档） | 待启动 |

---

## Task Package: Sprint 1 文档骨架

```yaml
task_id: S1-skeleton
type: docs-scaffold
route: codex
risk_level: low
gate_required: human
protocol_version: "0.1"
scope:
  allow:
    - README.md
    - docs/**
    - templates/**
    - examples/**
    - runs/.gitkeep
  deny:
    - docs/00-project-brief.md   # 已定稿，不得修改
    - plans/plan.md              # 由 Cursor 维护
```

### 背景

立项书 v0.2 已定稿（见 `docs/00-project-brief.md`），需要按第 10 节的仓库架构建立完整骨架，并把第 6.2 节的协议层 schema 落到模板中。

### 目标

仓库骨架完整，四个模板可直接复制使用且 frontmatter 可被 YAML parser 解析，每个 docs/examples 文件有完整一级结构（标题 + 各章节占位说明）。

### 交付物

1. `README.md`：项目定位、适合谁、5 分钟快速开始、新手路径、目录导航（内容写全，不是占位）。
2. `docs/01~05` + `docs/changelog-watch.md`：一级/二级标题骨架，每节 1-2 句说明该节将覆盖什么；文件头部 frontmatter 含 `last_verified: 2026-07-08` 与 `sources` 列表。
3. `templates/task-package.md`：YAML frontmatter（`task_id`、`type`、`route`、`scope.allow`、`scope.deny`、`acceptance`、`risk_level`、`gate_required`、`protocol_version`）+ Markdown 正文段落（背景/目标/范围/非目标/上下文/验收/风险/交付），每个字段附填写说明和示例值。
4. `templates/review-packet.md`：frontmatter（`task_id`、`verdict: PASS|FAIL`、`evidence`、`retries`）+ 正文（改动摘要/验证证据/风险发现/gate 建议）。
5. `templates/acceptance-checklist.md`、`templates/cursor-prompt-snippets.md`：可用初版。
6. `examples/` 五个文件：骨架 + 每个案例的场景描述与适用路径标注。
7. `runs/.gitkeep`。

### 非目标 / 禁止项

- 不写 docs/01~05 的正文内容（Sprint 2/3 做）。
- 不改 `docs/00-project-brief.md` 和 `plans/plan.md`。
- 不引入任何构建工具、依赖或 CI。
- 不发明立项书之外的新目录。

### 验收

- `python3 -c "import yaml,glob; [yaml.safe_load(open(f).read().split('---')[1]) for f in glob.glob('templates/*.md') if open(f).read().startswith('---')]"` 通过（或等效验证所有 frontmatter 可解析）。
- 目录结构与立项书第 10 节完全一致。
- README 单独可读：新用户只看 README 能知道项目是什么、从哪开始。
- 全部中文（代码/字段名/专有名词英文）。
- git commit（不 push，由用户 gate 后 push）。

---

---

## Task Package: Sprint 2 新手手册 + 开源化

```yaml
task_id: S2-handbook-oss
type: docs-content
route: codex
risk_level: low
gate_required: human
isolation: none            # 单任务串行，主工作区执行
protocol_version: "0.1"
scope:
  allow:
    - README.md
    - LICENSE
    - docs/01-cursor-beginner-guide.md
    - docs/02-agent-mode-map.md
    - docs/changelog-watch.md
    - CONTRIBUTING.md
  deny:
    - docs/00-project-brief.md
    - docs/03-dispatch-design.md   # Sprint 3 范围
    - docs/04-quality-gate.md
    - docs/05-cost-and-risk.md
    - templates/**                 # 协议已定稿，本 Sprint 不动
    - examples/**
    - plans/plan.md
```

### 背景

项目已 push 到 GitHub 公开仓库（AliceDel66/Cursor-AgentPilot），进入开源阶段。Sprint 1 骨架已就绪，现在需要：README 达到开源项目门面水准、明确开源协议、完成新手手册两章正文。

### 目标

1. README 美观优雅，具备开源项目标配元素。
2. 开源协议落地：内容采用 CC BY 4.0，templates 目录额外声明 CC0（模板要被用户复制进私有项目，不应有署名负担）。
3. docs/01、02 从骨架变为完整正文，新手可照着走通。

### 交付物

1. `LICENSE`：CC BY 4.0 完整官方文本。
2. `README.md` 重构：
   - 顶部居中标题 + 一句话定位 + badge 行（License: CC BY 4.0、docs: 简体中文、PRs Welcome、协议版本 protocol v0.1）。
   - 结构：是什么 / 为什么（痛点）/ 角色模型（保留现有 mermaid 或表格）/ 5 分钟快速开始 / 新手路径 / 目录导航 / 协议与隔离机制一览 / 开源协议说明（CC BY 4.0 + templates CC0）/ 贡献指引入口 / 免责与时效说明（last_verified 机制）。
   - 中文为主，美观但不堆砌 emoji（章节标题可用少量语义化图标）。
3. `CONTRIBUTING.md`：简版——如何报告过期内容、如何提交案例/runs、PR 约定（frontmatter 必须可解析）、协议字段变更需 issue 讨论。
4. `docs/01-cursor-beginner-guide.md` 完整正文：安装与账号、界面（Editor/Chat/Agent Window/Changes/Terminal/Browser）、Context 使用（文件/目录/selection/截图/终端输出）、prompt 基础（目标/上下文/约束/验收）、六种常见模式（解释/补全/改 bug/写测试/改 UI/review）、新手四大错误（任务太大/上下文缺失/没有验收/让 Agent 猜环境），每个错误配"错误写法 vs 正确写法"对照示例。
5. `docs/02-agent-mode-map.md` 完整正文：Chat/Agent/Plan/Multitask/Worktree/Multi-root 六模式，每个模式含"适合/不适合/典型 prompt 示例/成本提示"；Worktree 一节须与立项书 9.5 的隔离级别表一致；末尾给"模式选择决策树"（mermaid flowchart）。
6. `docs/changelog-watch.md`：登记 2026-04-24 changelog（Multitask/Worktrees/Multi-root）对 01、02 章的影响映射，作为首条记录。

### 非目标 / 禁止项

- 不写 docs/03~05 正文（Sprint 3）。
- 不改 templates、examples、立项书、plan。
- 不引入构建工具、CI、静态站点生成器。
- 不虚构 Cursor 功能：拿不准的表述标注"以官方文档为准"并附链接。

### 验收

- 全部 frontmatter 可被 PyYAML 解析；docs/01、02 的 `status` 从 `skeleton` 改为 `complete`，`last_verified: 2026-07-08`。
- README 在 GitHub 渲染无破版（badge、mermaid、表格正常）。
- 新手视角自测：只读 README + docs/01 能完成一次"小功能修改"任务描述。
- LICENSE 为 CC BY 4.0 官方全文；README 与 CONTRIBUTING 的协议表述一致。
- git commit（不 push，用户 gate 后统一 push）。

---

## Task Package: Sprint 3 派发设计正文

```yaml
task_id: S3-dispatch-docs
type: docs-content
route: codex
risk_level: low
gate_required: human
isolation: none            # 单任务串行，主工作区执行
protocol_version: "0.1"
scope:
  allow:
    - docs/03-dispatch-design.md
    - docs/04-quality-gate.md
    - docs/05-cost-and-risk.md
    - docs/changelog-watch.md    # 如需登记影响映射
    - README.md                  # 仅允许改"骨架期"过渡表述与文档状态标注
  deny:
    - docs/00-project-brief.md
    - docs/01-cursor-beginner-guide.md
    - docs/02-agent-mode-map.md
    - templates/**
    - examples/**
    - LICENSE
    - CONTRIBUTING.md
    - plans/plan.md
```

### 背景

docs/01、02 正文已完成（Sprint 2），三份派发设计文档仍是骨架。立项书 v0.2.2 的第 5、9 节（角色模型、routing matrix、9.3 派发协议、9.4 双工具降级、9.5 隔离与 worktree）是这三章的权威来源，正文是对它们的展开与实操化，不得与立项书冲突。

### 目标

读者读完 docs/03~05 后能独立完成：写一份合格 task package → 选对路径与隔离级别 → 组织 review packet → 执行 gate 判定 → 控制成本与风险。

### 交付物

1. `docs/03-dispatch-design.md` 完整正文：
   - 角色模型展开：三角色的职责边界、交接物、常见误用（把 coordinator 当 executor 用等）。
   - task package 逐字段写作指南：每个 frontmatter 字段"怎么填、填错的典型后果"，与 `templates/task-package.md` 注释一致但更展开。
   - routing matrix 实操版：立项书 9.2 表为基础，每行补一个 1-3 句的真实场景示例。
   - 双工具降级模式展开（9.4）：三种 reviewer 承担方式的具体操作步骤（如 Codex 双会话怎么开、给什么上下文、禁止给什么）。
   - 执行隔离与 worktree 策略正文（9.5 展开）：isolation 三级别选择流程、worktree 生命周期五步的具体命令与话术、merge-即-gate 的操作细节、FAIL 丢弃流程。
   - narrow retry 写法：FAIL 后如何把任务包收窄（范围减半、验收聚焦、附上一轮失败证据）。
2. `docs/04-quality-gate.md` 完整正文：
   - 验收标准写作法：可执行、可判定、反例对照（"代码质量好"vs"npm test 退出码 0"）。
   - review packet 组织法：执行方填什么、证据不足即 FAIL 的原则。
   - reviewer gate 用法：给 reviewer 的上下文最小集（diff + task package + review packet）、要求的输出格式（PASS/FAIL + 理由 + 风险清单）、上下文隔离硬约束；覆盖三工具与双工具两种配置。
   - human gate 清单：什么必须人做（merge、高风险判定、协议外决策）、怎么做（对照 acceptance 逐条勾选、亲自跑一条验收命令抽查）。
   - PASS/FAIL/retry 状态机：mermaid 状态图 + 每个转移的触发条件。
3. `docs/05-cost-and-risk.md` 完整正文：
   - 成本模型：按路径的成本分级（对应 routing matrix 成本列）、什么任务不值得派发（沟通成本 > 执行成本的判断法）。
   - 并行的隐性成本：冲突返工、重复上下文、review 放大。
   - 风险控制：立项书第 12 节风险表逐条展开为操作建议；敏感边界清单（auth/payment/data/deployment/shared contract）与强制 gate 规则。
   - 上下文安全：task package / review packet 中禁止出现的内容（secrets、token、内部 URL）与替代写法。
   - rollback 思维：branch/worktree 的可丢弃性、merge 前的最后检查。
4. `docs/changelog-watch.md`：如 03~05 引用了 changelog 功能点，补充影响映射行。
5. README.md：把快速开始第 4 步"骨架期可先看立项书 9.2 节"的过渡表述改为直接指向 docs/03；目录导航中 03~05 的注释加"（正文完成）"。

### 非目标 / 禁止项

- 不改 templates（协议已定稿；发现模板与正文冲突时以模板为准并在回复中上报，不擅自改）。
- 不改立项书、docs/01、02、examples、plan。
- 不引入新的协议字段——如认为字段缺失，在回复中提出建议，由 Cursor 决定。
- 不虚构 Cursor 功能，拿不准的标注"以官方文档为准"附链接。

### 验收

- 三份文档 frontmatter：`status: complete`、`last_verified: 2026-07-08`，PyYAML 全仓解析通过。
- docs/03 的字段指南与 templates/task-package.md 的字段/枚举完全一致（逐字段核对）。
- docs/04 含 PASS/FAIL/retry mermaid 状态图且语法可渲染。
- 与立项书 9.2~9.5 无表述冲突。
- 全部简体中文（专有名词英文）。
- git commit（不 push，验收后统一 push）。

---

## Task Package: S3.5 极简用法（QUICKSTART）

```yaml
task_id: S3.5-quickstart
type: docs-content
route: codex
risk_level: low
gate_required: human
isolation: none
protocol_version: "0.1"
scope:
  allow:
    - QUICKSTART.md
    - README.md
  deny:
    - docs/**
    - templates/**
    - examples/**
    - plans/plan.md
    - LICENSE
    - CONTRIBUTING.md
```

### 背景

用户反馈完整工作流（读 5 章手册 + 填全量 task package）对第一次使用者门槛偏高。需要一条"30 秒能上手"的极简路径，且必须与现有协议兼容——不新增第二套模板，只做"最小填写子集 + 默认值"约定。

### 目标

新用户不读手册也能在 30 秒内发出第一个合规派发；README 顶部明确声明这条极简路径的存在。

### 交付物

1. `QUICKSTART.md`（新建，全文 ≤ 120 行）：
   - "三步用法"：① 复制下面的最小任务包到你的项目 → ② 填 5 个必填项 → ③ 把派发话术粘贴给你的 Agent。
   - 内嵌一份**可直接复制的最小 task package 示例**（真实填好值的 bugfix 例子）：只含 `task_id`、`type`、`route`、`scope.allow/deny`、`acceptance` 五个必填字段 + 正文只写"目标 / 上下文 / 非目标"三节。注明：其余字段省略时的默认值为 `risk_level: low`、`gate_required: human`、`isolation: none`、`protocol_version: "0.1"`（该默认值约定必须与 templates/task-package.md 的字段语义一致，不得新造枚举）。
   - 一段**可直接粘贴的派发话术**（"请按 <文件路径> 的任务包执行，只改 scope.allow 内文件，完成后逐条回报 acceptance 结果"）。
   - 一段**最简验收话术**（人工 gate：逐条对照 acceptance + 亲自跑一条命令抽查）。
   - 结尾"想更进一步"指向 README 新手路径与 docs/03。
   - frontmatter：`title`、`last_verified: 2026-07-08`、`status: complete`。
2. `README.md`：
   - "5 分钟快速开始"之前新增一节"🚀 30 秒上手"，2-3 句话 + 指向 QUICKSTART.md 的链接，明确说明"不想读手册可以先走这条路"。
   - 目录导航中加入 QUICKSTART.md 条目。

### 非目标 / 禁止项

- 不新增模板文件、不改 templates/**、不引入新协议字段或枚举。
- 不改 docs 各章正文。
- QUICKSTART 不复述手册内容，超出"三步 + 示例 + 话术"的解释一律用链接代替。

### 验收

- QUICKSTART.md 内嵌示例的 frontmatter 字段名/枚举值与 templates/task-package.md 逐项一致，PyYAML 可解析。
- 全仓 frontmatter 验证通过。
- README 渲染无破版。
- git commit（不 push，验收后统一 push）。

---

## Task Package: S3.6 Skill 化与一键挂载

```yaml
task_id: S3.6-skill-install
type: feature
route: codex
risk_level: low
gate_required: human
isolation: none
protocol_version: "0.1"
scope:
  allow:
    - skills/**
    - install.sh
    - README.md
    - QUICKSTART.md
  deny:
    - docs/**
    - templates/**
    - examples/**
    - plans/plan.md
    - LICENSE
    - CONTRIBUTING.md
```

### 背景

用户希望 AgentPilot 不止是"手册 + 手动复制模板"，而是：① 像 Cursor Skill 一样装一次、对话中自动触发；② 像脚手架一样在创建/接入项目时一键挂载协议。两者都不得破坏零依赖原则（纯 Markdown + 纯 shell，不引 npm/pip/CI）。

### 目标

装了 skill 的用户对 Cursor 只说需求即可触发协议闭环；任何项目跑一条命令即可挂载 AgentPilot 工作流。

### 交付物

1. `skills/agentpilot/SKILL.md`（新建）：
   - 标准 Cursor Skill 格式（frontmatter: name、description——description 写清触发条件："用户提出开发/修复/重构需求且涉及派发或多 Agent 协作时使用"）。
   - 正文定义 Coordinator 行为：五步（澄清 → 生成 tasks/<task_id>.md 任务包 → 按 routing matrix 选 route 与 isolation → 派发话术 → 汇总等 human gate）；必填 5 字段 + 默认值约定与 QUICKSTART 一致；硬边界（merge 与高风险判定永远留给人；写不出 acceptance 就回澄清；scope 外不改）。
   - 内嵌最小任务包骨架与派发/验收话术（可引用 QUICKSTART，不整段复述）。
2. `install.sh`（新建，仓库根目录，纯 POSIX shell，无外部依赖）：
   - 用法：`./install.sh /path/to/project`（无参数时打印用法）。
   - 动作：在目标项目创建 `tasks/`、`runs/`；复制 `templates/*.md` 到 `<project>/templates/agentpilot/`；生成 `<project>/.cursor/rules/agentpilot-coordinator.mdc`（内容与 SKILL.md 的 Coordinator 行为一致，规则形式）；可选 `--skill` 参数把 skill 复制到 `~/.cursor/skills/agentpilot/`。
   - 幂等：已存在的文件不覆盖（提示跳过）；结束时打印"装了什么 + 下一步做什么"。
   - `shellcheck` 级别的干净写法（不要求真装 shellcheck，语法规范即可）。
3. `README.md`：
   - "30 秒上手"节之后新增"🔌 挂载到你的项目"一节：两种方式（install.sh 一键挂载 / 手动复制），以及 skill 安装方式；说明挂载后"只说需求即可"。
   - 目录导航加 `skills/`、`install.sh` 条目。
4. `QUICKSTART.md`：末尾"想更进一步"加一行指向"挂载到你的项目"（README 对应节）。

### 非目标 / 禁止项

- 不引入 npm/pip/Homebrew 等任何包管理依赖；不做 npx 包发布（后续 P3 再议）。
- 不改 templates/**、docs/**；skill 与规则中的字段、枚举、默认值必须与 templates/task-package.md 及 QUICKSTART 完全一致，不新造。
- skill 不承担 executor/reviewer 职责，不自动 merge。

### 验收

- `bash -n install.sh` 语法通过；在 /tmp 建临时目录实测一次挂载，验证目录/文件生成正确且二次运行幂等。
- SKILL.md frontmatter 可被 PyYAML 解析；全仓 frontmatter 验证通过。
- README/QUICKSTART 渲染无破版。
- git commit（不 push，验收后统一 push）。

---

## Task Package: S3.7 执行引擎与模型路由对齐

```yaml
task_id: S3.7-engine-model
type: docs-content
route: codex
engine: codex-cli          # 本任务本身即用本机 Codex CLI 执行（validate the path）
risk_level: low
gate_required: human
isolation: none
protocol_version: "0.1"
scope:
  allow:
    - templates/task-package.md
    - templates/review-packet.md
    - skills/agentpilot/SKILL.md
    - install.sh
    - docs/03-dispatch-design.md
    - docs/04-quality-gate.md
    - docs/05-cost-and-risk.md
    - README.md
    - QUICKSTART.md
  deny:
    - docs/00-project-brief.md
    - docs/01-cursor-beginner-guide.md
    - docs/02-agent-mode-map.md
    - examples/**
    - plans/plan.md
    - LICENSE
    - CONTRIBUTING.md
```

### 背景

用户从用量日志发现："派发 Codex" 实际跑在 Cursor 内部 subagent 上（模型/账单走 Cursor），并非本机 Codex CLI。立项书 v0.2.3 新增 9.6 节"执行引擎与模型路由"（权威来源），需要全仓对齐。

### 目标

协议明确区分执行引擎（codex-cli 默认 / cursor-subagent 显式）；模型按 risk_level 派生、可选覆盖；cross-model review 成为 gate 硬约束。

### 交付物

1. `templates/task-package.md`：frontmatter 增加可选注释字段 `engine`（codex-cli | cursor-subagent，route: codex 时默认 codex-cli，用 cursor-subagent 必须显式声明）与注释掉的 `model_override.executor/reviewer` 示例；注释说明派生规则（risk_level low→fast / medium→standard / high→high，refactor|research 上调一档）。
2. `templates/review-packet.md`：frontmatter 增加可选 `engine`、`model_used`、`same-family-review` 注释字段。
3. `skills/agentpilot/SKILL.md`：第 3 步"选路由与隔离"扩展为"选路由、隔离与引擎"；新增引擎验证（`which codex`，不可用先报告用户，禁止静默换 cursor-subagent）；派发话术带上实际执行命令示例（`codex exec -C <repo> --sandbox workspace-write "<任务包路径与指令>"`）；补 cross-model 原则一句。
4. `install.sh` 生成的 `.mdc` 规则同步上述第 3 步内容（与 SKILL.md 一致）。
5. `docs/03-dispatch-design.md`：新增"执行引擎与模型路由"一节（引擎对照表、默认与显式声明规则、派生档位、model_override、指向立项书 9.6）；routing matrix 不改结构，仅在该节文字说明。
6. `docs/04-quality-gate.md`：reviewer gate 一节补 cross-model 硬约束与 same-family-review 降级标注。
7. `docs/05-cost-and-risk.md`：成本模型补一段"引擎选择即计费选择"（Cursor 订阅 vs OpenAI 订阅，引擎混淆导致的成本不可审计）。
8. `README.md` / `QUICKSTART.md`：各加 1-2 句引擎说明（默认本机 Codex CLI，无 CLI 用 cursor-subagent）。

### 非目标 / 禁止项

- 不改立项书（9.6 已由 coordinator 写好）、docs/01、02、examples。
- 不引入 models.yaml 实体文件（本轮只在文档说明其为可选扩展，P3 再实现）。
- 字段名以立项书 9.6 为准：engine、model_override、same-family-review；不新造其他字段。

### 验收

- PyYAML 全仓 frontmatter 解析通过。
- SKILL.md、install.sh 生成规则、docs/03 三处的引擎/模型表述一致。
- `bash -n install.sh` 通过。
- git commit（不 push，验收后统一 push）。

---

## Sprint 4 任务包

待 S3.7 验收通过后拆解。
