class Idsk < Formula
  desc "Amstrad CPC Disk Image Management Tool - Professional CLI utility for DSK files"
  homepage "https://github.com/CPCReady/idsk"
  url "https://github.com/CPCReady/idsk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "248efd69740c9e311e460c0b19294b739dc35d088032cb4351b646797464c908"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/idsk/releases/download/v0.20.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53896ddb28ad6c6c2f9b9256172975333471f8dacfd18a2614e2485a840d4e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53896ddb28ad6c6c2f9b9256172975333471f8dacfd18a2614e2485a840d4e99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53896ddb28ad6c6c2f9b9256172975333471f8dacfd18a2614e2485a840d4e99"
    sha256 cellar: :any_skip_relocation, sequoia:       "bcc07b9987237705ce7d2385541328c248c329ac48dc464fea8491e260b9181d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc07b9987237705ce7d2385541328c248c329ac48dc464fea8491e260b9181d"
    sha256 cellar: :any_skip_relocation, ventura:       "bcc07b9987237705ce7d2385541328c248c329ac48dc464fea8491e260b9181d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2a64ddeefdf0f3bc393e50f3458dae65931f5ea99bdd34af9c57e9380314f38"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "442bc7d0ad929c4552a4a6d6e36bc768c25afaae16867e70f7642fa8ea9b3ccd"
  end

  depends_on "cmake" => :build

  def install
    # Si estamos usando un bottle, el binario ya está en la ubicación correcta
    # Si estamos compilando desde fuente, necesitamos compilar
    if build.bottle?
      # Para bottles, simplemente copiar desde la estructura del bottle
      bin.install "bin/idsk" => "idsk"
    else
      # Para compilación desde fuente
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
      system "cmake", "--build", "build", "--config", "Release"
      bin.install "build/idsk"
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
