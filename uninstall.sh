#!/usr/bin/env bash
# podsenv-uninstall.sh - podsenv卸载脚本

set -e

# 默认安装目录
if [ -z "${PODSENV_ROOT}" ]; then
  PODSENV_ROOT="${HOME}/.podsenv"
fi

# 显示信息
info() {
  echo "podsenv: $1"
}

# 删除podsenv目录
remove_podsenv_directory() {
  if [ -d "${PODSENV_ROOT}" ]; then
    info "删除 ${PODSENV_ROOT} 目录..."
    rm -rf "${PODSENV_ROOT}"
    info "podsenv目录已删除"
  else
    info "${PODSENV_ROOT} 目录不存在，无需删除"
  fi
}

# 清理shell配置
clean_shell_config() {
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
      info "无法自动清理shell配置，请手动从您的shell配置文件中删除podsenv相关配置"
      return
      ;;
  esac
  
  # 检查配置文件是否存在
  if [ ! -f "$shell_config" ]; then
    info "无法找到shell配置文件 $shell_config，请手动检查并删除podsenv相关配置"
    return
  fi
  
  # 检查是否包含podsenv配置
  if grep -q "PODSENV_ROOT" "$shell_config"; then
    info "从 $shell_config 中删除podsenv配置..."
    
    # 创建临时文件
    local temp_file=$(mktemp)
    
    # 过滤掉podsenv配置
    grep -v "podsenv配置" "$shell_config" | grep -v "PODSENV_ROOT" | grep -v "podsenv/shims" > "$temp_file"
    
    # 替换原文件
    mv "$temp_file" "$shell_config"
    
    info "已从shell配置中删除podsenv配置"
    info "请重新打开终端或运行 'source $shell_config' 使配置生效"
  else
    info "shell配置中未找到podsenv配置，无需清理"
  fi
}

# 主卸载流程
main() {
  info "开始卸载podsenv..."
  
  # 删除podsenv目录
  remove_podsenv_directory
  
  # 清理shell配置
  clean_shell_config
  
  info "podsenv卸载成功!"
  info "请重新打开终端或重新加载shell配置使更改生效"
}

# 执行卸载
main

exit 0
