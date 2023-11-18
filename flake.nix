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
	in
	{
  nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit system inputs; };
    modules = [
      ./configuration.nix
    ];
  };
};
}
