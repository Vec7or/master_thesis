{
  description = "Example flake with a devShell";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=26.05";
  outputs = { self, nixpkgs}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "firmups-docs";
        buildInputs = with pkgs; [
          typst
          tinymist
          bashInteractive
        ];
        shellHook = ''
          export PS1=($name)$PS1
          echo "Welcome to the $name devShell!"
        '';
      };
    };
}
