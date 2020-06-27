#!/bin/bash

# This is a helper script that follows the steps outlined in:
# https://github.com/input-output-hk/cardano-tutorials/blob/ecbfd0ec06e0515701ee3749ce96780c27d2249d/node-setup/080_register_stakepool.md 
# Please exercise caution while executing the script. The script requires some manual input from you to work properly... read the comments below.

# Save below into a json file named pool.json after chang the contents to match the details of your pool.

{
"name": "TestPool",
"description": "The pool that tests all the pools",
"ticker": "TEST",
"homepage": "https://teststakepool.com"
}

# get the metadata hash of the json file
metadata=cardano-cli shelley stake-pool metadata-hash --pool-metadata-file pool.json

# Create a pool certificate
cardano-cli shelley stake-pool registration-certificate \
--cold-verification-key-file ~/haskell_node/cold_keys/node1.vkey \
--vrf-verification-key-file ~/haskell_node/hot-keys/vrf1.vkey \
--pool-pledge 1000000000 \
--pool-cost 100000000 \
--pool-margin .05 \
--pool-reward-account-verification-key-file ~/haskell_node/hot_keys/stake1.vkey \
--pool-owner-stake-verification-key-file ~/haskell_node/hot_keys/stake1.vkey \
--testnet-magic 42 \
--pool-relay-port 3001 \
--pool-relay-ipv4 123.123.123.123 \
--metadata-url https://gist.githubusercontent.com/testPool/.../testPool.json \ # host your json file on internet and replace this url with the one for your json file
--metadata-hash $metadata \
--out-file ~/haskell_node/tmp/pool.cert


#create a delegation certificate
cardano-cli shelley stake-address delegation-certificate \
--stake-verification-key-file ~/haskell_node/hot_keys/stake1.vkey \
--cold-verification-key-file ~/haskell_node/cold_keys/node1.vkey \
--out-file ~/haskell_node/tmp/delegation.cert

#build transaction
cardano-cli shelley transaction build-raw \
--tx-in 9db6cf...#0 \ # get the utxo from your address with a balance
--tx-out $(cat ~/haskell_node/hot_keys/pay1.addr)+999499083081 \ #change the amount to suit your situation
--ttl 200000 \
--fee 184685 \
--out-file ~/haskell_node/tmp/tx.raw \
--certificate-file ~/haskell_node/tmp/pool.cert \
--certificate-file ~/haskell_node/tmp/delegation.cert

#sign transaction
cardano-cli shelley transaction sign \
--tx-body-file ~/haskell_node/tmp/tx.raw \
--signing-key-file ~/haskell_node/hot_keys/pay1.skey \
--signing-key-file ~/haskell_node/hot_keys/stake1.skey \
--signing-key-file ~/haskell_node/cold_keys/node1.skey \
--testnet-magic 42 \
--out-file ~/haskell_node/tmp/tx.signed

#submit transaction
cardano-cli shelley transaction submit \
--tx-file ~/haskell_node/tmp/tx.signed \
--testnet-magic 42