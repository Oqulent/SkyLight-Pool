genesis_file=/home/$USER/haskell_node/config/ff-genesis.json

#Calculating current KES-Period
startTimeGenesis=$(cat ${genesis_file} | jq -r .systemStart)
startTimeSec=$(date --date=${startTimeGenesis} +%s)
currentTimeSec=$(date -u +%s)
slotsPerKESPeriod=$(cat ${GENESIS_FILE} | jq -r .slotsPerKESPeriod)
slotLength=$(cat ${GENESIS_FILE} | jq -r .slotLength)
currentKESperiod=$(( (${currentTimeSec}-${startTimeSec}) / (${slotsPerKESPeriod}*${slotLength}) ))
echo "$currentKESperiod"

cardano-cli shelley node issue-op-cert \
    --kes-verification-key-file ~/haskell_node/hot-keys/kes.vkey \
    --cold-signing-key-file ~/haskell_node/cold-keys/cold.skey \
    --operational-certificate-issue-counter ~/haskell_node/cold-keys/coldcounter \
    --kes-period ${currentKESperiod} \
    --out-file ~/haskell_node/hot-keys/core.opcert

echo "opcert created!"
