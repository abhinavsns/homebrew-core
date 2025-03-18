class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://docs.astral.sh/uv/"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.6.8.tar.gz"
  sha256 "685bbf5152349c9236acd3cfce047ca4d0c1e7cb0ed1ce2a38670b9b93ff3809"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c830f4c75f5b029d9da5e8cc63920a0bc702f12740b4ecf8042b08385c10db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e563276fd932e154ba95ad86c1c5ae98dc10fa343ccad58e5872c6951cfa8e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f529608fc1703e2febfbb76446cd34bbc5645585ad5c2d2abfe3b8686b0317ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5ce0e4c9411131306073307baaada5a8d3d070d72f86e6e3a9342ee3bb45ab3"
    sha256 cellar: :any_skip_relocation, ventura:       "447f75d82cadc037abb261ae848a16ca71be5626623b8dfd5db6e1f86b3b85b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5a1f9f5edd36d43b45d5b7b9e548dac224739f29e8babf8de359ec0010eba05"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
    generate_completions_from_executable(bin/"uvx", "--generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~REQUIREMENTS
      requests
    REQUIREMENTS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
