class CpcreadyTools < Formula
  desc "CPCReady Tools"
  homepage "https://github.com/CPCReady/homebrew-cpcready"
  version "1.0.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/CPCReady/idsk/releases/download/v1.0.2/iDSK-mac-arm64"
      sha256 "ec9e567c520ae5ff395abe904c1b2684e222b2369094589e3a5ffaa4a07032d8"
    elsif Hardware::CPU.intel?
      url "https://github.com/CPCReady/idsk/releases/download/v1.0.2/iDSK-mac-x86_64"
      sha256 "9f4aec81a8552879a835f0ed1d0ba341ae9d390389037fa32a00d47889a26036"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/CPCReady/idsk/releases/download/v1.0.2/iDSK-mac-arm64"
      sha256 "ec9e567c520ae5ff395abe904c1b2684e222b2369094589e3a5ffaa4a07032d8"
    elsif Hardware::CPU.intel?
      url "https://github.com/CPCReady/idsk/releases/download/v1.0.2/iDSK-linux-x86_64"
      sha256 "e07e1042bcfa1ac0b8871b07afb07aba3d90692168f4dbaa26ecc11ce6e16d1d"
    end
  end

  resource "cpc-update-var" do
    url "https://github.com/CPCReady/cpc-update-var/releases/download/v0.1.2/cpc-update-var"
    sha256 "3293825eff99965331401a3c0ab23924eee2d44ecf73ab36e36102512545b2b4"
  end

  depends_on "gum"
  depends_on "yq"
  depends_on "jq"

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "iDSK-mac-arm64" => "idsk"
      elsif Hardware::CPU.intel?
        bin.install "iDSK-mac-x86_64" => "idsk"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        bin.install "iDSK-mac-arm64" => "idsk"
      elsif Hardware::CPU.intel?
        bin.install "iDSK-linux-x86_64" => "idsk"
      end
    end
    resource("cpc-update-var").stage do
      bin.install "cpc-update-var"
    end
  end

  test do
    system bin/"idsk", "--version"
    system bin/"cpc-update-var", "--version"
  end
end