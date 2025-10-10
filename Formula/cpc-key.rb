class CpcKey < Formula
  desc "CPCReady Toolchain: Configuration tool treatment utility for key-value pairs"
  homepage "https://github.com/CPCReady/cpc-key"
  url "https://github.com/CPCReady/cpc-key/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "7ce20ae1684bb5d101ca023914117ad03fba9a774313c8a9c68da8fcaf3fe7ff"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/cpc-key/releases/download/v9.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "308c438566586fec3d1e86c9b7119e3bbb764e47ba85d1fd4b30e6c38d4fbd20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "308c438566586fec3d1e86c9b7119e3bbb764e47ba85d1fd4b30e6c38d4fbd20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "308c438566586fec3d1e86c9b7119e3bbb764e47ba85d1fd4b30e6c38d4fbd20"
    sha256 cellar: :any_skip_relocation, sequoia:       "40e9da94ec8b725b1d60c31dbfbfb0c12a97c73e5d24406a58a86f6a072df8c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "40e9da94ec8b725b1d60c31dbfbfb0c12a97c73e5d24406a58a86f6a072df8c3"
    sha256 cellar: :any_skip_relocation, ventura:       "40e9da94ec8b725b1d60c31dbfbfb0c12a97c73e5d24406a58a86f6a072df8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20ee25af5199db565cfb736707875a010ed3c226ada4f8af6c3e471f04fb325b"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "28d3813c446ba953ca60a5b3ffc728aa8f9fdd2f3209b7aee739c63a6348f414"
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
