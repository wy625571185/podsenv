class Podsenv < Formula
  desc "CocoaPods版本管理工具"
  homepage "https://github.com/wy625571185/podsenv"
  url "https://github.com/wy625571185/podsenv/archive/v0.0.1.tar.gz"
  sha256 "这里需要替换为实际的SHA256值"
  license "MIT"
  head "https://github.com/wy625571185/podsenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "这里需要替换为实际的SHA256值"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "这里需要替换为实际的SHA256值"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "这里需要替换为实际的SHA256值"
    sha256 cellar: :any_skip_relocation, sonoma: "这里需要替换为实际的SHA256值"
    sha256 cellar: :any_skip_relocation, ventura: "这里需要替换为实际的SHA256值"
    sha256 cellar: :any_skip_relocation, monterey: "这里需要替换为实际的SHA256值"
  end

  depends_on "ruby" => :recommended

  def install
    # 创建必要的目录
    libexec.install Dir["*"]
    
    # 安装主程序到bin目录
    bin.install_symlink libexec/"bin/podsenv"
    
    # 创建completions目录
    bash_completion.install libexec/"completions/podsenv.bash" => "podsenv"
    zsh_completion.install libexec/"completions/podsenv.zsh" => "_podsenv"
    
    # 创建podsenv目录结构
    (prefix/"podsenv").install_symlink libexec/"libexec"
    (prefix/"podsenv/completions").mkpath
    (prefix/"podsenv/shims").mkpath
    (prefix/"podsenv/versions").mkpath
  end

  def post_install
    # 确保shims目录存在
    (prefix/"podsenv/shims").mkpath
    
    # 创建pod命令的shim
    (prefix/"podsenv/shims/pod").write <<~EOS
      #!/usr/bin/env bash
      set -e
      export PODSENV_ROOT="#{prefix}/podsenv"
      exec "#{prefix}/podsenv/libexec/podsenv-shim" pod "$@"
    EOS
    
    # 设置执行权限
    chmod 0755, prefix/"podsenv/shims/pod"
  end

  def caveats
    <<~EOS
      要启用podsenv，请将以下内容添加到您的shell配置文件中（~/.bashrc，~/.zshrc等）：
        export PODSENV_ROOT="#{prefix}/podsenv"
        export PATH="$PODSENV_ROOT/shims:$PODSENV_ROOT/bin:$PATH"
      
      然后，您可以安装CocoaPods的不同版本：
        podsenv install 0.0.1
      
      并设置全局或项目特定的版本：
        podsenv global 0.0.1
        podsenv local 0.0.1
    EOS
  end

  test do
    # 测试podsenv命令是否可用
    assert_match "podsenv: CocoaPods版本管理工具", shell_output("#{bin}/podsenv --help")
    
    # 测试版本列表功能
    system "#{bin}/podsenv", "versions"
    
    # 测试安装功能（这里只测试命令是否存在，不实际安装）
    assert shell_output("#{bin}/podsenv install --help").include?("安装指定版本的CocoaPods")
  end
end
