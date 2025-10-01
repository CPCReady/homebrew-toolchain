class Toolchain < Formula
  desc "CPCReady toolchain with C/C++ utilities"
  homepage "https://github.com/CPCReady/toolchain"
  url "https://github.com/CPCReady/toolchain/releases/download/v0.0.1/cpcready-toolchain-v0.0.1.tar.gz"
  sha256 "a2d2186f779c42d7b78899dc25a975e9e75d9f68e38d79aca49b379e0adb6318"
  license "MIT"

  depends_on "gcc" => :build
  depends_on "make" => :build

  def install
    cd "tools/cpc-config" do
      system ENV.cc, "cpc-config.c", "-o", "cpc-config"
      bin.install "cpc-config"
    end
  end

  test do
    # Comprobar que el binario responde a --help o -h
    system "#{bin}/cpc-config", "--help"
  end
end