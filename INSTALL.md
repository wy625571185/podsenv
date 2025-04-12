# podsenv 安装指南

本文档提供了详细的 podsenv 安装和配置说明。

## 目录

- [使用 Homebrew 安装](#使用-homebrew-安装)
- [手动安装](#手动安装)
- [验证安装](#验证安装)
- [配置 Shell 环境](#配置-shell-环境)
- [卸载说明](#卸载说明)

## 使用 Homebrew 安装

使用 Homebrew 是在 macOS 上安装 podsenv 的最简单方法。

```bash
brew install podsenv
```

安装完成后，Homebrew 会自动将必要的路径添加到你的 PATH 环境变量中。

## 手动安装

如果你不使用 Homebrew，或者想要更多控制，可以手动安装 podsenv。

### 步骤 1: 下载源代码

```bash
git clone https://github.com/wy625571185/podsenv.git
cd podsenv
```

### 步骤 2: 运行安装脚本

```bash
./install.sh $(pwd)
```

安装脚本会将 podsenv 安装到 `~/.podsenv` 目录，并尝试更新你的 shell 配置文件。

## 验证安装

安装完成后，重新打开终端或重新加载 shell 配置：

```bash
source ~/.bashrc  # 或 ~/.zshrc，取决于你使用的 shell
```

然后验证 podsenv 是否正确安装：

```bash
podsenv --version
```

## 配置 Shell 环境

podsenv 需要将其 bin 和 shims 目录添加到你的 PATH 环境变量中。安装脚本会尝试自动完成这一步，但如果你需要手动配置，请将以下内容添加到你的 shell 配置文件（如 `~/.bashrc`、`~/.zshrc` 或 `~/.profile`）：

```bash
export PODSENV_ROOT="$HOME/.podsenv"
export PATH="$PODSENV_ROOT/shims:$PODSENV_ROOT/bin:$PATH"
```

### Bash 自动补全

如果你使用 Bash，可以启用命令自动补全功能：

```bash
echo 'source "$PODSENV_ROOT/completions/podsenv.bash"' >> ~/.bashrc
```

### Zsh 自动补全

如果你使用 Zsh，可以启用命令自动补全功能：

```bash
echo 'source "$PODSENV_ROOT/completions/podsenv.zsh"' >> ~/.zshrc
```

## 卸载说明

### 使用 Homebrew 卸载

如果你是通过 Homebrew 安装的，可以使用以下命令卸载：

```bash
brew uninstall podsenv
```

### 手动卸载

如果你是手动安装的，可以使用以下命令卸载：

```bash
~/.podsenv/uninstall.sh
```

卸载脚本会删除 `~/.podsenv` 目录，并尝试从你的 shell 配置文件中删除 podsenv 相关的配置。

### 手动清理

如果自动卸载不完整，你可能需要手动从 shell 配置文件中删除以下内容：

```bash
export PODSENV_ROOT="$HOME/.podsenv"
export PATH="$PODSENV_ROOT/shims:$PODSENV_ROOT/bin:$PATH"
```

以及任何与 podsenv 相关的自动补全配置。
