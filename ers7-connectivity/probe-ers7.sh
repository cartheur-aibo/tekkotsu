#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
usage: probe-ers7.sh ROBOT_IP [stock|tekkotsu|all]

Probe an ERS-7 over the network and report which layer is alive:

- stock MIND 2 reachability: ping + HTTP port 80
- Tekkotsu/Open-R reachability: ports 59001, 59010, 59011

Modes:
  stock     Check ping and HTTP only
  tekkotsu  Check ping and Tekkotsu/Open-R ports only
  all       Check everything (default)
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  usage
  exit 1
fi

ROBOT_IP="$1"
MODE="${2:-all}"

case "$MODE" in
  stock|tekkotsu|all) ;;
  *)
    echo "error: mode must be stock, tekkotsu, or all" >&2
    exit 1
    ;;
esac

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

headline() {
  printf '\n[%s]\n' "$1"
}

ok() {
  printf 'OK   %s\n' "$1"
}

warn() {
  printf 'WARN %s\n' "$1"
}

fail() {
  printf 'FAIL %s\n' "$1"
}

check_ping() {
  headline "Ping"
  if ping -c 1 -W 2 "$ROBOT_IP" >/dev/null 2>&1; then
    ok "ping to $ROBOT_IP succeeded"
    return 0
  fi

  fail "ping to $ROBOT_IP failed"
  return 1
}

check_http() {
  headline "HTTP 80"
  if ! have_cmd curl; then
    warn "curl not available; cannot test HTTP"
    return 0
  fi

  local headers
  if headers="$(curl -I --max-time 5 -s "http://$ROBOT_IP/")"; then
    ok "HTTP port 80 responded"
    printf '%s\n' "$headers" | sed -n '1,5p'
    return 0
  fi

  fail "HTTP port 80 did not respond"
  return 1
}

check_port() {
  local port="$1"
  local label="$2"

  if have_cmd nc; then
    if nc -vz -w 3 "$ROBOT_IP" "$port" >/dev/null 2>&1; then
      ok "$label port $port is open"
      return 0
    fi
    fail "$label port $port is closed or unreachable"
    return 1
  fi

  warn "nc not available; cannot test port $port"
  return 0
}

printf 'ERS-7 probe target: %s\n' "$ROBOT_IP"
printf 'Probe mode: %s\n' "$MODE"

ping_ok=0
if check_ping; then
  ping_ok=1
else
  warn "no network reachability yet; later checks may also fail"
fi

if [ "$MODE" = "stock" ] || [ "$MODE" = "all" ]; then
  check_http || true
fi

if [ "$MODE" = "tekkotsu" ] || [ "$MODE" = "all" ]; then
  headline "Tekkotsu/Open-R Ports"
  check_port 59001 "TCP gateway" || true
  check_port 59010 "Send string" || true
  check_port 59011 "Receive string" || true
fi

headline "Interpretation"
if [ "$ping_ok" -eq 0 ]; then
  warn "Robot is not reachable at the network layer yet."
  warn "Do not jump ahead to Tekkotsu gateway debugging."
  exit 1
fi

ok "Robot is reachable at the network layer."
warn "If HTTP 80 works, stock MIND 2 reachability is proven."
warn "If 59001/59010/59011 are still closed, Tekkotsu gateway is not yet proven."
