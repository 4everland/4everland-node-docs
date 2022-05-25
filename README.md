# 4everland-node
This is the implementation binary directory of [4everland](https://4everland.org/) PoSC(Proof of Storage Challenge) protocol based on IPFS and Intel SGX.


## Preparation work

### Hardware Check
- Ensure that you have one of the following required operating systems:
  * Ubuntu\* 18.04 LTS Desktop 64bits
  * Ubuntu\* 18.04 LTS Server 64bits
- Ensure that you have a system with the following required hardware:
  * 6th Generation Intel(R) Core(TM) Processor or 
- You can use the check_sgx.c under the folder /tools to check your CPU and BIOS whether they support sgx
```
   gcc check_sgx.c -o check_sgx
   ./check_sgx
```



### Env install
- To install the sgx driver and PSW toolkit,run the script autoinstall.sh
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
cd PoSC-docs
sudo ./autoinstall.sh
```

### Docker install
- Compile 
```
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker ${USER}
  sudo systemctl restart docker
```
After docker is installed, please open a new shell window for subsequent docker operations
  
### IPFS install
- You can download the IPFS binary file from the IPFS github release page:[IPFS release](https://github.com/ipfs/go-ipfs/releases),version>=0.10.0 is recommend
```
  wget https://github.com/ipfs/go-ipfs/releases/download/v0.10.0/go-ipfs_v0.10.0_linux-amd64.tar.gz
  tar -zxvf go-ipfs_v0.10.0_linux-amd64.tar.gz
  sudo mv go-ipfs/ipfs /usr/local/bin/ipfs
```
- IPFS setup



  1.set the IPFS data path (set the data path to a large storage capacity directory which has >=4TB volume),LVM disk managment is recommended for increasing volume dynamically,[How to use LVM](https://opensource.com/business/16/9/linux-users-guide-lvm) and the LVM_TIPS under the folder /tools maybe useful.
```
    export IPFS_PATH=/path/to/ipfsrepo
```


  2.IPFS initialization
  
```
    ipfs init
```

  3.Run the IPFS
  
```
    nohup ipfs daemon --enable-pubsub-experiment &
```

  4.Check the IPFS config,the config file is under the folder IPFS_PATH/config,you can see:"API": "/ip4/127.0.0.1/tcp/5001",the default port number 5001 which will be used below
  

## How to use

### 1.Clone project
```
   git clone https://github.com/4everland/4everland-node-docs.git
```

### 2.How to run it

```
  cd bin
  ./_4everland_ run
```

-  executable options:
-  1. Run '**./\_4everland\_ -h, --help**' to show how to use ***4everland-node***.
   1. Run '**./\_4everland\_ -d, --data-path <data-path>**' to use customized data store path, default: ~/.4everland/.
   2. Run '**./\_4everland\_ -u, --ipfs-url <ipfs-url>**', to use customized ipfs url, default: http://127.0.0.1:5001.
   3. Run '**./\_4everland\_ -a, --addr <addr>**', to use customized http server addr, default: 127.0.0.1:5678.

## How to use with docker

- custom executable options by modifying file docker/resource/start.sh

- build docker image:
```
  cd docker
  docker build -t 4everland -f ./Dockerfile .
```

- run container:
```
  docker run --device=/dev/isgx -v ~/.4everland:/root/.4everland -v aesmd-socket:/var/run/aesmd --network host -itd  4everland
```

## APIs
When you start 4everland-node successfully, you can use following commands to get challenge report by ipfs id and blocknum:
```
  curl -XPOST http://<url:port>/report --data '{"ipfs_id": <xxx>,  "blocknum":0}'  -H 'Content-Type: application/json'
```
Parameter:
  1. ipfs_id: Specifies the ipfs_id to be queried
  2. blocknum: Specifies the blocknum to be queried， 3 options values:
```
     "2000XXXX":return the blocknum 2000XXXX's report if exists;
     "0":return all the report of the ipfs id;
     "latest":return the newest report if the id
```
 
Output:
```json
{
  "code":200,
  "msg":"{\"11\":{\"check_size\":891,\"elapsed_time\":1,\"check_num\":2,\"success_rate\":100}}"
}
```
Description:
  1. msg key: Block height at challenge time
  1. msg value: 
     - check_size: Total challenge file size 
     - elapsed_time: The total time spent on the challenge 
     - check_num: Total number of challenge files
     - success_rate: Challenge success rate 

you can use following commands to check if the cid has been pinned:
```
  curl -XPOST http://<url:port>/cid --data '{"cid": "xx"}'  -H 'Content-Type: application/json'
```
Parameter:
  1. cid: Specifies the cid to be queried

Output:
```json
{
  "code":200,
  "msg":"true"
}
```
Description:
  1. Return ture if the cid has been pinned.


you can use following commands to view basic node information:
```
  curl -XPOST http://<url:port>/info -H 'Content-Type: application/json'
```
Output:
```json
{
  "code":200,
  "msg":"{\"ipfs_id\":\"12D3KooWGTyrk9hEd1kkUk15G9BdkMdTJv1r6q2pimpyxFEgnZyr\",\"mr_enclave\":\"a1988690f70cbe2b31a9bce7eff839d4e990c655922a3f488f2a89ef3d3a2594\",\"node_count\":4}"
}
```
Description:
  1. Return ipfs_id、mr_enclave and the number of current nodes.


