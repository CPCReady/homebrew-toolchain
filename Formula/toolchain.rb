class Toolchain < Formula
  desc "C/C++ utilities for CPC development"
  homepage "https://github.com/CPCReady/toolchain"
  url "https://github.com/CPCReady/toolchain.git",
      tag:      "v0.0.5",
      revision: "3c2f7b8d8d5a4e2f1a2b3c4d5e6f7g8h9i0jklmn" # reemplaza con el SHA real del tag
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
    idsk_dir = buildpath/"tools/idsk"
    build_dir = idsk_dir/"build"
    build_dir.mkpath

    # obtenemos todos los .cpp del repo
    cpp_files = Dir[idsk_dir/"src/*.cpp"]
    if cpp_files.empty?
      odie "No .cpp files found in #{idsk_dir}/src. Make sure the repo contains the iDSK sources."
    end

    # compilamos con GCC-15
    system Formula["gcc"].opt_bin/"g++-15",
           "-std=c++11", "-O2", "-Wall",
           *cpp_files,
           "-o", build_dir/"iDSK"

    bin.install build_dir/"iDSK"
  end

  test do
    # probamos cpc-config
    assert_match "Usage:", shell_output("#{bin}/cpc-config 2>&1", 1)
    assert_predicate bin/"cpc-config", :executable?

    # opcional: probar que iDSK existe
    assert_predicate bin/"iDSK", :exist?
  end
end