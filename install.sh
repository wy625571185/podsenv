#!/usr/bin/env bash
# podsenv-install.sh - podsenv安装脚本

set -e

# 默认安装目录
if [ -z "${PODSENV_ROOT}" ]; then
  PODSENV_ROOT="${HOME}/.podsenv"
fi

# 显示错误信息
error() {
  echo "安装错误: $1" >&2
  exit 1
}

# 显示信息
info() {
  echo "podsenv: $1"
}

# 创建目录结构
create_directories() {
  mkdir -p "${PODSENV_ROOT}/"{bin,libexec,completions,shims,versions}
}

# 复制文件
copy_files() {
  local source_dir="$1"
  
  # 复制主程序
  cp "${source_dir}/bin/podsenv" "${PODSENV_ROOT}/bin/"
  chmod +x "${PODSENV_ROOT}/bin/podsenv"
  
  # 复制libexec脚本
  cp "${source_dir}/libexec/podsenv-shim" "${PODSENV_ROOT}/libexec/"
  cp "${source_dir}/libexec/podsenv-exec" "${PODSENV_ROOT}/libexec/"
  chmod +x "${PODSENV_ROOT}/libexec/podsenv-shim" "${PODSENV_ROOT}/libexec/podsenv-exec"
  
  # 复制补全脚本
  if [ -f "${source_dir}/completions/podsenv.bash" ]; then
    cp "${source_dir}/completions/podsenv.bash" "${PODSENV_ROOT}/completions/"
  fi
  
  if [ -f "${source_dir}/completions/podsenv.zsh" ]; then
    cp "${source_dir}/completions/podsenv.zsh" "${PODSENV_ROOT}/completions/"
  fi
}

# 创建shim
create_shim() {
  cat > "${PODSENV_ROOT}/shims/pod" <<EOF
#!/usr/bin/env bash
set -e
export PODSENV_ROOT="${PODSENV_ROOT}"
exec "${PODSENV_ROOT}/libexec/podsenv-shim" pod "\$@"
EOF
  
  chmod +x "${PODSENV_ROOT}/shims/pod"
}

# 更新shell配置
update_shell_config() {
  local shell_config=""
  
  # 检测shell类型
  case "$SHELL" in
    */bash)
      shell_config="${HOME}/.bashrc"
      ;;
    */zsh)
      shell_config="${HOME}/.zshrc"
      ;;
    */fish)
      shell_config="${HOME}/.config/fish/config.fish"
      ;;
    *)
      info "无法自动更新shell配置，请手动添加以下内容到您的shell配置文件:"
      echo ""
      echo "export PODSENV_ROOT=\"${PODSENV_ROOT}\""
      echo "export PATH=\"\${PODSENV_ROOT}/shims:\${PODSENV_ROOT}/bin:\$PATH\""
      return
      ;;
  esac
  
  # 检查配置文件是否存在
  if [ ! -f "$shell_config" ]; then
    info "无法找到shell配置文件 $shell_config，请手动添加以下内容到您的shell配置文件:"
    echo ""
    echo "export PODSENV_ROOT=\"${PODSENV_ROOT}\""
    echo "export PATH=\"\${PODSENV_ROOT}/shims:\${PODSENV_ROOT}/bin:\$PATH\""
    return
  fi
  
  # 检查是否已经配置
  if grep -q "PODSENV_ROOT" "$shell_config"; then
    info "podsenv已经在shell配置中，无需更新"
    return
  fi
  
  # 添加配置
  cat >> "$shell_config" <<EOF

# podsenv配置
export PODSENV_ROOT="${PODSENV_ROOT}"
export PATH="\${PODSENV_ROOT}/shims:\${PODSENV_ROOT}/bin:\$PATH"
EOF
  
  info "已更新shell配置文件 $shell_config"
  info "请重新打开终端或运行 'source $shell_config' 使配置生效"
}

# 主安装流程
main() {
  local source_dir="$1"
  
  info "开始安装podsenv到 ${PODSENV_ROOT}"
  
  # 创建目录结构
  create_directories
  
  # 复制文件
  copy_files "$source_dir"
  
  # 创建shim
  create_shim
  
  # 更新shell配置
  update_shell_config
  
  info "podsenv安装成功!"
  info "请重新打开终端或运行 'source \$HOME/.bashrc' (或您的shell配置文件) 使配置生效"
  info "然后运行 'podsenv help' 查看使用帮助"
}

# 检查参数
if [ -z "$1" ]; then
  error "请指定源代码目录"
fi

# 执行安装
main "$1"

exit 0
