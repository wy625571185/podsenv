# podsenv 命令补全 - Bash
# 将此文件保存为 podsenv.bash 并添加到 ~/.podsenv/completions/ 目录

_podsenv() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # 主命令列表
  opts="version versions install uninstall global local which rehash exec help"
  
  # 根据前一个参数提供不同的补全
  case "${prev}" in
    podsenv)
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return 0
      ;;
    install)
      # 这里可以添加可用的CocoaPods版本列表，但需要从远程获取
      COMPREPLY=( $(compgen -W "--skip-existing" -- ${cur}) )
      return 0
      ;;
    uninstall|global|local|exec)
      # 提供已安装的版本列表
      local versions=$(ls -1 "${PODSENV_ROOT}/versions" 2>/dev/null || echo "")
      COMPREPLY=( $(compgen -W "${versions}" -- ${cur}) )
      return 0
      ;;
    local)
      COMPREPLY=( $(compgen -W "--unset" -- ${cur}) )
      return 0
      ;;
    *)
      ;;
  esac
  
  # 如果是第一个参数，提供命令列表
  if [[ ${COMP_CWORD} -eq 1 ]] ; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
  fi
}

complete -F _podsenv podsenv
