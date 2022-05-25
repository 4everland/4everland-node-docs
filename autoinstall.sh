#!/bin/bash
set -e
set -x
apt install -y build-essential ocaml ocamlbuild automake autoconf libtool wget python libssl-dev git cmake perl pkg-config
apt install -y libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake reprepro unzip curl

git clone -b sgx_diver_2.14 https://github.com/intel/linux-sgx-driver.git
cd linux-sgx-driver && make
mkdir -p "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"
cp isgx.ko "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"
sh -c "cat /etc/modules | grep -Fxq isgx || echo isgx >> /etc/modules"
/sbin/depmod
/sbin/modprobe isgx
cd ..

./docker/resource/sgx_linux_x64_sdk_2.15.100.3.bin << EOF
no
/opt/intel
EOF

./docker/resource/sgx_linux_x64_psw_2.15.100.3.bin
