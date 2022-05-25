#!/bin/bash
set -e
set -x
apt update
apt install -y make protobuf-compiler libprotobuf-dev libssl-dev libcurl4-openssl-dev
./sgx_linux_x64_psw*.bin --no-start-aesm
export LD_LIBRARY_PATH=/opt/intel/sgxpsw/aesm/
/opt/intel/sgxpsw/aesm/aesm_service --no-daemon &
sleep 10
ps aux | grep aesm
./_4everland_ run
