4everland-node
    This is the How to setup PoSC env spec of 4everland PoSC(Proof of Storage Challenge) protocol based on IPFS and Intel SGX.

Preparation work
    Hardware Check
        Ensure that you have one of the following required operating systems:
            Ubuntu* 18.04 LTS Desktop 64bits
            Ubuntu* 18.04 LTS Server 64bits

        Ensure that you have a system with the following required hardware:
            6th Generation Intel(R) Core(TM) Processor or
            You can use the check_sgx.c under the folder /tools to check your CPU and BIOS whether they support sgx
                 gcc check_sgx.c -o check_sgx   
                ./check_sgx



    Env install
        To install the sgx driver and PSW toolkit,run the script autoinstall.sh
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source $HOME/.cargo/env
        cd 4everland-node-docs
        sudo ./autoinstall.sh
        it will need some time.please be patient

    Docker install (If you want to run it in docker)
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

    Tips :After docker is installed, please open a new shell window for subsequent docker operations

IPFS install
    You can download the IPFS binary file from the IPFS github release page:IPFS release,version>=0.10.0 is recommend
      wget https://github.com/ipfs/go-ipfs/releases/download/v0.10.0/go-ipfs_v0.10.0_linux-amd64.tar.gz  
        tar -zxvf go-ipfs_v0.10.0_linux-amd64.tar.gz  sudo mv go-ipfs/ipfs /usr/local/bin/ipfs

    IPFS setup
        1.set the IPFS data path (set the data path to a large storage capacity directory which has >=4TB volume),LVM disk managment is recommended for increasing volume dynamically,How to use LVM and the LVM_TIPS under the folder /tools maybe useful.
            export IPFS_PATH=/path/to/ipfsrepo

    2.IPFS initialization
            ipfs init

    3.Run the IPFS
            nohup ipfs daemon --enable-pubsub-experiment &
        4.Check the IPFS config,the config file is under the folder IPFS_PATH/config,you can see:"API": "/ip4/127.0.0.1/tcp/5001",the default port number 5001 which will be used below


How to use
    1.Clone project
           git clone https://github.com/4everland/4everland-node-docs.git
           Run with default configuration
              cd bin  
                run the 4EVERLAND  by default
                    ./4everland  run



        executable options:
            Run './_4everland_ -h, --help' to show how to use 4everland-node.
            Run './_4everland_ -d, --data-path ' to use customized data store path, default: ~/.4everland/.
            Run './_4everland_ -u, --ipfs-url ', to use customized ipfs url, default: http://127.0.0.1:5001.
            Run './4everland -a, --addr ', to use customized http server addr, default: 127.0.0.1:5678.



How to use with docker
    custom executable options by modifying file docker/resource/start.sh
    build docker image:
        cd docker  
        docker build -t 4everland -f ./Dockerfile .

    run container:
          docker run --device=/dev/isgx -v ~/.4everland:/root/.4everland -v aesmd-socket:/var/run/aesmd --network host -itd  4everland


APIs
    When you start 4everland-node successfully,
    you can use following commands to get challenge report by ipfs id and blocknum:
         curl -XPOST http://<url:port>/report --data '{"ipfs_id": <xxx>,  "blocknum":0}'  -H 'Content-Type: application/json'
        Parameter:
            ipfs_id: Specifies the ipfs_id to be queried
            blocknum: Specifies the blocknum to be queried， 3 options values:
                "2000XXXX":return the blocknum 2000XXXX's report if exists;
                 "0":return all the report of the ipfs id;
                 "latest":return the newest report if the id



    Output:
        {"code":200,"msg":"{"27160200":{"check_size":180132164,"elapsed_time":67,"check_num":20,"success_rate":100,"cids":[["QmNZFzSw4VD25gXPRPFReTVhqcYBxxeqPDuNM9Kh9Uhpy6",true],["QmXA2LPdfqLmJe6NtS7HoigZDYuDDoU3V173qrQJQBjdtw",true],["QmXXhxapNrcWiNi1NjNiBeCz6raFbAhowqM1zNhMnXGPfp",true],["QmcgD41r998nsQcMtcPSFedKgcLf6Tj9n6gZ6Efb1jfihN",true],["Qma9A7viffoL9qjosFK3me7miJcKcRyqkfGVjApnALi4VL",true],["QmXrx5uteAuR4yuuZiW2YvE7oRuqLYwXb8tBSHv4r994kh",true],["QmXusPnUVCxEmAfphzHuothMBgTFZnDZPPyU4MvZKU6uFw",true],["QmNqigd9p7fJY6UVYgUUiy24TRsEoVMtYVYxcD5VWYh4tt",true],["QmQwfEhpsw17wnUCcPwtkf3FiFS2SEAVSGkCmeKsCC8qgs",true],["QmcEbeusrikfJi9E6Pz1iY9xSW5dYNNozmw2eKKcm8HWUr",true],["QmX6ATxbS1K2f5e5ff31hqVndZcvQ96VujbwShWXeK42jf",true],["QmayBd7ftR98kRYK5KKToaaKFhX7Zd9QizqwMBhTFSi4cf",true],["QmP2UYuiHDG3RcNtgSV2R2A82zLWLyzYekqJduWB7trNyC",true],["QmQ84PxwJL2Lhd6LQRGise8gKP6v5Qr5nUWSeXURuaRNQj",true],["QmZDR2hQBdzJYSAYDT4JKWCo4bTRuejDunUZeKE1yU8SoH",true],["QmesBKoKWwfBeAd3NuFA7RYtdZKDfUVjHJBipxD8fbgDnV",true],["QmNXn7P6cPNPNskhKm9f6vrAM9FExAmJfRqY4r5q36EAP9",true],["QmT1W46Gv3iqh3ki1LJBp6yZEAWXBcQZvqrHN8JHyf7G9M",true],["Qma8zfVtzc5QD4B3HnLvH3zWayVh3kCJQDiZZP38rJWpG4",true],["Qmaz5o35VyXrpJ9Y7k9sgRyRV9tCQUvMz362ko8jdpAm3u",true]]}}"}


Description:
    msg key: Block height at challenge time
    msg value:
        check_size: Total challenge file size
        elapsed_time: The total time spent on the challenge
        check_num: Total number of challenge files
        success_rate: Challenge success rate


you can use following commands to check if the cid has been pinned:
     curl -XPOST http://<url:port>/cid --data '{"cid": "xx"}'  -H 'Content-Type: application/json'
    Parameter:
        cid: Specifies the cid to be queried

    Output:
        {  "code":200,  "msg":"true"}

    Description:
        Return ture if the cid has been pinned.


you can use following commands to view basic node information:
     curl -XPOST http://<url:port>/info -H 'Content-Type: application/json'
    Output:
        {  "code":200,  "msg":"{"ipfs_id":"12D3KooWGTyrk9hEd1kkUk15G9BdkMdTJv1r6q2pimpyxFEgnZyr","mr_enclave":"a1988690f70cbe2b31a9bce7eff839d4e990c655922a3f488f2a89ef3d3a2594","node_count":4}"}

    Description:
        Return ipfs_id、mr_enclave and the number of current nodes.


