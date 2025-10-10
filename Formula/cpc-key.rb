class CpcKey < Formula
  desc "CPCReady Toolchain: Configuration tool treatment utility for key-value pairs"
  homepage "https://github.com/CPCReady/cpc-key"
  url "https://github.com/CPCReady/cpc-key/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "a0f605afa1d51d0abb7d72438ff267c7d7ef8a23d715f638bb562c51005ce5eb"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/cpc-key/releases/download/v9.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2968986a04e382ceceef754dcab4480fa7e7070686d640597cfb35239b806db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b8c9b0c4b2be26d8ad69f47889fc749d5ecc1012e7fc30e3f0a6381afdd267f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4a61731cdad94d5c72b9cd8937499a63e4860e7c28fc6f74bf0aa17d2c49189"
    sha256 cellar: :any_skip_relocation, sequoia:       "8a6b127c341034209fb9d03a2ebd7cd27c40c417de424dc65cbf6b5dcce8011a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a8fabe3b28a540765ebebbc9085eb316fa733fcc50940673bd5b32c0c4ac743"
    sha256 cellar: :any_skip_relocation, ventura:       "c8328239d01626c455652ecdc43c91fb4de69b603c2bdb0937d89a60026c557d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e193c350680c557044c375b6818e068b90ac8be608201aa9414520c32d5df20f"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b35fff192d2dc4bb893002f058410e652ea673980c1d8229da3c6a04628d3839"
  end

  def install
    # Si estamos usando un bottle, el binario ya está en la ubicación correcta
    # Si estamos compilando desde fuente, necesitamos compilar
    if build.bottle?
      # Para bottles, simplemente copiar desde la estructura del bottle
      bin.install "bin/cpc-key"
    else
      # Para compilación desde fuente
      system "make", "clean"
      system "make"
      bin.install "cpc-key"
    end

    # Instalar documentación si está disponible
    doc.install "README.md" if File.exist?("README.md")
  end

  test do
    # Crear un archivo de prueba
    (testpath/"test.conf").write <<~EOS
      server_name=localhost
      port=8080
      timeout=30
      debug_mode="true"
    EOS

    # Probar lectura de valores
    assert_equal "localhost", shell_output("#{bin}/cpc-key get #{testpath}/test.conf server_name").strip
    assert_equal "8080", shell_output("#{bin}/cpc-key get #{testpath}/test.conf port").strip
    assert_equal "30", shell_output("#{bin}/cpc-key get #{testpath}/test.conf timeout").strip
    assert_equal "true", shell_output("#{bin}/cpc-key get #{testpath}/test.conf debug_mode").strip

    # Probar escritura de valores
    system bin/"cpc-key", "set", "#{testpath}/test.conf", "server_name", "production-server"
    assert_equal "production-server", shell_output("#{bin}/cpc-key get #{testpath}/test.conf server_name").strip

    # Probar creación de nueva clave
    system bin/"cpc-key", "set", "#{testpath}/test.conf", "max_connections", "100"
    assert_equal "100", shell_output("#{bin}/cpc-key get #{testpath}/test.conf max_connections").strip

    # Probar creación de archivo nuevo
    system bin/"cpc-key", "set", "#{testpath}/new_config.conf", "database_host", "db.example.com"
    assert_equal "db.example.com", shell_output("#{bin}/cpc-key get #{testpath}/new_config.conf database_host").strip

    # Verificar versión
    output = shell_output("#{bin}/cpc-key --version")
    assert_match "cpc-conf version", output

    # Verificar ayuda
    output = shell_output("#{bin}/cpc-key --help")
    assert_match "CPCReady Toolchain Configuration Tool", output
    assert_match "set <filename> <key> <value>", output
    assert_match "get <filename> <key>", output
  end
end
