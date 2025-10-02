class Toolchain < Formula
  desc "C/C++ utilities for CPC development"
  homepage "https://github.com/CPCReady/toolchain"
  url "https://github.com/CPCReady/toolchain.git",
      tag:      "v0.0.5",
      revision: "c6fc379956863c417ba599b3255222baf29c9fb6"  # reemplaza con el hash del commit del tag
  license "MIT"

  depends_on "gcc" => :build
  depends_on "make" => :build
  depends_on "inih"

  def install
    ENV.append_path "PATH", Formula["gcc"].opt_bin
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-15"

    # cpc-config
    cd "tools/cpc-config" do
      system Formula["gcc"].opt_bin/"gcc-15", "cpc-config.c", "-o", "cpc-config"
      bin.install "cpc-config"
    end

    # cpc-ini
    cd "tools/cpc-ini" do
      system Formula["gcc"].opt_bin/"gcc-15",
             "-I#{Formula["inih"].opt_include}",
             "-L#{Formula["inih"].opt_lib}",
             "main.c",
             "-o", "cpc-ini",
             "-linih"
      bin.install "cpc-ini"
    end

    # iDSK
    idsk_dir = buildpath/"tools/idsk"
    build_dir = idsk_dir/"build"
    build_dir.mkpath

    cpp_files = Dir[idsk_dir/"src/*.cpp"]

    system Formula["gcc"].opt_bin/"g++-15",
           "-std=c++11", "-O2", "-Wall",
           *cpp_files,
           "-o", build_dir/"iDSK"

    bin.install build_dir/"iDSK"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/cpc-config 2>&1", 1)
    assert_predicate bin/"cpc-config", :executable?
  end
end