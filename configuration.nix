{ pkgs, inputs, ... }:
let python_packages = ps: with ps; [ django pip ];
in {
  boot.kernelPackages = pkgs.linuxPackages_zen;
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
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.permittedInsecurePackages = [ "electron-19.1.9" ];

  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedTCPPortRanges = [{
      from = 1714;
      to = 1764;
    }];
    allowedUDPPortRanges = [{
      from = 1714;
      to = 1764;
    }];
  };

  time.timeZone = "Brazil/East";

  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  services.xserver = {
    enable = true;
    windowManager.awesome = { enable = true; };
  };

  services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
    };
    defaultSession = "hyprland";
  };

  services.xserver.xkb.layout = "br";

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Sudo configuration
  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults        passprompt="Senha: "
    '';
  };

  #Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  programs = {
    zsh = {
      enable = true;
      enableCompletion = false;
    };
    git.enable = true;
    dconf.enable = true;
    droidcam.enable = true;
    nm-applet.enable = true;
    nix-ld.enable = true;
    java.enable = true;
    gamemode.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
    hyprland = { enable = true; };
    thunar = { enable = true; };
  };

  # Enable GVFS (which manages automatic mounting of external drives, etc.)
  services.gvfs.enable = true;
  # Enable thumbler for thumbnails in thunar
  services.tumbler.enable = true;
  # Enable Upower
  services.upower.enable = true;
  # Power profiles
  services.power-profiles-daemon.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.joaoqueiroga = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    alsa-utils
    networkmanagerapplet
    pulsemixer
    wget
    nodejs
    bun
    (python3.withPackages python_packages)
    php83
    php83Packages.composer
    luajit
    gopass
    gopass-jsonapi
    htop
    btop
    killall
    file
    unzip
    zip
    xclip
    wl-clipboard
    llvmPackages.bintools
    rustup
    go
    gcc
    glibc
    openjdk
    dex
    ueberzugpp
    jq
    hurl
    vifm-full
  ];

  environment.binsh = "${pkgs.dash}/bin/dash";

  environment.variables = { XKB_DEFAULT_LAYOUT = "br"; };

  fonts.packages = with pkgs; [ nerdfonts ];

  system.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
}
