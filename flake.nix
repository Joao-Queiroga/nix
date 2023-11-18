{
  description = "My system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        config = { allowUnfree = true; };

      };
      createConfiguration = hostname: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system inputs; };
        modules = [
          { networking.hostName = hostname; }
          ./configuration.nix
          ./${hostname}-config.nix
        ];
      };
    in
    {
      nixosConfigurations = {
        tux = createConfiguration "tux";
        tuxnote = createConfiguration "tuxnote";
      };
    };
}
