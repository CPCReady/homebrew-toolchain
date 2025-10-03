class Toolchain < Formula
  desc "Utilities for CPC development"
  homepage "https://github.com/CPCReady/toolchain"
  url "https://github.com/CPCReady/toolchain/releases/download/v0.0.9/cpcready-toolchain-v0.0.9.tar.gz"
  sha256 "cf00feb6c518631697c6fd2d25664cabd91f27377128865209c356de807f1394"
  license "MIT"

  def pour_bottle?
    false
  end

  depends_on "gcc" => :build
  depends_on "make" => :build
  depends_on "cmake" => :build
  depends_on "inih"

  def install
    # Limpiar directorios de build anteriores
    rm_rf Dir["**/build"]
    
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
      # Limpiamos completamente el directorio build si existe
      rm_rf "build"
      mkdir_p "build"
      cd "build" do
        system "cmake", "..", *std_cmake_args,
              "-DCMAKE_C_COMPILER=#{Formula["gcc"].opt_bin}/gcc-15",
              "-DCMAKE_CXX_COMPILER=#{Formula["gcc"].opt_bin}/g++-15"
        system "cmake", "--build", "."
      end
      bin.install "build/iDSK"
    end


  end

  test do
    # Verificar que los ejecutables existen y tienen permisos de ejecución
    assert_predicate bin/"cpc-config", :executable?
    assert_predicate bin/"cpc-ini", :executable?
    assert_predicate bin/"iDSK", :executable?
  end
end