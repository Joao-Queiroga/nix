# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, ... }:

let
	python_packages = ps: with ps; [
		django
	];
in
{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
		];

	# Use the systemd-boot EFI boot loader.
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
		"electron-12.2.3"
	];

	# networking.hostName = "nixos"; # Define your hostname.
	# Pick only one of the below networking options.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	# Set your time zone.
	time.timeZone = "Brazil/East";

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Select internationalisation properties.
	i18n.defaultLocale = "pt_BR.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		keyMap = "br-abnt2";
	};

	# Enable the X11 windowing system.
	services.xserver = {
		enable = true;
		displayManager = {
				sddm = {
					enable = true;
					autoNumlock = true;
				};
				defaultSession = "none+awesome";
		};

		windowManager.awesome = {
			enable = true;
		};
	};

	# Configure keymap in X11
	services.xserver.layout = "br";
	# services.xserver.xkbOptions = "eurosign:e,caps:escape";

	# Enable CUPS to print documents.
	# services.printing.enable = true;

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
		hyprland = {
			enable = true;
			package = inputs.hyprland.packages.${pkgs.system}.hyprland;
		};
		waybar.enable = true;
	};

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.defaultUserShell = pkgs.zsh;
	users.users.joaoqueiroga = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
		packages = with pkgs; [
			brave
			alacritty
			tmux
			tree
		];
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		home-manager
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		alsa-utils
		networkmanagerapplet
		pulsemixer
		fish
		wget
		wbg
		nodejs
		(python3.withPackages python_packages)
		luajit
		gopass
		gopass-jsonapi
		htop
		btop
		bat
		lsd
		unzip
		zip
		xclip
		wl-clipboard
		foot
		wbg
		dunst
		llvmPackages.bintools
		rustup
		go
		chezmoi
		lazygit
		pcmanfm
		pfetch
		starship
		gcc
		openjdk
		picom
		dex
		zathura
		ueberzugpp
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

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# Copy the NixOS configuration file and link it from the resulting system
	# (/run/current-system/configuration.nix). This is useful in case you
	# accidentally delete configuration.nix.
	# system.copySystemConfiguration = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It's perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.05"; # Did you read the comment?

	nixpkgs.config.allowUnfree = true;
}
