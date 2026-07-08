---
# Acceptance Checklist —— 派发前后的验收自查清单
# 用法：派发前用"派发前检查"，gate 时用"验收检查"；逐项勾选。
task_id: EX-001                # 对应 task package 的 task_id
checked_by: ""                 # 检查人：留空或填名字/agent 名
checked_at: ""                 # 检查日期，格式 YYYY-MM-DD
protocol_version: "0.1"
---

# Acceptance Checklist: <任务标题>

## 派发前检查（Cursor / 人）

- [ ] task package 各节填写完整，没有"待定"字段
- [ ] `scope.allow` / `scope.deny` 明确且互不矛盾
- [ ] 每条 acceptance 都可执行、可判定（有命令/路径/预期输出）
- [ ] 非目标已写明，防止范围蔓延
- [ ] `risk_level` 与 `gate_required` 匹配（auth/payment/data/deployment/shared contract 必须走 gate）
- [ ] 上下文材料（文件、文档链接）执行方可直接访问

## 验收检查（gate 方）

- [ ] review packet 已提交且 `task_id` 对应
- [ ] 每条 acceptance 有对应证据，且证据真实可复现
- [ ] 改动未越出 `scope.allow`，未触碰 `scope.deny`
- [ ] 测试/验证命令在本地实际复跑通过（不只信 agent 的输出）
- [ ] 风险发现一节已阅读，遗留项已记录
- [ ] 判定结论（PASS / FAIL + narrow retry 范围）已写回 review packet 或 runs 留档

## 判定结果

- 结论：PASS / FAIL（二选一）
- 说明：1-2 句判定依据；若 FAIL，写明收窄后的 retry 范围。
