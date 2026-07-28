#!/bin/bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

# 只加载函数，不执行交互式 main。
sed '/^# 运行主函数/,$d' "$REPO_DIR/panbox-autosave.sh" > "$TEST_DIR/subject.sh"
source "$TEST_DIR/subject.sh"

declare -F write_logging_compose_override >/dev/null
declare -F run_compose >/dev/null

INSTALL_DIR="$TEST_DIR/install"
mkdir -p "$INSTALL_DIR" "$TEST_DIR/bin"
cp "$REPO_DIR/docker-compose.yml" "$INSTALL_DIR/docker-compose.yml"
printf '\n# user-custom-setting\n' >> "$INSTALL_DIR/docker-compose.yml"
printf 'services:\n  panbox-autosave:\n    environment:\n      USER_OVERRIDE: "kept"\n' > "$INSTALL_DIR/docker-compose.override.yml"

BASE_BEFORE="$(cksum "$INSTALL_DIR/docker-compose.yml")"
USER_OVERRIDE_BEFORE="$(cksum "$INSTALL_DIR/docker-compose.override.yml")"
export DOCKER_CALL_LOG="$TEST_DIR/docker-calls.log"

cat > "$TEST_DIR/bin/docker" <<'MOCK'
#!/bin/bash
printf '%s\n' "$*" >> "$DOCKER_CALL_LOG"
MOCK
chmod +x "$TEST_DIR/bin/docker"
PATH="$TEST_DIR/bin:$PATH"
DOCKER_COMPOSE_CMD="docker compose"
show_access_info() { :; }

update_panbox

LOGGING_OVERRIDE="$INSTALL_DIR/docker-compose.logging.yml"
test -f "$LOGGING_OVERRIDE"
test "$(grep -c 'max-size: "10m"' "$LOGGING_OVERRIDE")" -eq 2
test "$(grep -c 'max-file: "3"' "$LOGGING_OVERRIDE")" -eq 2
test "$(cksum "$INSTALL_DIR/docker-compose.yml")" = "$BASE_BEFORE"
test "$(cksum "$INSTALL_DIR/docker-compose.override.yml")" = "$USER_OVERRIDE_BEFORE"

grep -F "compose -f $INSTALL_DIR/docker-compose.yml -f $INSTALL_DIR/docker-compose.override.yml -f $LOGGING_OVERRIDE config" "$DOCKER_CALL_LOG" >/dev/null
grep -F "compose -f $INSTALL_DIR/docker-compose.yml -f $INSTALL_DIR/docker-compose.override.yml -f $LOGGING_OVERRIDE down --remove-orphans -t 60" "$DOCKER_CALL_LOG" >/dev/null
grep -F "compose -f $INSTALL_DIR/docker-compose.yml -f $INSTALL_DIR/docker-compose.override.yml -f $LOGGING_OVERRIDE up -d --remove-orphans" "$DOCKER_CALL_LOG" >/dev/null
CONFIG_LINE="$(grep -nF " $LOGGING_OVERRIDE config" "$DOCKER_CALL_LOG" | head -1 | cut -d: -f1)"
DOWN_LINE="$(grep -nF " $LOGGING_OVERRIDE down --remove-orphans -t 60" "$DOCKER_CALL_LOG" | head -1 | cut -d: -f1)"
UP_LINE="$(grep -nF " $LOGGING_OVERRIDE up -d --remove-orphans" "$DOCKER_CALL_LOG" | head -1 | cut -d: -f1)"
test "$CONFIG_LINE" -lt "$DOWN_LINE"
test "$DOWN_LINE" -lt "$UP_LINE"
grep -F '/opt/panbox-autosave/postgres:/var/lib/postgresql/data' "$INSTALL_DIR/docker-compose.yml" >/dev/null
if grep -E -- '--volumes|(^| )-v( |$)|system prune' "$DOCKER_CALL_LOG" >/dev/null; then
    echo "update must not delete volumes or prune Docker data" >&2
    exit 1
fi

FIRST_OVERRIDE="$(cksum "$LOGGING_OVERRIDE")"
: > "$DOCKER_CALL_LOG"
update_panbox
test "$(cksum "$LOGGING_OVERRIDE")" = "$FIRST_OVERRIDE"
grep -F "compose -f $INSTALL_DIR/docker-compose.yml -f $INSTALL_DIR/docker-compose.override.yml -f $LOGGING_OVERRIDE up -d --remove-orphans" "$DOCKER_CALL_LOG" >/dev/null

echo "update logging regression: PASS"
