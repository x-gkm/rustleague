{
  description = "Run rust on algoleague";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
          runtimeInputs = with pkgs; [
            jq
            wabt
            (pkgs.rust-bin.selectLatestNightlyWith (
              toolchain:
              toolchain.default.override {
                extensions = [ "rust-src" ];
                targets = [ "wasm32-wasip1" ];
              }
            ))
          ];
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.rust-overlay.overlays.default
            ];
          };

          devShells.default = pkgs.mkShell {
            packages = runtimeInputs ++ [ pkgs.shellcheck ];
          };

          packages.rustleague = pkgs.writeShellApplication {
            name = "rustleague";
            inherit runtimeInputs;
            text = ./rustleague;
          };

          packages.default = config.packages.rustleague;
        };
    };
}
