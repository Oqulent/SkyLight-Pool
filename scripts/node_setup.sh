#!/bin/bash

echo "________________________________________________________________________________"
echo "This bash script will install the required libraries, ghcup and cabal. It will then clone the cardano-node and build the cardano friends & family haskell node..."
echo "and has been tested on Ubuntu 18.04."
echo "The script comes with no warranty. Please exercise caution and use at your own risk."
echo "You chould be at your desk to respond to prompts as they appear."
echo ""
echo ""
echo "________________________________________________________________________________"

echo "checking for updates/upgrades for your system"

#1. update/upgrade system
sudo apt update && sudo apt upgrade -y

echo ""
echo ""
echo "Installing the required libraries..." 

#2. get the required libraries
sudo apt -y install build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq git wget libncursesw5 -y

echo ""
echo ""
echo "installing ghcup--a Haskell installer toolchain"

#3. fetch + install ghcup
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

echo ""
echo ""
echo "installing ghc 8.6.5 and setting it as a default compiler" 

#4. install ghc 8.6.5, set it as the default compiler
ghcup install 8.6.5
ghcup set 8.6.5

echo ""
echo ""
echo "Installing Cabal..." 

#5. install cabal
ghcup install cabal

echo ""
echo ""
echo "Checking if the correct versions ghc(8.6.5) and cabal(3.2.0.0) have been installed..." 

#6. check ghc/cabal versions
echo $(ghc --version)
echo $(cabal --version)

echo ""
echo ""
echo "Git clone the cardano-node checkout a preferred tag" 

#7. clone the cardano-node repository, checkout the preferred tag
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --all --tags
read -p "Please enter your preferred tag " cardano_build 
git checkout $cardano_build
git checkout -b $cardano_build


echo ""
echo ""
echo "Building the Cardano node..." 

#8. Build the node
cabal build all

echo ""
echo ""
echo "Creating symlinks... "

#9. create symlinks for future updates
ln -sf /home/$USER/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-node-1.12.0/x/cardano-node/build/cardano-node/cardano-node /home/$USER/.local/bin/
ln -sf /home/$USER/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-cli-1.12.0/x/cardano-cli/build/cardano-cli/cardano-cli /home/$USER/.local/bin/
cd ~/.local/bin/
ls -lrt

#10. add ./local/bin to the PATH
export PATH="~/.local/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

#11. create a directory structure for the node, copy files to run F&F relay node
cd ~
mkdir haskell_node
cd haskell_node && mkdir scripts logs db config

#12. download configuration files, scripts, etc--TBD

#13. start the node--TBD
 
echo "Installation complete!"

exit 0
