class Toolchain < Formula
  desc "C/C++ utilities for CPC development"
  homepage "https://github.com/CPCReady/toolchain"
  url "https://github.com/CPCReady/toolchain/releases/download/v0.0.5/cpcready-toolchain-v0.0.5.tar.gz"
  sha256 "398310940f55d4aa6e92c28b1238e3f46a57b92a0e85bc56dea62cf623d54a50"
  license "MIT"

  def pour_bottle?
    false
  end

  depends_on "gcc" => :build
  depends_on "make" => :build
  depends_on "inih"

  def install
    ENV.append_path "PATH", Formula["gcc"].opt_bin
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-15"

    cd "tools/cpc-config" do
      system Formula["gcc"].opt_bin/"gcc-15", "cpc-config.c", "-o", "cpc-config"
      bin.install "cpc-config"
    end

    cd "tools/cpc-ini" do
      system Formula["gcc"].opt_bin/"gcc-15",
            "-I#{Formula["inih"].opt_include}",
            "-L#{Formula["inih"].opt_lib}",
            "main.c",
            "-o", "cpc-ini",
            "-linih"
      bin.install "cpc-ini"
    end

    cd "tools/idsk" do
        # compilamos todos los .cpp con rutas relativas correctas
        system "g++", "-std=c++11", "-O2", "-Wall",
              "./src/Basic.cpp",
              "./src/BitmapCPC.cpp",
              "./src/Dams.cpp",
              "./src/Desass.cpp",
              "./src/endianPPC.cpp",
              "./src/GestDsk.cpp",
              "./src/getopt_pp.cpp",
              "./src/Main.cpp",
              "./src/Outils.cpp",
              "./src/ViewFile.cpp",
              "./src/Ascii.cpp",
              "-o", "iDSK"
        # instalamos el binario
        bin.install "iDSK"
    end


  end

  test do
    assert_match "Usage:", shell_output("#{bin}/cpc-config 2>&1", 1)
    assert_predicate bin/"cpc-config", :executable?
  end
end