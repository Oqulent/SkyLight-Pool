#!/bin/bash
source ~/.bashrc

topology="/home/$USER/haskell_node/config/ff-topology.json"
database="/home/$USER/haskell_node/db"
socket="/home/$USER/haskell_node/db/node1.socket"
config="/home/$USER/haskell_node/config/ff-config.json"
port=8081

cardano-node run \
     --topology $topology \
     --database-path $database \
     --socket-path $socket \
     --host-addr 127.0.0.1 \
     --config $config\
     --port $port
