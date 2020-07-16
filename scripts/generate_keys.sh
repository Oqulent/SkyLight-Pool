#!/bin/bash
mkdir ~/haskell_node/hot_keys
mkdir ~/haskell_node/cold_keys
directory=/home/$USER/haskell_node/hot_keys


#1. generate payment keys
cd $directory
cardano-cli shelley address key-gen --verification-key-file pay1.vkey --signing-key-file pay1.skey 

#2. generate stake keys
cardano-cli shelley stake-address key-gen --verification-key-file stake1.vkey --signing-key-file stake1.skey 

#3. generate vrf keys
cardano-cli shelley node key-gen-VRF --verification-key-file vrf1.vkey --signing-key-file vrf1.skey 

#4. generate kes keys
cardano-cli shelley node key-gen-KES --verification-key-file kes1.vkey --signing-key-file kes1.skey 

#5. generate cold keys
cd ~/haskell_node/cold_keys
cardano-cli shelley node key-gen --cold-verification-key-file node1.vkey --cold-signing-key-file node1.skey --operational-certificate-issue-counter-file node1.counter
cd ~/haskell_node/hot_keys 

#6. generate a stake address
cardano-cli shelley stake-address build --stake-verification-key-file stake1.vkey --out-file stake1.addr --mainnet

#7. generate a payment address that delegates to a stake address from 6
cardano-cli shelley address build --payment-verification-key-file pay1.vkey --stake-verification-key-file stake1.vkey --out-file pay1.addr --mainnet

#7. get funds from the faucet
