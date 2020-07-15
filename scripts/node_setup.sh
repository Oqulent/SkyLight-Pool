#!/bin/bash

echo "____________________________________________________________________________"
echo "This bash script will install the required libraries, ghcup and cabal. "
echo "It will then clone the cardano-node and build the cardano friends & family haskell node..."
echo "and has been tested on Ubuntu 18.04."
echo "The script comes with no warranty. Please exercise caution and use at your own risk."
echo "You should be at your desk to respond to prompts as they appear."
echo ""
echo ""
echo "____________________________________________________________________________"

echo "checking for updates/upgrades for your system"

#1. update/upgrade system
sudo apt update && sudo apt upgrade -y

echo ""
echo ""
sleep 5
echo "Installing the required libraries..." 

#2. get the required libraries
sudo apt -y install build-essential libtool curl tmux pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq git wget libncursesw5 -y

echo ""
echo ""
sleep 5
echo "installing ghcup--a Haskell installer toolchain"

#3. fetch + install ghcup
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

echo ""
echo ""
sleep 5
echo "installing ghc 8.6.5 and setting it as a default compiler" 

#4. install ghc 8.6.5, set it as the default compiler
source ~/.bashrc
ghcup install 8.6.5
ghcup set 8.6.5

echo ""
echo ""
echo "Installing Cabal..." 

#5. install cabal
ghcup install-cabal

echo ""
echo ""
sleep 5
echo "Checking if the correct versions ghc(8.6.5) and cabal(3.2.0.0) have been installed..." 

#6. check ghc/cabal versions
echo $(ghc --version)
echo $(cabal --version)

echo ""
echo ""
sleep 5
echo "Git clone the cardano-node checkout a preferred tag. " 

#7. build the required libsodium library
git clone https://github.com/input-output-hk/libsodium.git
cd libsodium
git checkout git checkout 66f017f1
./autogen.sh
./configure 
make 
sudo make install 

export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

#8. clone the cardano-node repository, checkout the preferred tag

git clone https://github.com/input-output-hk/cardano-node.git

cd cardano-node
git fetch --tags && git tag

read -p "Please enter your preferred tag. This script has been tested on 1.15.1 " cardano_build 
git checkout $cardano_build
git checkout -b $cardano_build
echo "package cardano-crypto-praos\n  flags: -external-libsodium-vrf\n" > cabal.project.local

echo ""
echo ""
sleep 5
echo "Building the Cardano node..." 

#9. Build the node
cabal build all

echo ""
echo ""
sleep 5
echo "Creating symlinks... "

#10. create symlinks for future updates
if [ ! -d "~/.local/bin" ]; then
  mkdir ~/.local/bin
fi

ln -sf /home/$USER/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-node-$cardano_build/x/cardano-node/build/cardano-node/cardano-node /home/$USER/.local/bin/
ln -sf /home/$USER/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-cli-$cardano_build/x/cardano-cli/build/cardano-cli/cardano-cli /home/$USER/.local/bin/
cd ~/.local/bin/
ls -lrt
echo "please check to see if the generated links are valid (green)..."
sleep 10

#11. add ./local/bin to the PATH
export PATH="~/.local/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

#12. create a directory structure for the node, copy files to run F&F relay node
cd ~
mkdir haskell_node
cd haskell_node && mkdir scripts logs db config
cd config

#13. download configuration files, scripts, etc
wget https://hydra.iohk.io/build/3416851/download/1/mainnet_candidate-config.json
wget https://hydra.iohk.io/build/3416851/download/1/mainnet_candidate-byron-genesis.json
wget https://hydra.iohk.io/build/3416851/download/1/mainnet_candidate-shelley-genesis.json
wget https://hydra.iohk.io/build/3416851/download/1/mainnet_candidate-topology.json

#14. download a start_script for a relay node
cd ../scripts
wget https://raw.githubusercontent.com/Oqulent/SkyLight-Pool/master/scripts/start_node.sh
chmod +x start_node.sh
./start_node.sh
