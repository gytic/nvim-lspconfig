{
  description = "Quickstart configurations for the Nvim LSP client";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.systems.url = "github:nix-systems/default";

  outputs =
    {
      self,
      nixpkgs,
      systems,
    }:
    let
      supportedSystems = nixpkgs.lib.genAttrs (import systems);
      forEachSystem = function: supportedSystems (system: function nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.stylua
            pkgs.luaPackages.luacheck
            pkgs.luajitPackages.vusted
            pkgs.selene
          ];
        };
      });
      packages = forEachSystem (pkgs: {
        default = pkgs.stdenv.mkDerivation {
          name = "nvim-lspconfig";

          phases = [ "buildPhase" ];

          buildPhase = ''
            mkdir -p $out
            cp -r ${./.}/* $out
          '';

        };
      });
    };
}
