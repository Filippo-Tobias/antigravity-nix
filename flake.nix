{
  description = "A flake for running antigravity on nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      myRuntimeDeps = with pkgs; [
        glib gtk3 systemd dbus mesa cairo pango atk at-spi2-core 
        at-spi2-atk nspr nss xorg.libX11 xorg.libxcb xorg.libXcomposite 
        xorg.libXdamage xorg.libXext xorg.libXfixes xorg.libXrandr 
        libxkbcommon cups expat alsa-lib xorg.libxkbfile
      ];

    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "antigravity";

        src = pkgs.fetchurl {
          url = "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/1.11.2-6251250307170304/linux-x64/Antigravity.tar.gz";
          sha256 = "1dv4bx598nshjsq0d8nnf8zfn86wsbjf2q56dqvmq9vcwxd13cfi";
        };

        nativeBuildInputs = [ 
          pkgs.autoPatchelfHook 
          pkgs.makeWrapper 
        ];

        buildInputs = myRuntimeDeps;

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/antigravity

          cp -r ./* $out/share/antigravity

          mkdir -p $out/bin

          makeWrapper $out/share/antigravity/antigravity \
            $out/bin/antigravity \
            --chdir "$out/share/antigravity"

          runHook postInstall
        '';
      };
    };
}
