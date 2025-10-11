class Idsk < Formula
  desc "Amstrad CPC Disk Image Management Tool - Professional CLI utility for DSK files"
  homepage "https://github.com/CPCReady/idsk"
  url "https://github.com/CPCReady/idsk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "248efd69740c9e311e460c0b19294b739dc35d088032cb4351b646797464c908"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/idsk/releases/download/v0.20.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "972d17d8c55f9564daa46df28815ec2e73705a1e2d59add9dc16df3805b42974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "972d17d8c55f9564daa46df28815ec2e73705a1e2d59add9dc16df3805b42974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "972d17d8c55f9564daa46df28815ec2e73705a1e2d59add9dc16df3805b42974"
    sha256 cellar: :any_skip_relocation, sequoia:       "ce5106fe6271054bc125b314617f9daf6feff86aa6f72c1a891c5e9277994667"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce5106fe6271054bc125b314617f9daf6feff86aa6f72c1a891c5e9277994667"
    sha256 cellar: :any_skip_relocation, ventura:       "ce5106fe6271054bc125b314617f9daf6feff86aa6f72c1a891c5e9277994667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f22c9a784f39ef1238cf39e45627b372eca275dbce837e3704302f50a12b5692"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f80b03199f498633a1371661d0208bf380901f59ccbee37906df73fcb59a6113"
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
