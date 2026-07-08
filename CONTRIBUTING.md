# 贡献指引

感谢参与 Cursor AgentPilot。本项目是文档型仓库，贡献门槛低，但有几条硬约定。

## 报告过期内容

Cursor 迭代快，内容过期是最常见的问题：

1. 开 issue，标题注明受影响文件（如 `docs/02 Multitask 行为已变化`）。
2. 附上官方 changelog 或文档链接作为依据。
3. 如果你直接修，请同步更新该文件 frontmatter 的 `last_verified` 日期与 `sources` 列表。

## 提交案例 / runs 留档

真实派发闭环（含 FAIL 与 retry）是本项目最有价值的贡献：

- 案例放 `examples/`，留档放 `runs/YYYY-MM-DD-<slug>/`。
- 每个案例须包含：输入 prompt、task package、派发路径、验收命令、review 结果。
- 脱敏后再提交：不含 secrets、内部 URL、敏感 token。

## PR 约定

- 所有带 YAML frontmatter 的文件必须可被 PyYAML `safe_load` 解析（可用 `python3 -c "import yaml; yaml.safe_load(open('文件').read().split('---')[1])"` 自查）。
- 简体中文为主，代码、字段名、专有名词保留英文。
- 不引入构建工具、CI、静态站点生成器等依赖。
- commit message 用中文，说明改了什么、为什么。

## 协议字段变更

`templates/` 下的 frontmatter schema 是本项目的核心资产，保持向后兼容：

- 任何字段的增删改**必须先开 issue 讨论**，达成一致后才提 PR。
- schema 变更需同步更新 `protocol_version`。

## 许可

提交贡献即表示你同意内容以 CC BY 4.0 发布（`templates/` 目录为 CC0）。
