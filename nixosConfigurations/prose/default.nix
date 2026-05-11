{ pkgs, config, lib, ... }: {

  system.stateVersion = "25.11";

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  boot = {
    kernelParams = [
      "boot.shell_on_fail"
    ];
plymouth.enable = false;

  };

  # home-manager options: https://nix-community.github.io/home-manager/options.xhtml
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    # this means user-specific software and the configuration installed for joni
    users.joni = {
      home.stateVersion = config.system.stateVersion;
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        foot = {
          enable = true;
          settings = {
            mouse = {
              hide-when-typing = "yes";
            };
          };
        };
        git = {
          enable = true;
          ignores = [
            ".devenv"
            ".direnv"
            "result"
          ];
        };
      };
    };
  };

  networking = {
    hostName = "prose";
    wireless.iwd.enable = true;
  };
  time.timeZone = "Europe/Helsinki";

  users = {
    users.joni = {
      isNormalUser = true;
      uid = 1000;
      group = "joni";
      extraGroups = [
        "input"
        "video"
        "wheel"
      ];
      shell = pkgs.fish;
    };
    groups.joni = {
      gid = 1000;
    };
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = lib.mkForce false;
    };
  };

  hardware = {
    enableRedistributableFirmware = true; # enables WiFi and GPU drivers
    graphics.enable = true;
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/LE-Audio-+-LC3-support
    bluetooth.enable = true;
  };

  # services.yubikey-agent.enable = true;

  # Audio -- dont touch
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # general way to include a program for all users
  environment.systemPackages = with pkgs; [
    firefox
    foot
    niri
    rsync
    yazi
  ];
  # some programs also have modules which do additional work
  programs = {
    fish.enable = true;
    git.enable = true;
    vim = {
      enable = true;
      defaultEditor = true;
    };
  };


services.greetd = {
  enable = true;
  settings.default_session = {
    command = "niri-session";
    user = "joni";
  };
};

  systemd.sleep.extraConfig = ''
    HibernateOnACPower=no
  '';

}
