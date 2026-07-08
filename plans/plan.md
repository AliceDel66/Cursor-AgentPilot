# Cursor AgentPilot 开发计划

状态：Sprint 0 已完成（`docs/00-project-brief.md` v0.2）。
仓库：git@github.com:AliceDel66/Cursor-AgentPilot.git
分工：Cursor 规划与验收；Codex 实施；用户 human gate。

## Sprint 总览

| Sprint | 内容 | 状态 |
| --- | --- | --- |
| 0 | 立项书 v0.2 → v0.2.1（架构、护城河、协议角色化 + 9.4 双工具降级模式） | 完成 |
| 1 | 文档骨架 + 模板 frontmatter schema + README（含角色化对齐，commit 65b2fa7 / 074c2d4） | 完成，已验收 |
| 2 | 新手手册（docs/01、02） | 待启动 |
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

## Sprint 2-4 任务包

待 Sprint 1 验收通过后由 Cursor 拆解补充。
