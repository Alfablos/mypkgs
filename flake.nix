{
  description = "Repo for useful packages";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        packages.default = self.packages.${system}.ompweb;

        packages.posting = pkgs.callPackage ./posting.nix { };

        packages.ompweb = pkgs.callPackage ./ompweb.nix { };
      }
    );
}
