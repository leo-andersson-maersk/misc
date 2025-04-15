# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
{


nixpkgs.config.allowUnfree = true;
imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
];
# Enable the Flakes feature and the accompanying new nix command-line tool
nix.settings.experimental-features = [ "nix-command" "flakes" ];


environment.systemPackages = with pkgs; [
	wget
	libsecret
	python3
];
programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
};
programs.git = {
    enable = true;
    lfs.enable = true;
  };
programs.neovim = {
  	enable = true;
	viAlias = true;
  	vimAlias = true;
};
environment.variables.EDITOR = "vim";

programs.zsh.enable = true;
users.defaultUserShell = pkgs.zsh;

  wsl.enable = true;
  wsl.defaultUser = "nixos";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

nix.optimise.automatic = true;
nix.optimise.dates = ["weekly"]; # Optional; allows customizing optimisation schedule

# Limit the number of generations to keep
boot.loader.systemd-boot.configurationLimit = 10;  
  
nix.settings.auto-optimise-store = true;

# Weekly garbage collection
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};


system.autoUpgrade = {
  enable = true;
  flags = [
    "--update-input"
    "nixpkgs"
    "--print-build-logs"
  ];
  dates = "weekly";
};
}

