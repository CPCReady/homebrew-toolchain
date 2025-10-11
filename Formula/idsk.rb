class Idsk < Formula
  desc "Amstrad CPC Disk Image Management Tool - Professional CLI utility for DSK files"
  homepage "https://github.com/CPCReady/idsk"
  url "https://github.com/CPCReady/idsk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "248efd69740c9e311e460c0b19294b739dc35d088032cb4351b646797464c908"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/idsk/releases/download/v0.20.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "958ac3dfc37e61b556f13e8b3f742cd57dfe248ac37ca68c2818dc41b48ebb01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "958ac3dfc37e61b556f13e8b3f742cd57dfe248ac37ca68c2818dc41b48ebb01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "958ac3dfc37e61b556f13e8b3f742cd57dfe248ac37ca68c2818dc41b48ebb01"
    sha256 cellar: :any_skip_relocation, sequoia:       "f3ea2399b97a92ea8e97b3914607fd04169ed8aadfbffd17c7d12295b35469f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3ea2399b97a92ea8e97b3914607fd04169ed8aadfbffd17c7d12295b35469f6"
    sha256 cellar: :any_skip_relocation, ventura:       "f3ea2399b97a92ea8e97b3914607fd04169ed8aadfbffd17c7d12295b35469f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7abbb043fc079b2606848ab088f1c4a78bf6036c04e3250b14ee268fe1cfe448"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d4a06c755e0c1e1312f9c69a04a194b21018133cbb1f4b35fc81dfadf5d7d479"
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
