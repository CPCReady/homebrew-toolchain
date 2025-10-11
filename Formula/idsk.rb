class Idsk < Formula
  desc "Amstrad CPC Disk Image Management Tool - Professional CLI utility for DSK files"
  homepage "https://github.com/CPCReady/idsk"
  url "https://github.com/CPCReady/idsk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "248efd69740c9e311e460c0b19294b739dc35d088032cb4351b646797464c908"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/idsk/releases/download/v0.20.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b326413af0b44f1d611fb1ddefc189259d2540547a24b429e18e80220c244411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b326413af0b44f1d611fb1ddefc189259d2540547a24b429e18e80220c244411"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b326413af0b44f1d611fb1ddefc189259d2540547a24b429e18e80220c244411"
    sha256 cellar: :any_skip_relocation, sequoia:       "8c3ccb08ce6cb4a69993ec4f654074d435db6a41105a1043f064986f644cd6f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c3ccb08ce6cb4a69993ec4f654074d435db6a41105a1043f064986f644cd6f9"
    sha256 cellar: :any_skip_relocation, ventura:       "8c3ccb08ce6cb4a69993ec4f654074d435db6a41105a1043f064986f644cd6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ee594ba0805ffba14d13d24ad2be885b6d7e9d4f15cf3963fbcdee93d26523e"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cc6060f117f36d6a371724c607270217078aca3e9751e4711ea13757fc4f4c8d"
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
