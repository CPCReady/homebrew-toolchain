class CpcKey < Formula
  desc "CPCReady Toolchain: Configuration tool treatment utility for key-value pairs"
  homepage "https://github.com/CPCReady/cpc-key"
  url "https://github.com/CPCReady/cpc-key/archive/v6.0.0.tar.gz"
  sha256 "868bc45185b7aa0bd7cb92f5ac856d6a1e85927822915aa676ee530ee186b47a"
  license "MIT"
  version "6.0.0"

  # Bottles para múltiples plataformas
  bottle do
    root_url "https://github.com/CPCReady/cpc-key/releases/download/v6.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb5cac0f00f4b5525c24885127867b9993d54462dcf3ec2800855549b4ac6548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb5cac0f00f4b5525c24885127867b9993d54462dcf3ec2800855549b4ac6548"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb5cac0f00f4b5525c24885127867b9993d54462dcf3ec2800855549b4ac6548"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb5cac0f00f4b5525c24885127867b9993d54462dcf3ec2800855549b4ac6548"
    sha256 cellar: :any_skip_relocation, ventura:       "bb5cac0f00f4b5525c24885127867b9993d54462dcf3ec2800855549b4ac6548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b7418c4abda49508beb1a05e2069346e24f9ae7cfe560424f454ed2faa9521"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "822d1d4e60662208ed80d35d25e47c1677efff13549a8236bcf4bbcfd5f51614"
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
