{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    forSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];
    pkgsFor = system:
      import nixpkgs {
        inherit system;
      };
  in {
    devShells = forSystems (
      system: let
        pkgs = pkgsFor system;
      in {
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

    formatter = forSystems (system: (pkgsFor system).alejandra);
  };
}
