#!/usr/bin/env bash
# test_podsenv.sh - podsenv本地测试脚本

set -e

# 显示信息
info() {
  echo "测试: $1"
}

error() {
  echo "错误: $1" >&2
  exit 1
}

# 创建测试目录
TEST_DIR="/tmp/podsenv_test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# 设置测试环境
export PODSENV_ROOT="$TEST_DIR/.podsenv"
mkdir -p "$PODSENV_ROOT"

# 复制podsenv文件到测试目录
info "准备测试环境..."
cp -r /home/ubuntu/podsenv_project/bin "$PODSENV_ROOT/"
cp -r /home/ubuntu/podsenv_project/libexec "$PODSENV_ROOT/"
cp -r /home/ubuntu/podsenv_project/completions "$PODSENV_ROOT/"
mkdir -p "$PODSENV_ROOT/shims" "$PODSENV_ROOT/versions"

# 设置执行权限
chmod +x "$PODSENV_ROOT/bin/podsenv"
chmod +x "$PODSENV_ROOT/libexec/podsenv-shim"
chmod +x "$PODSENV_ROOT/libexec/podsenv-exec"

# 创建pod命令的shim
cat > "$PODSENV_ROOT/shims/pod" <<EOF
#!/usr/bin/env bash
set -e
export PODSENV_ROOT="$PODSENV_ROOT"
exec "$PODSENV_ROOT/libexec/podsenv-shim" pod "\$@"
EOF
chmod +x "$PODSENV_ROOT/shims/pod"

# 添加到PATH
export PATH="$PODSENV_ROOT/shims:$PODSENV_ROOT/bin:$PATH"

# 测试帮助命令
info "测试帮助命令..."
podsenv help
if [ $? -ne 0 ]; then
  error "帮助命令测试失败"
fi
info "帮助命令测试通过"

# 测试版本列表
info "测试版本列表命令..."
podsenv versions
if [ $? -ne 0 ]; then
  error "版本列表命令测试失败"
fi
info "版本列表命令测试通过"

# 测试安装命令（模拟安装）
info "测试安装命令（模拟）..."
# 创建一个模拟版本目录
mkdir -p "$PODSENV_ROOT/versions/1.10.1/bin"
echo "#!/bin/bash" > "$PODSENV_ROOT/versions/1.10.1/bin/pod"
echo "echo 'CocoaPods 1.10.1'" >> "$PODSENV_ROOT/versions/1.10.1/bin/pod"
chmod +x "$PODSENV_ROOT/versions/1.10.1/bin/pod"

# 测试版本列表是否显示模拟版本
podsenv versions | grep "1.10.1"
if [ $? -ne 0 ]; then
  error "无法在版本列表中找到模拟版本"
fi
info "安装命令测试通过"

# 测试全局版本设置
info "测试全局版本设置..."
podsenv global 1.10.1
if [ $? -ne 0 ]; then
  error "全局版本设置测试失败"
fi

# 验证全局版本设置
cat "$PODSENV_ROOT/version" | grep "1.10.1"
if [ $? -ne 0 ]; then
  error "全局版本设置验证失败"
fi
info "全局版本设置测试通过"

# 测试本地版本设置
info "测试本地版本设置..."
mkdir -p "$TEST_DIR/project1"
cd "$TEST_DIR/project1"
podsenv local 1.10.1
if [ $? -ne 0 ]; then
  error "本地版本设置测试失败"
fi

# 验证本地版本设置
cat ".podsenv-version" | grep "1.10.1"
if [ $? -ne 0 ]; then
  error "本地版本设置验证失败"
fi
info "本地版本设置测试通过"

# 测试which命令
info "测试which命令..."
podsenv which
if [ $? -ne 0 ]; then
  error "which命令测试失败"
fi
info "which命令测试通过"

# 测试exec命令
info "测试exec命令..."
podsenv exec 1.10.1 pod
if [ $? -ne 0 ]; then
  error "exec命令测试失败"
fi
info "exec命令测试通过"

# 测试rehash命令
info "测试rehash命令..."
podsenv rehash
if [ $? -ne 0 ]; then
  error "rehash命令测试失败"
fi
info "rehash命令测试通过"

# 测试卸载命令
info "测试卸载命令..."
cd "$TEST_DIR"
podsenv uninstall --force 1.10.1
if [ $? -ne 0 ]; then
  error "卸载命令测试失败"
fi

# 验证卸载结果
if [ -d "$PODSENV_ROOT/versions/1.10.1" ]; then
  error "卸载命令验证失败，版本目录仍然存在"
fi
info "卸载命令测试通过"

# 清理测试环境
info "清理测试环境..."
rm -rf "$TEST_DIR"
info "测试环境已清理"

info "所有测试通过！podsenv工具功能正常。"
exit 0
