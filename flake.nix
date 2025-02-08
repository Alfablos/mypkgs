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
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in
      {
        packages.default = self.packages.${system}.tabby;

        packages.posting = pkgs.callPackage ./posting.nix { };
        
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ta/tabby/package.nix
        packages.tabby = with pkgs; callPackage ./tabby {
          cudaSupport = true;
          acceleration = "cuda";
          # nvidiaPackage = linuxPackages.nvidia_x11_latest;
          stdenv = gcc11Stdenv;
          pkg-config = pkg-config.override {
            stdenvNoCC = gcc11Stdenv;
          };
          openssl = openssl.override { stdenv = gcc11Stdenv; };
        };
      }
    );
}
