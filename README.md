# nixos-configuration


## First time stuff
``` bash
# install git
nix-env -iA nixos.git

#copy the ssh key into ~/.ssh
#add ssh key to the agent
ssh-add ~/.ssh/a.sarisin 

#test github
ssh -T git@github.com

# clone this repository
git clone git@github.com:AltanS/nixos-configuration.git

# rebuild from flake
sudo nixos-rebuild switch --flake ./#nixos-vm-conqueror

# add new hosts configuration
# REPLACE NEW_HOST
sudo nixos-generate-config --show-hardware-config > nixos-config/hosts/NEW_HOST/hardware-configuration.nix

# activate home manager
nix run home-manager -- switch --flake .#altan
```