class Toolchain < Formula
  desc "C/C++ utilities for CPC development"
  homepage "https://github.com/CPCReady/toolchain"
  url "https://github.com/CPCReady/toolchain.git",
      tag:      "v0.0.7",
      revision: "baf205e943845cc5336a6c6556e1aebc22b6ab4e" # reemplaza con el SHA real del tag
  license "MIT"

  depends_on "gcc" => :build
  depends_on "make" => :build
  depends_on "inih"

  def install
    ENV.append_path "PATH", Formula["gcc"].opt_bin
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-15"

    # ------------------------
    # cpc-config
    # ------------------------
    cd "tools/cpc-config" do
      system Formula["gcc"].opt_bin/"gcc-15", "cpc-config.c", "-o", "cpc-config"
      bin.install "cpc-config"
    end

    # ------------------------
    # cpc-ini
    # ------------------------
    cd "tools/cpc-ini" do
      system Formula["gcc"].opt_bin/"gcc-15",
             "-I#{Formula["inih"].opt_include}",
             "-L#{Formula["inih"].opt_lib}",
             "main.c",
             "-o", "cpc-ini",
             "-linih"
      bin.install "cpc-ini"
    end

    # ------------------------
    # iDSK
    # ------------------------
    cd "tools/idsk" do
      build_dir = Pathname.pwd/"build"
      build_dir.mkpath

      system Formula["gcc"].opt_bin/"g++-15",
            "-std=c++11", "-O2", "-Wall",
            "src/Basic.cpp",
            "src/BitmapCPC.cpp",
            "src/Dams.cpp",
            "src/Desass.cpp",
            "src/endianPPC.cpp",
            "src/GestDsk.cpp",
            "src/getopt_pp.cpp",
            "src/Main.cpp",
            "src/Outils.cpp",
            "src/ViewFile.cpp",
            "src/Ascii.cpp",
            "-o", build_dir/"iDSK"

      bin.install build_dir/"iDSK"
    end
  end

  test do
    # probamos cpc-config
    assert_match "Usage:", shell_output("#{bin}/cpc-config 2>&1", 1)
    assert_predicate bin/"cpc-config", :executable?

    # opcional: probar que iDSK existe
    assert_predicate bin/"iDSK", :exist?
  end
end

