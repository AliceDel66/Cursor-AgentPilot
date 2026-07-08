# Cursor AgentPilot 开发计划

状态：Sprint 0 已完成（`docs/00-project-brief.md` v0.2）。
仓库：git@github.com:AliceDel66/Cursor-AgentPilot.git
分工：Cursor 规划与验收；Codex 实施；用户 human gate。

## Sprint 总览

| Sprint | 内容 | 状态 |
| --- | --- | --- |
| 0 | 立项书 v0.2 → v0.2.1（架构、护城河、协议角色化 + 9.4 双工具降级模式） | 完成 |
| 1 | 文档骨架 + 模板 frontmatter schema + README（含角色化对齐，commit 65b2fa7 / 074c2d4） | 完成，已验收 |
| 2 | 新手手册正文（docs/01、02）+ README 开源化美化 + LICENSE | 已派发 |
| 3 | 派发设计（docs/03、04、05） | 待启动 |
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

## Sprint 3-4 任务包

待 Sprint 2 验收通过后拆解。
