{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    forSystems = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ] (system: f nixpkgs.legacyPackages.${system});
  in {
    devShells = forSystems (
      pkgs: {
        default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.wine
            (pkgs.ghc.withPackages (p:
              with p; [
                extra
                regex-compat
                split
                text
                text-icu
                unordered-containers
                vector
              ]))
          ];
        };
      }
    );

    formatter = forSystems (pkgs: pkgs.alejandra);
  };
}
