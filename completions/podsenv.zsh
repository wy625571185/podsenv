# podsenv 命令补全 - Zsh
# 将此文件保存为 podsenv.zsh 并添加到 ~/.podsenv/completions/ 目录

if [[ ! -o interactive ]]; then
    return
fi

compctl -K _podsenv podsenv

_podsenv() {
  local words completions
  read -cA words
  
  if [ "${#words}" -eq 2 ]; then
    completions="version versions install uninstall global local which rehash exec help"
  elif [ "${#words}" -eq 3 ]; then
    case "${words[2]}" in
      install)
        completions="--skip-existing"
        ;;
      uninstall)
        completions="--force $(ls -1 "${PODSENV_ROOT}/versions" 2>/dev/null)"
        ;;
      global|local|exec)
        completions="$(ls -1 "${PODSENV_ROOT}/versions" 2>/dev/null)"
        ;;
      local)
        completions="--unset $(ls -1 "${PODSENV_ROOT}/versions" 2>/dev/null)"
        ;;
      *)
        completions=""
        ;;
    esac
  fi
  
  reply=( "${(ps:\n:)completions}" )
}
