class CpcKey < Formula
  desc "CPCReady Toolchain: Configuration tool treatment utility for key-value pairs"
  homepage "https://github.com/CPCReady/cpc-key"
  url "https://github.com/CPCReady/cpc-key/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "0bcf2b28d6644200d7b64d6b0204ef049460f8f47438cc877e75a6eda4d9e65c"
  license "MIT"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/cpc-key/releases/download/v4.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c5f554e1e0d9d885f4457e20b72e6bd739b36ba5f96fe9f94cd4d6975220843"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "8c5f554e1e0d9d885f4457e20b72e6bd739b36ba5f96fe9f94cd4d6975220843"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c5f554e1e0d9d885f4457e20b72e6bd739b36ba5f96fe9f94cd4d6975220843"
    sha256 cellar: :any_skip_relocation, sequoia: "8c5f554e1e0d9d885f4457e20b72e6bd739b36ba5f96fe9f94cd4d6975220843"
    sha256 cellar: :any_skip_relocation, sonoma: "8c5f554e1e0d9d885f4457e20b72e6bd739b36ba5f96fe9f94cd4d6975220843"
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
