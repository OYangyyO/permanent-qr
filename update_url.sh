#!/bin/bash
# 用法: bash ~/permanent-qr/update_url.sh <新URL>
# 需要设置环境变量: export GITHUB_TOKEN=<你的token>
set -e

NEW_URL="$1"
if [ -z "$NEW_URL" ]; then
  echo "用法: bash $0 <新URL>"
  exit 1
fi

# Token 从 ~/.github_token 文件读取（安全，不写在脚本里）
TOKEN_FILE="$HOME/.github_token"
if [ -z "$GITHUB_TOKEN" ]; then
  if [ -f "$TOKEN_FILE" ]; then
    GITHUB_TOKEN=$(cat "$TOKEN_FILE")
  else
    echo "❌ 未找到 GitHub Token，请执行:"
    echo "   echo '你的token' > ~/.github_token"
    exit 1
  fi
fi

REMOTE="https://OYangyyO:${GITHUB_TOKEN}@github.com/OYangyyO/permanent-qr.git"

cd ~/permanent-qr
git pull -q --rebase "$REMOTE" main 2>/dev/null || true

echo "$NEW_URL" > url.txt

if git diff --quiet url.txt; then
  echo "ℹ️  URL 未变化: $NEW_URL"
  exit 0
fi

git add url.txt
git commit -qm "update url: $NEW_URL"
git push -q "$REMOTE" main

echo "✅ 已更新跳转目标: $NEW_URL"
echo "   永久二维码 URL: https://oyangyyo.github.io/permanent-qr/"
echo "   GitHub Pages 大约 5~30 秒后生效"
