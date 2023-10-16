{ pkgs, inputs, ... }:
let
	python_packages = ps: with ps; [
		django
		pip
	];
in
{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
		];

	boot.loader = {
		grub = {
			enable = true;
			device = "nodev";
			efiSupport = true;
			useOSProber = true;
		};
		efi = {
			canTouchEfiVariables = true;
			efiSysMountPoint = "/boot/efi";
		};
	};

	security.polkit.enable = true;
	
	systemd = {
		user.services.polkit-gnome-authentication-agent-1 = {
			description = "polkit-gnome-authentication-agent-1";
			wantedBy = [ "graphical-session.target" ];
			wants = [ "graphical-session.target" ];
			after = [ "graphical-session.target" ];
			serviceConfig = {
				Type = "simple";
				ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
				Restart = "on-failure";
				RestartSec = 1;
				TimeoutStopSec = 10;
			};
		};
	};

	nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
		experimental-features = [ "nix-command" "flakes" ];
	};

	nixpkgs.config.permittedInsecurePackages = [
		"electron-19.1.9"
	];

	# networking.hostName = "nixos"; # Define your hostname.
	networking.networkmanager.enable = true;

	time.timeZone = "Brazil/East";

	i18n.defaultLocale = "pt_BR.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		keyMap = "br-abnt2";
	};

	services.xserver = {
		enable = true;
		displayManager = {
				sddm = {
					enable = true;
					autoNumlock = true;
				};
				defaultSession = "hyprland";
		};

		windowManager.awesome = {
			enable = true;
		};
	};

	services.xserver.layout = "br";

	# Enable sound.
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	#Bluetooth
	hardware.bluetooth.enable = true;
	services.blueman.enable = true;

	# Enable touchpad support (enabled default in most desktopManager).
	services.xserver.libinput.enable = true;

	programs = {
		zsh.enable = true;
		git.enable = true;
		dconf.enable = true;
		nm-applet.enable = true;
		nix-ld.enable = true;
		java.enable = true;
		gamemode.enable = true;
		neovim = {
			enable = true;
			withPython3 = true;
			withNodeJs = true;
			defaultEditor = true;
		};
		gnupg.agent = {
			enable = true;
			pinentryFlavor = "gnome3";
		};
		firefox.enable = true;
		hyprland = {
			enable = true;
			package = inputs.hyprland.packages.${pkgs.system}.hyprland;
		};
		waybar.enable = true;
		thunar = {
			enable = true;
		};
	};

	# Enable GVFS (which manages automatic mounting of external drives, etc.)
	services.gvfs.enable = true;
	# Enable thumbler for thumbnails in thunar
	services.tumbler.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.defaultUserShell = pkgs.zsh;
	users.users.joaoqueiroga = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" ];
	};

	environment.systemPackages = with pkgs; [
		brave
		tmux
		home-manager
		vim
		alsa-utils
		networkmanagerapplet
		pulsemixer
		fish
		wget
		wbg
		nodejs
		bun
		(python3.withPackages python_packages)
		luajit
		gopass
		gopass-jsonapi
		htop
		btop
		bat
		eza
		ripgrep
		killall
		file
		unzip
		zip
		xclip
		wl-clipboard
		alacritty
		wbg
		dunst
		llvmPackages.bintools
		rustup
		go
		chezmoi
		lazygit
		pfetch
		starship
		gcc
		openjdk
		picom
		dex
		zathura
		ueberzugpp
		jq
		hurl
		vifm-full
		etcher
		rofi-wayland
		bemenu
		brightnessctl
		inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
	];

	environment.binsh = "${pkgs.dash}/bin/dash";

	fonts.packages = with pkgs; [
		nerdfonts
	];

	system.stateVersion = "23.05";

	nixpkgs.config.allowUnfree = true;
}
