class Toolchain < Formula
  desc "CPCReady toolchain with C/C++ utilities"
  homepage "https://github.com/CPCReady/toolchain"
  url "https://github.com/CPCReady/toolchain/releases/download/v0.0.4/cpcready-toolchain-v0.0.4.tar.gz"
  sha256 "6a1494de45a9729842cd7a310961387dbeac317d04ec5bc8a0b65d3e9a451172"
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