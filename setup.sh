#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
agent_dir="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
pi_bin="${PI_BIN:-pi}"

"$pi_bin" --version >/dev/null
mkdir -p "$agent_dir"

"$pi_bin" install npm:pi-subagents
"$pi_bin" install "$repo"

node - "$agent_dir/settings.json" <<'EOF'
const fs = require("fs");
const file = process.argv[2];
const settings = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file, "utf8")) : {};
const tools = settings.defaultTools ?? [];
if (!tools.includes("+codemode") && !tools.includes("codemode")) {
  settings.defaultTools = [...tools, "+codemode"];
}
fs.writeFileSync(file, JSON.stringify(settings, null, 2) + "\n");
EOF

target="$agent_dir/APPEND_SYSTEM.md"
if [ -e "$target" ] && [ ! -L "$target" ]; then
  mv "$target" "$target.bak"
  echo "Moved existing $target to $target.bak"
fi
ln -sfn "$repo/APPEND_SYSTEM.md" "$target"

echo "Done. Start pi, run /login for each provider you use, then try /ship or /rca."
