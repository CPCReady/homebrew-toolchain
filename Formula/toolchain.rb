class Toolchain < Formula
  desc "CPCReady toolchain with C/C++ utilities"
  homepage "https://github.com/CPCReady/toolchain"
  url "https://github.com/CPCReady/toolchain/releases/download/v0.0.5/cpcready-toolchain-v0.0.5.tar.gz"
  sha256 "398310940f55d4aa6e92c28b1238e3f46a57b92a0e85bc56dea62cf623d54a50"
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