class Idsk < Formula
  desc "Amstrad CPC Disk Image Management Tool - Professional CLI utility for DSK files"
  homepage "https://github.com/CPCReady/idsk"
  url "https://github.com/CPCReady/idsk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "248efd69740c9e311e460c0b19294b739dc35d088032cb4351b646797464c908"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/idsk/releases/download/v0.20.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9588f02c23ffa2232324d78ae656870b6cb0fc3fe316365f731b99a69a854116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9588f02c23ffa2232324d78ae656870b6cb0fc3fe316365f731b99a69a854116"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9588f02c23ffa2232324d78ae656870b6cb0fc3fe316365f731b99a69a854116"
    sha256 cellar: :any_skip_relocation, sequoia:       "f9c30f1c9698fecf1dce1c9a6d0a88520c452d2a934407fe4dcb491f5016e994"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c30f1c9698fecf1dce1c9a6d0a88520c452d2a934407fe4dcb491f5016e994"
    sha256 cellar: :any_skip_relocation, ventura:       "f9c30f1c9698fecf1dce1c9a6d0a88520c452d2a934407fe4dcb491f5016e994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910358ce10f4c7b848261c31dd161c0114b76074c55f60e2bbe0d68ba251188d"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5f6853c6b7a569ddd032dccac8639f25cb8989916b0ba28182bf0d030f1f3544"
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
