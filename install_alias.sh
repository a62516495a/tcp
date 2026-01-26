#!/usr/bin/env bash
# 一键安装 net-tcp-tune.sh 并创建 bbr 别名（存在时强制覆盖）
# 支持 bash 和 zsh 自动适配配置文件

SCRIPT_URL="https://raw.githubusercontent.com/a62516495a/tcp/refs/heads/master/net-tcp-tune.sh"
SCRIPT_NAME="net-tcp-tune.sh"
BIN_DIR="/usr/local/bin/tcp"
SCRIPT_PATH="$BIN_DIR/$SCRIPT_NAME"

# 创建 bin 目录（如果不存在）
mkdir -p "$BIN_DIR"

echo "正在下载脚本..."

# 下载（优先用 curl，其次 wget）
if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$SCRIPT_PATH" "$SCRIPT_URL"
elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$SCRIPT_PATH" "$SCRIPT_URL"
else
    echo "错误：需要 curl 或 wget 来下载脚本，请先安装其中之一"
    exit 1
fi

# 检查下载是否成功
if [ ! -s "$SCRIPT_PATH" ]; then
    echo "错误：脚本下载失败或文件为空"
    exit 1
fi

# 赋予执行权限
chmod +x "$SCRIPT_PATH"

echo "脚本已保存到：$SCRIPT_PATH 并已赋予执行权限"

# 确定当前 shell 和对应的 rc 文件
if [ -n "$ZSH_VERSION" ]; then
    RC_FILE="$HOME/.zshrc"
    SHELL_NAME="zsh"
    SOURCE_CMD="source ~/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    RC_FILE="$HOME/.bashrc"
    SHELL_NAME="bash"
    SOURCE_CMD="source ~/.bashrc"
else
    echo "警告：无法自动识别 shell 类型（非 bash/zsh）"
    echo "请手动添加以下 alias 到你的 shell 配置文件："
    echo " alias bbr='$SCRIPT_PATH'"
    RC_FILE=""
    SOURCE_CMD=""
fi

# alias 内容
ALIAS_LINE="alias bbr='$SCRIPT_PATH'"

if [ -n "$RC_FILE" ]; then
    # 先尝试删除已存在的 bbr alias（各种常见写法都删掉）
    if grep -q "alias[[:space:]]\+bbr" "$RC_FILE" 2>/dev/null; then
        echo "检测到旧的 bbr alias，正在删除旧定义..."
        # 使用 sed 删除包含 alias bbr 的整行（兼容常见空格写法）
        sed -i.bak '/^[[:space:]]*alias[[:space:]]\+bbr[[:space:]]*=/d' "$RC_FILE"
        # 如果有注释行 # TCP 优化脚本快捷方式 也一起清理（可选）
        sed -i.bak '/# TCP 优化脚本快捷方式/d' "$RC_FILE"
        echo "旧的 bbr alias 已清理"
    fi

    # 重新写入
    echo "" >> "$RC_FILE"
    echo "# TCP 优化脚本快捷方式" >> "$RC_FILE"
    echo "$ALIAS_LINE" >> "$RC_FILE"

    echo "已强制更新 alias bbr 到 $RC_FILE"
    echo "请在当前终端手动运行以下命令使 alias 立即生效："
    echo "$SOURCE_CMD"
    echo ""
    echo "之后新打开的终端会自动加载"
else
    echo "无法自动添加 alias，请手动操作："
    echo " 1. 打开你的 shell 配置文件（通常是 ~/.bashrc 或 ~/.zshrc）"
    echo " 2. 添加或替换为以下内容："
    echo "    $ALIAS_LINE"
    echo " 3. 保存后运行：source 你的配置文件路径"
fi

echo ""
echo "安装完成！"
echo "运行方式："
echo "  bbr          # 执行 TCP 优化脚本（新终端或 source 后生效）"
echo "  $SCRIPT_PATH # 任何时候直接运行都有效"
echo ""
echo "如果 'bbr' 命令仍无效，请尝试："
echo "$SOURCE_CMD"
echo "或直接重开一个新终端窗口/标签页"