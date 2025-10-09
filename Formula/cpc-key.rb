class CpcKey < Formula
  desc "CPCReady Toolchain: Configuration tool treatment utility for key-value pairs"
  homepage "https://github.com/CPCReady/cpc-key"
  url "https://github.com/CPCReady/cpc-key/archive/v2.0.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"
  version "2.0.0"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/cpc-key/releases/download/v2.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "018072fccdf3c9ac642db4b3ce712312b532ff6c0f113a55674a195a4c204c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "018072fccdf3c9ac642db4b3ce712312b532ff6c0f113a55674a195a4c204c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "018072fccdf3c9ac642db4b3ce712312b532ff6c0f113a55674a195a4c204c20"
    sha256 cellar: :any_skip_relocation, sonoma:        "018072fccdf3c9ac642db4b3ce712312b532ff6c0f113a55674a195a4c204c20"
    sha256 cellar: :any_skip_relocation, ventura:       "018072fccdf3c9ac642db4b3ce712312b532ff6c0f113a55674a195a4c204c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91531aed46eccb34f4c23367bda6f5694127e5cb6cc37b7a987d854b7918f323"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "81a69265e0a1bd9d013c309c9038224eb5cb59ee8be32dd4041adc1ea32e3242"
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
