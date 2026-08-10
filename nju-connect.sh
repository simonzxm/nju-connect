#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

BIN="${BIN:-./bin/zju-connect}"
VERSION="${ZJU_CONNECT_VERSION:-v1.3.0}"

if [ ! -x "$BIN" ]; then
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"
  case "$os" in
    darwin) ;;
    linux) ;;
    mingw*|msys*|cygwin*) os=windows ;;
    *) echo "不支持的平台: $os" >&2; exit 1 ;;
  esac
  case "$arch" in
    x86_64|amd64)  arch=amd64 ;;
    aarch64|arm64) arch=arm64 ;;
    i686|i386)     arch=386 ;;
    *) echo "不支持的架构: $arch" >&2; exit 1 ;;
  esac
  mkdir -p bin
  echo "下载 zju-connect ($os/$arch) ..."
  curl -fL -o /tmp/zju-connect.zip "https://github.com/Mythologyli/zju-connect/releases/download/${VERSION}/zju-connect-${os}-${arch}.zip"
  unzip -o /tmp/zju-connect.zip -d bin
  rm -f /tmp/zju-connect.zip
  chmod +x "$BIN" 2>/dev/null || true
  xattr -dr com.apple.quarantine "$BIN" 2>/dev/null || true
fi

case "${1:-}" in
  trust|untrust)
    [ -f client_data.json ] || { echo "未找到 client_data.json，请先运行 ./nju-connect.sh 完成首次登录。" >&2; exit 1; }
    exec "$BIN" -protocol atrust -server ztna.nju.edu.cn -port 443 \
      -client-data-file client_data.json "-$1-device"
    ;;
  *)
    if [ ! -f config.toml ]; then
      cp config.toml.example config.toml
      echo "已生成 config.toml，请填入学号/密码后重新运行 ./nju-connect.sh。" >&2
      exit 1
    fi
    exec "$BIN" -config config.toml "$@"
    ;;
esac
