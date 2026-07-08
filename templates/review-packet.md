---
# Review Packet —— 执行证据与审查结论
# 用法：执行方（通常是 Codex）完成任务后填写；供 reviewer（默认 Claude，双工具模式见立项书 9.4）与人工 gate 消费。
task_id: EX-001                # 对应 task package 的 task_id，必须一致
verdict: PASS                  # 执行方自评结论：PASS | FAIL
retries: 0                     # 本任务累计重试次数；narrow retry 一次 +1
evidence:                      # 证据列表：命令输出、测试结果、截图路径
  - "npm test -- feature-x：42 passed, 0 failed"
  - "screenshots/feature-x-list.png"
---

# Review Packet: <任务标题>

> 由执行方填写，gate 方（reviewer / 人）据此判定。证据不足视同 FAIL。

## 改动摘要

改了哪些文件、核心逻辑变化、为什么这样改。建议附关键 diff 片段或 commit hash。
示例：新增 `src/feature-x/pagination.ts`，列表接口增加 `page`/`pageSize` 参数。

## 验证证据

对照 task package 的每条 acceptance，逐条给出执行命令与实际结果。
示例：验收 1 → `npm test -- feature-x` 全部通过（输出见 frontmatter evidence）。

## 风险发现

执行过程中发现的新风险、偏离 spec 的地方、遗留 TODO。没有也要写"无"。
示例：发现移动端调用方未传 pageSize，已按默认值 20 兼容，建议后续通知维护者。

## Gate 建议

给 gate 方的判定建议：建议 PASS/FAIL、需要重点复核的点、若 FAIL 建议的 narrow retry 范围。
示例：建议 PASS；重点复核分页边界（第 0 页、超出总页数）。
