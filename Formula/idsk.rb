class Idsk < Formula
  desc "Amstrad CPC Disk Image Management Tool - Professional CLI utility for DSK files"
  homepage "https://github.com/CPCReady/idsk"
  url "https://github.com/CPCReady/idsk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "248efd69740c9e311e460c0b19294b739dc35d088032cb4351b646797464c908"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/idsk/releases/download/v0.20.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5330469d67bd8f3386025a553390aec58d6db0c8ebced097bc4f160c255d5519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5330469d67bd8f3386025a553390aec58d6db0c8ebced097bc4f160c255d5519"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5330469d67bd8f3386025a553390aec58d6db0c8ebced097bc4f160c255d5519"
    sha256 cellar: :any_skip_relocation, sequoia:       "f8bc6abafadb30e6dcd606dcbf892eb6a59e1a07cae84776dc18f47983fd4515"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8bc6abafadb30e6dcd606dcbf892eb6a59e1a07cae84776dc18f47983fd4515"
    sha256 cellar: :any_skip_relocation, ventura:       "f8bc6abafadb30e6dcd606dcbf892eb6a59e1a07cae84776dc18f47983fd4515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e01dec61299b0df0167fd2dbbf1c0b8edffdc2122a4aa378f6bf298214b251e"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a6795df5c6397a5869c8a2dbc9724ac14ad91b97f3b353a61082b567313e0fca"
  end

  depends_on "cmake" => :build

  def install
    # Si estamos usando un bottle, el binario ya está en la ubicación correcta
    # Si estamos compilando desde fuente, necesitamos compilar
    if build.bottle?
      # Para bottles, simplemente copiar desde la estructura del bottle
      bin.install "bin/iDSK"
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
    output = shell_output("#{bin}/iDSK 2>&1")
    assert_match "Enhanced version", output
    assert_match "Usage", output
    assert_match "OPTIONS", output

    # Verificar que podemos crear un nuevo DSK
    system bin/"iDSK", "test.dsk", "-n"
    assert_path_exists testpath/"test.dsk"
  end
end
