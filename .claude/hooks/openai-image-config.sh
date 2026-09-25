#!/bin/sh
# 在会话开始时，用环境变量生成 openai-image 技能的 config.json。
# 云环境没有这个文件（它含密钥、被 .gitignore 忽略），技能又只读 config.json，
# 所以由云环境设置里的环境变量来提供：
#   OPENAI_IMAGE_API_KEY   必填；未设置时本脚本什么也不做（本地开发即如此）
#   OPENAI_IMAGE_BASE_URL  可选，默认 https://api.shuaiapi.com/v1
#   OPENAI_IMAGE_MODEL     可选，默认 gpt-image-2.5
# 每次都会覆盖写入，以便更换密钥后立即生效。
[ -n "${OPENAI_IMAGE_API_KEY:-}" ] || exit 0

root=${CLAUDE_PROJECT_DIR:-$(pwd)}

# Windows 上的 python3 可能是应用商店的占位程序，逐个试到能运行的为止
py=
for candidate in python3 python; do
  if "$candidate" -c "" >/dev/null 2>&1; then py=$candidate; break; fi
done
[ -n "$py" ] || { echo "openai-image: 找不到可用的 Python，跳过生成 config.json" >&2; exit 0; }

for dir in "$root/.claude/skills/openai-image" "$root/.agents/skills/openai-image"; do
  [ -d "$dir" ] || continue
  "$py" - "$dir/config.json" <<'PY' || echo "openai-image: 写入 $dir/config.json 失败" >&2
import json, os, sys
config = {
    "base_url": os.environ.get("OPENAI_IMAGE_BASE_URL") or "https://api.shuaiapi.com/v1",
    "api_key": os.environ["OPENAI_IMAGE_API_KEY"],
    "model": os.environ.get("OPENAI_IMAGE_MODEL") or "gpt-image-2.5",
}
with open(sys.argv[1], "w", encoding="utf-8") as f:
    json.dump(config, f, ensure_ascii=False, indent=2)
os.chmod(sys.argv[1], 0o600)
PY
done
exit 0
