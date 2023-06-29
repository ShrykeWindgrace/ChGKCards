{ compiler ? "ghc928" }:

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  gitignore = pkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];

  myHaskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = hself: hsuper: {
      "cli" =
        hself.callCabal2nix
          "cli"
          (gitignore ./.)
          {};
    };
  };

  shell = myHaskellPackages.shellFor {
    packages = p: [
      p."cli"
    ];
    buildInputs = [
      myHaskellPackages.haskell-language-server
      pkgs.haskellPackages.cabal-install
      pkgs.haskellPackages.hlint
      pkgs.nixpkgs-fmt
    ];
    withHoogle = false;
  };

  exe = pkgs.haskell.lib.justStaticExecutables (myHaskellPackages."cli");

in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  "cli" = myHaskellPackages."cli";
}
