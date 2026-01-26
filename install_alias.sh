#!/usr/bin/env bash

set -e

ALIAS_LINE="alias bbr='sudo bash <(curl -fsSL https://raw.githubusercontent.com/a62516495a/tcp/refs/heads/master/net-tcp-tune.sh)'"
BASHRC="$HOME/.bashrc"

# 判断是否已存在
if grep -Fxq "$ALIAS_LINE" "$BASHRC"; then
    echo "alias bbr 已存在于 ~/.bashrc，无需重复写入。"
else
    echo "" >> "$BASHRC"
    echo "# BBR 启动别名" >> "$BASHRC"
    echo "$ALIAS_LINE" >> "$BASHRC"
    echo "alias bbr 已成功写入 ~/.bashrc"
fi

echo
echo "请手动执行以下命令使其生效："
echo
echo "  source ~/.bashrc"
echo
echo "之后即可直接使用："
echo
echo "  bbr"
