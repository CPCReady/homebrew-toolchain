class Idsk < Formula
  desc "Amstrad CPC Disk Image Management Tool - Professional CLI utility for DSK files"
  homepage "https://github.com/CPCReady/idsk"
  url "https://github.com/CPCReady/idsk/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/idsk/releases/download/v1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d0b9cadc87ae5d2ad847947515c3f4d824ffcfb16ea60add9f6edec6a544014"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d0b9cadc87ae5d2ad847947515c3f4d824ffcfb16ea60add9f6edec6a544014"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d0b9cadc87ae5d2ad847947515c3f4d824ffcfb16ea60add9f6edec6a544014"
    sha256 cellar: :any_skip_relocation, sequoia:       "35b64185bf1a97fd409e4c9adf0e03be567f8eb0d8704e3d681f1b21aa56e2db"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b64185bf1a97fd409e4c9adf0e03be567f8eb0d8704e3d681f1b21aa56e2db"
    sha256 cellar: :any_skip_relocation, ventura:       "35b64185bf1a97fd409e4c9adf0e03be567f8eb0d8704e3d681f1b21aa56e2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f644961ffca2404ea3cebf3ee7de2b027ce7fa8d98f8152451e0dfaba2a9b4c"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "63bf9a4a0efbcb24aa22799a9e4252fcd8ad6cc4835092c0a7cf9ca56ff41974"
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
    output = shell_output("#{bin}/iDSK 2>&1", 1)
    assert_match "iDSK version", output
    assert_match "Usage", output
    assert_match "OPTIONS", output

    # Verificar que podemos crear un nuevo DSK
    system bin/"iDSK", "test.dsk", "-n"
    assert_predicate testpath/"test.dsk", :exist?

    # Verificar que podemos listar el contenido del DSK vacío
    output = shell_output("#{bin}/iDSK test.dsk -l")
    assert_match "No file", output

    # Crear un archivo de texto simple para importar
    (testpath/"test.txt").write("Hello CPC World!")

    # Importar el archivo al DSK
    system bin/"iDSK", "test.dsk", "-i", "test.txt", "-t", "0"

    # Verificar que el archivo fue importado listando el contenido
    output = shell_output("#{bin}/iDSK test.dsk -l")
    assert_match "test.txt", output

    # Exportar el archivo del DSK
    system bin/"iDSK", "test.dsk", "-g", "test.txt"
    assert_predicate testpath/"test.txt", :exist?

    # Verificar el contenido del archivo exportado
    assert_equal "Hello CPC World!", File.read(testpath/"test.txt").strip
  end
end
