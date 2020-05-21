#!/bin/bash

#this script assumes you have set CARDANO_NODE_SOCKET_PATH as an envornment variable in ~/.bashrc.
#if you haven't done so, see step 3 in https://github.com/input-output-hk/cardano-tutorials/blob/master/node-setup/address.md for detailed instructions.
#modify the section below to fit your environment

#___________________________________________
cli=cardano-cli
magic="--testnet-magic 42"
s_key="~/PATH/TO/YOUR.skey/FILE"
#___________________________________________

read -p "To how many addresses would you like to send ADA? " tx_out 
tx_out=$(($tx_out + 1))

read -p "From how many addresses do you wish to withdraw ADA? " tx_in 

#get protocol parameters, save them in a file
$cli shelley query protocol-parameters --testnet-magic 42 > prot.json


#pull slot height from the node
ttl_num=$($cli shelley query tip $magic | awk '$3=="{unSlotNo" {print $5}'| sed 's/})//')
echo "Current slot height" $ttl_num
((ttl_num=ttl_num+1000))

sleep 1
echo "ttl slot number used" $ttl_num
echo "_______________________________"
echo "Calculating tx fees..."
sleep 1

#Calculate tx fees...
 
$cli shelley transaction calculate-min-fee --tx-in-count $tx_in --tx-out-count $tx_out --ttl $ttl_num $magic --signing-key-file $s_key --protocol-params-file prot.json > tx_fee
echo "Sucess!"
echo "________________________________"
echo ""

sleep 1
echo "Your transaction fees: " $(cat tx_fee | sed 's/runTxCalculateMinFee://')

echo ""
echo ""

#clean up files...
rm prot.json tx_fee

exit 0



