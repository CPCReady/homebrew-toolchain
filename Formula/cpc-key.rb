class CpcKey < Formula
  desc "CPCReady Toolchain: Configuration tool treatment utility for key-value pairs"
  homepage "https://github.com/CPCReady/cpc-key"
  url "https://github.com/CPCReady/cpc-key/archive/v5.0.0.tar.gz"
  sha256 "d94b7aad0a91b62d48febd711cfc179389558381ef92ed70b0ae0b25dd13c56d"
  license "MIT"
  version "5.0.0"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/cpc-key/releases/download/v5.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d38767aeca690077e2e37fec6845139eca8ae0c42f2232b1ac5c15b07d4e6bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d38767aeca690077e2e37fec6845139eca8ae0c42f2232b1ac5c15b07d4e6bfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d38767aeca690077e2e37fec6845139eca8ae0c42f2232b1ac5c15b07d4e6bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38767aeca690077e2e37fec6845139eca8ae0c42f2232b1ac5c15b07d4e6bfc"
    sha256 cellar: :any_skip_relocation, ventura:       "d38767aeca690077e2e37fec6845139eca8ae0c42f2232b1ac5c15b07d4e6bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b416ea04bb1f977527fdabceedd82af64d32891fb62b28b9783bf080b2e9d9d"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8da30df747531239529aba0f7ae43d7b2db77307bb08d1e4ccc63d47be3b40d1"
  end

  def install
    # Los bottles ya están precompilados, solo extraer e instalar
    bin.install "cpc-key"
    
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
    assert_match "cpc-key version", output
    
    # Verificar ayuda
    output = shell_output("#{bin}/cpc-key --help")
    assert_match "CPCReady Toolchain Configuration Tool", output
    assert_match "set <filename> <key> <value>", output
    assert_match "get <filename> <key>", output
  end
end
