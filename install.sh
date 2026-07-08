#!/bin/sh
# AgentPilot 一键挂载脚本（纯 POSIX shell，零依赖）
# 用法：
#   ./install.sh --skill-only              仅安装全局 Coordinator skill
#   ./install.sh /path/to/project           挂载工作流到目标项目
#   ./install.sh /path/to/project --skill   挂载 + 安装全局 skill

set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

usage() {
  cat <<'EOF'
AgentPilot 挂载脚本

用法：
  ./install.sh --skill-only                 仅安装 Coordinator skill 到 ~/.cursor/skills/（全局）
  ./install.sh /path/to/project             挂载工作流到目标项目
  ./install.sh /path/to/project --skill     挂载 + 安装全局 skill

挂载内容（项目）：
  <project>/tasks/                            任务包目录
  <project>/runs/                             派发留档目录
  <project>/templates/agentpilot/*.md         协议模板
  <project>/.cursor/rules/agentpilot-coordinator.mdc   Coordinator 行为规则

全局 skill：
  ~/.cursor/skills/agentpilot/SKILL.md        跨项目自动触发 Coordinator 行为
EOF
}

# 幂等辅助：目录存在则提示跳过
ensure_dir() {
  if [ -d "$1" ]; then
    echo "跳过（已存在）: $1"
  else
    mkdir -p "$1"
    echo "创建: $1"
  fi
}

# 幂等辅助：文件存在则不覆盖
copy_file() {
  src=$1; dst=$2
  if [ -e "$dst" ]; then
    echo "跳过（已存在）: $dst"
  else
    cp "$src" "$dst"
    echo "复制: $dst"
  fi
}

[ $# -ge 1 ] || { usage; exit 1; }

PROJECT=""
INSTALL_SKILL=0
SKILL_ONLY=0
for arg in "$@"; do
  case "$arg" in
    --skill) INSTALL_SKILL=1 ;;
    --skill-only) SKILL_ONLY=1; INSTALL_SKILL=1 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "未知参数: $arg"; usage; exit 1 ;;
    *) PROJECT=$arg ;;
  esac
done

if [ "$SKILL_ONLY" -eq 1 ] && [ -n "$PROJECT" ]; then
  echo "错误: --skill-only 不能与项目路径同时使用"
  usage
  exit 1
fi

if [ "$SKILL_ONLY" -eq 0 ]; then
  [ -n "$PROJECT" ] || { usage; exit 1; }
  [ -d "$PROJECT" ] || { echo "错误: 目标项目目录不存在: $PROJECT"; exit 1; }
fi

if [ "$SKILL_ONLY" -eq 1 ]; then
  echo "== 安装 AgentPilot 全局 Skill"
else
  echo "== 挂载 AgentPilot 到: $PROJECT"
fi

if [ "$SKILL_ONLY" -eq 0 ]; then
ensure_dir "$PROJECT/tasks"
ensure_dir "$PROJECT/runs"
ensure_dir "$PROJECT/templates/agentpilot"

for f in "$REPO_DIR"/templates/*.md; do
  copy_file "$f" "$PROJECT/templates/agentpilot/$(basename "$f")"
done

ensure_dir "$PROJECT/.cursor/rules"
RULE_FILE="$PROJECT/.cursor/rules/agentpilot-coordinator.mdc"
if [ -e "$RULE_FILE" ]; then
  echo "跳过（已存在）: $RULE_FILE"
else
  cat > "$RULE_FILE" <<'EOF'
---
description: AgentPilot Coordinator——用户提出开发/修复/重构需求且涉及派发或多 Agent 协作时，按协议整理任务包并派发
alwaysApply: false
---

# AgentPilot Coordinator 行为规则

处理实现类需求时按五步执行：

1. **澄清**：明确目标、文件范围、验收标准。写不出可执行、可判定的 acceptance 就继续澄清，不派发。
2. **生成任务包**：在 `tasks/<task_id>.md` 创建任务包。必填 5 字段：
   `task_id`、`type`（feature | bugfix | refactor | docs | research | qa）、
   `route`（cursor | cursor-multitask | codex | codex+reviewer-gate）、
   `scope.allow/deny`、`acceptance`。正文写目标/上下文/非目标三节。
   省略字段默认：`risk_level: low`、`gate_required: human`、`isolation: none`、`protocol_version: "0.1"`。
3. **选路由、隔离与引擎**：小改动走 `cursor`；只读并行调研走 `cursor-multitask`；
   需本地验证的实现走 `codex`；需独立审查走 `codex+reviewer-gate`。
   `route: codex` 默认 `engine: codex-cli`。派发前运行 `which codex` 验证本机 Codex CLI 可用；
   不可用时先报告用户并请求是否降级为 `engine: cursor-subagent`，禁止静默换引擎。
   模型默认从 `risk_level` 派生：low → fast、medium → standard、high → high；
   `type: refactor | research` 上调一档。只有需要精确控制时才写
   `model_override.executor / model_override.reviewer`。
   涉及 auth/payment/data/deployment/shared contract 时 `risk_level` 升 medium 以上、
   `gate_required: human`、`isolation` 至少 branch；与其他写任务并行同一 repo 时 `isolation: worktree`。
   `gate_required: reviewer` 时 reviewer 必须尽量使用不同模型家族；无法满足时在 review packet
   标注 `same-family-review: true` 并加重 human gate。
   完整规则见 `templates/agentpilot/task-package.md` 注释。
4. **派发**：话术：
   ```text
   请按 tasks/<task_id>.md 的任务包执行：
   只修改 scope.allow 内的文件，不得触碰 scope.deny；
   完成后逐条回报 acceptance 的执行结果（贴命令原始输出）。
   如果 engine=codex-cli，实际执行命令示例：
   codex exec -C <repo> --sandbox workspace-write "按 tasks/<task_id>.md 的任务包执行"
   ```
5. **汇总等 human gate**：逐条核对证据与 scope 边界，汇总给用户并提示抽查。

硬边界：merge 与高风险判定永远留给人；不修改 scope 外文件；字段与枚举以模板为准，不新造。
EOF
  echo "生成: $RULE_FILE"
fi
fi

if [ "$INSTALL_SKILL" -eq 1 ]; then
  SKILL_DIR="$HOME/.cursor/skills/agentpilot"
  ensure_dir "$SKILL_DIR"
  copy_file "$REPO_DIR/skills/agentpilot/SKILL.md" "$SKILL_DIR/SKILL.md"
fi

echo ""
echo "== 安装摘要"
if [ "$SKILL_ONLY" -eq 0 ]; then
  echo "  任务包目录:   $PROJECT/tasks/"
  echo "  留档目录:     $PROJECT/runs/"
  echo "  协议模板:     $PROJECT/templates/agentpilot/"
  echo "  Cursor 规则:  $RULE_FILE"
fi
if [ "$INSTALL_SKILL" -eq 1 ]; then
  echo "  Skill:        $HOME/.cursor/skills/agentpilot/SKILL.md"
fi
echo ""
echo "== 下一步"
if [ "$INSTALL_SKILL" -eq 1 ]; then
  echo "  1. 新开 Cursor 会话使 skill 生效；提出开发/修复需求即可触发 Coordinator。"
fi
if [ "$SKILL_ONLY" -eq 0 ]; then
  echo "  2. 在 Cursor 中打开该项目，对 Agent 直接说需求即可触发 Coordinator 行为。"
  echo "  3. 30 秒上手见 QUICKSTART.md；完整手册见 docs/。"
elif [ "$SKILL_ONLY" -eq 1 ]; then
  echo "  2. 在具体项目里再运行 ./install.sh /path/to/project 挂载 tasks/ 与模板。"
  echo "  3. 30 秒上手见 QUICKSTART.md；完整手册见 docs/。"
fi
