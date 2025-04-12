# podsenv 使用文档

podsenv 是一个用于管理 CocoaPods 版本的工具，它允许你在同一系统上安装和使用多个版本的 CocoaPods，并在不同项目之间轻松切换。

## 目录

- [安装](#安装)
- [卸载](#卸载)
- [基本用法](#基本用法)
- [命令详解](#命令详解)
- [配置文件](#配置文件)
- [常见问题](#常见问题)
- [贡献指南](#贡献指南)
- [许可证](#许可证)

## 安装

### 前提条件

- macOS 系统
- Ruby 环境（macOS 自带）
- Homebrew（推荐，但不是必需的）

### 使用 Homebrew 安装（推荐）

```bash
brew install podsenv
```

### 手动安装

1. 克隆仓库：

```bash
git clone https://github.com/wy625571185/podsenv.git
cd podsenv
```

2. 运行安装脚本：

```bash
./install.sh $(pwd)
```

3. 重新加载 shell 配置：

```bash
source ~/.bashrc  # 或 ~/.zshrc，取决于你使用的 shell
```

4. 验证安装：

```bash
podsenv --version
```

## 卸载

### 使用 Homebrew 卸载

```bash
brew uninstall podsenv
```

### 手动卸载

1. 运行卸载脚本：

```bash
~/.podsenv/uninstall.sh
```

2. 重新加载 shell 配置：

```bash
source ~/.bashrc  # 或 ~/.zshrc，取决于你使用的 shell
```

## 基本用法

### 安装 CocoaPods 版本

```bash
podsenv install 0.0.1
```

### 设置全局默认版本

```bash
podsenv global 0.0.1
```

### 设置项目特定版本

```bash
cd your_project
podsenv local 0.0.1
```

### 查看当前使用的版本

```bash
podsenv version
```

### 列出所有已安装的版本

```bash
podsenv versions
```

### 使用特定版本执行命令

```bash
podsenv exec 0.0.1 pod install
```

## 命令详解

### version

显示当前使用的 CocoaPods 版本。

```bash
podsenv version
```

输出示例：
```
1.10.1 (set by /Users/username/.podsenv/version)
```

### versions

列出所有已安装的 CocoaPods 版本，并标记当前使用的版本。

```bash
podsenv versions
```

输出示例：
```
* 1.10.1 (当前版本)
  1.11.3
  1.9.3
```

### install

安装指定版本的 CocoaPods。

```bash
podsenv install <version>
```

选项：
- `--skip-existing`: 如果版本已安装，则跳过安装

示例：
```bash
podsenv install 0.0.1
podsenv install --skip-existing 0.0.3
```

### uninstall

卸载指定版本的 CocoaPods。

```bash
podsenv uninstall <version>
```

选项：
- `--force`: 强制卸载，即使是当前使用的版本

示例：
```bash
podsenv uninstall 0.0.3
podsenv uninstall --force 0.0.1
```

### global

设置全局默认的 CocoaPods 版本。

```bash
podsenv global <version>
```

示例：
```bash
podsenv global 0.0.1
```

### local

设置当前目录（项目）使用的 CocoaPods 版本。

```bash
podsenv local <version>
```

选项：
- `--unset`: 取消当前目录的版本设置，使用全局版本

示例：
```bash
podsenv local 0.0.1
podsenv local --unset
```

### which

显示当前使用的 pod 命令的路径。

```bash
podsenv which
```

输出示例：
```
/Users/username/.podsenv/versions/1.10.1/bin/pod
```

### rehash

刷新 shims，在安装新版本后需要执行此命令。

```bash
podsenv rehash
```

### exec

使用指定版本的 CocoaPods 执行命令。

```bash
podsenv exec <version> <command> [args...]
```

示例：
```bash
podsenv exec 0.0.1 pod install
podsenv exec 0.0.3 pod update AFNetworking
```

### help

显示帮助信息。

```bash
podsenv help
```

## 配置文件

podsenv 使用以下配置文件：

### 全局版本文件

`~/.podsenv/version` 存储全局默认的 CocoaPods 版本。

### 本地版本文件

`.podsenv-version` 存储在项目目录中，指定该项目使用的 CocoaPods 版本。

## 常见问题

### 安装后找不到 podsenv 命令

确保 `~/.podsenv/bin` 已添加到你的 PATH 环境变量中。检查你的 shell 配置文件（如 `~/.bashrc` 或 `~/.zshrc`）是否包含以下内容：

```bash
export PODSENV_ROOT="$HOME/.podsenv"
export PATH="$PODSENV_ROOT/shims:$PODSENV_ROOT/bin:$PATH"
```

### 安装 CocoaPods 版本失败

可能是网络问题或 Ruby 环境问题。尝试以下解决方案：

1. 检查网络连接
2. 确保 Ruby 和 RubyGems 是最新版本
3. 尝试使用 `gem install cocoapods -v <version>` 直接安装，看是否有更详细的错误信息

### pod 命令不使用正确的版本

执行 `podsenv rehash` 刷新 shims，然后重新尝试。

## 贡献指南

我们欢迎任何形式的贡献！如果你想为 podsenv 做出贡献，请遵循以下步骤：

1. Fork 仓库
2. 创建你的特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交你的更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启一个 Pull Request

## 许可证

podsenv 使用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。
