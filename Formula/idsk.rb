class Idsk < Formula
  desc "Amstrad CPC Disk Image Management Tool - Professional CLI utility for DSK files"
  homepage "https://github.com/CPCReady/idsk"
  url "https://github.com/CPCReady/idsk/archive/refs/tags/v0.22.tar.gz"
  sha256 "d3672ee33351e62a9b60d9e5e883c76a83ef646227f4958cb9ca8a3479e2e674"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/idsk/releases/download/v0.22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2f3fd65a224b60537a7a1868e0c998fde01be95419b8e7e408e15c94708fd19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f3fd65a224b60537a7a1868e0c998fde01be95419b8e7e408e15c94708fd19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2f3fd65a224b60537a7a1868e0c998fde01be95419b8e7e408e15c94708fd19"
    sha256 cellar: :any_skip_relocation, sequoia:       "0869b0b2ac7aa7df27fd640fcafd013fad6aa1285c1853a9db95aaacefc00a13"
    sha256 cellar: :any_skip_relocation, sonoma:        "0869b0b2ac7aa7df27fd640fcafd013fad6aa1285c1853a9db95aaacefc00a13"
    sha256 cellar: :any_skip_relocation, ventura:       "0869b0b2ac7aa7df27fd640fcafd013fad6aa1285c1853a9db95aaacefc00a13"
  end

  depends_on "cmake" => :build

  def install
    # Si estamos usando un bottle, el binario ya está en la ubicación correcta
    # Si estamos compilando desde fuente, necesitamos compilar
    if build.bottle?
      # Para bottles, simplemente copiar desde la estructura del bottle
      bin.install "bin/idsk" => "iDSK"
    else
      # Para compilación desde fuente
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
      system "cmake", "--build", "build", "--config", "Release"
      bin.install "build/iDSK"
    end

    # Instalar documentación si está disponible
    doc.install "README.md" if File.exist?("README.md")
    doc.install "AUTHORS" if File.exist?("AUTHORS")
    doc.install "docs/" if File.exist?("docs/BUILD.md")
  end

  test do
    # Crear un archivo DSK de prueba y verificar las funcionalidades básicas
    # Verificar que el comando existe y muestra ayuda
    output = shell_output("#{bin}/idsk 2>&1")
    assert_match "Enhanced version", output
    assert_match "Usage", output
    assert_match "OPTIONS", output

    # Verificar que podemos crear un nuevo DSK
    system bin/"idsk", "test.dsk", "-n"
    assert_path_exists testpath/"test.dsk"
  end
end
