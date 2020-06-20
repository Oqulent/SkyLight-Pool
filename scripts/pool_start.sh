#!/bin/bash

topology="/home/$USER/haskell_node/config/pool_topology.json"
database="/home/$USER/haskell_node/db_pool"
socket="/home/$USER/haskell_node/db/pool.socket"
config="/home/$USER/haskell_node/config/pool-config.json"
port=8082
host="127.0.0.1"


kes_skey="/home/$USER/haskell_node/hot-keys/kes.skey"
vrf_skey="/home/$USER/haskell_node/hot-keys/vrf.skey"
op_cert="/home/$USER/haskell_node/core.opcert"


cardano-node run --topology ${topology} --database-path ${database} --socket-path ${socket} --config ${config} --port ${port} --host-addr ${host} --shelley-kes-key ${kes_skey} --shelley-vrf-key ${vrf_skey} --shelley-operational-certificate ${op_cert}






