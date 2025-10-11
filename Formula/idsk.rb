class Idsk < Formula
  desc "Amstrad CPC Disk Image Management Tool - Professional CLI utility for DSK files"
  homepage "https://github.com/CPCReady/idsk"
  url "https://github.com/CPCReady/idsk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "a0207848ab9a4c86a0a2c78eafc04cd9ad495058b0efb49e82c3b841e555448c"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/idsk/releases/download/v0.20.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d635f036e44383e42402ad1166e551f3ce4e619fa6fdeee5594d7e0319075946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d635f036e44383e42402ad1166e551f3ce4e619fa6fdeee5594d7e0319075946"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d635f036e44383e42402ad1166e551f3ce4e619fa6fdeee5594d7e0319075946"
    sha256 cellar: :any_skip_relocation, sequoia:       "6b1c80d0b6ee3cbaaf6d769914c0ed625cab0a261a4df0042489f2bdd174f33b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b1c80d0b6ee3cbaaf6d769914c0ed625cab0a261a4df0042489f2bdd174f33b"
    sha256 cellar: :any_skip_relocation, ventura:       "6b1c80d0b6ee3cbaaf6d769914c0ed625cab0a261a4df0042489f2bdd174f33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7870155708d9ab306dd28d73aa711b1a048bcafdb4209edb6b8b67321bfc4ed4"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d893390ce653936966d6962e4d330e86bd515a3bf79093d98c9b39f845fb1865"
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
    assert_path_exists testpath/"test.txt"

    # Verificar el contenido del archivo exportado
    assert_equal "Hello CPC World!", File.read(testpath/"test.txt").strip
  end
end
