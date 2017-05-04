# Cleaning previous installation
echo "[INFO] Clearning previous installation..."
sudo rm -rf ~/.hyperledger
echo "[INFO] Clearning previous installation...OK."

# Installing docker
echo "[INFO] Installing docker..."
sudo apt-get -y remove docker docker-engine
if [ "$?" != "0" ]; then
	(>&2 echo "[WARNING] Cannot remove docker and/or docker-engine")
fi
sudo apt-get -y autoremove
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install dependencies to use https repository")
	exit 1
fi
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot get the GPG docker key")
	exit 1
fi
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot add the repository to apt")
	exit 1
fi
sudo apt-get update
sudo apt-get -y install docker-ce
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install docker-ce")
	exit 1
fi
echo "[INFO] Installing docker...OK."

# Clone Hyperledger repository
echo "[INFO] Cloning Hyperledger repository..."
mkdir -p ~/.hyperledger/git/src/github.com/hyperledger/fabric
git clone https://github.com/hyperledger/fabric.git ~/.hyperledger/git/src/github.com/hyperledger/fabric
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot clone github repository of Hyperledger")
	exit 1
fi
echo "[INFO] Cloning Hyperledger repository...OK."

# Install go
echo "[INFO] Installing go environment..."
cd /tmp
wget https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot download go environment")
	exit 1
fi
sudo tar -xvf go1.7.4.linux-amd64.tar.gz
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot extract go environment")
	exit 1
fi
sudo rm -rf /usr/local/go /usr/bin/go
sudo mv go /usr/local
sudo ln -s /usr/local/go/bin/go /usr/bin/go
if [ "$?" != "0" ]; then
	(>&2 echo "[WARNING] Cannot move go repository")
	exit 1
fi
echo "[INFO] Installing go environment...OK."
echo "[INFO] Cleaning installation environment..."
sudo rm -rf /tmp/go /tmp/go1*
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot clean installation environment")
	exit 1
fi
echo "[INFO] Cleaning installation environment...OK."

# Setup environment
echo "[INFO] Setting up hyperledger installation environment..."
export GOPATH="$HOME/.hyperledger/git"
export GOROOT="/usr/local/go"
echo "[INFO] Setting up hyperledger installation environment...OK."

# Install configtxgen dependencies
echo "[INFO] Installing configtxgen dependencies..."
sudo apt-get -y install libtool libltdl-dev
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install configtxgen dependencies")
	exit 1
fi
echo "[INFO] Installing configtxgen dependencies...OK."

# Make configtxgen binary
echo "[INFO] Making configtxgen binary..."
cd ~/.hyperledger/git/src/github.com/hyperledger/fabric
make configtxgen
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot make configtxgen binary")
	exit 1
fi
echo "[INFO] Making configtxgen binary...OK."

# Download docker images
echo "[INFO] Downloading docker images for hyperledger..."
cd ~/.hyperledger/git/src/github.com/hyperledger/fabric/examples/e2e_cli
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] $HOME/.hyperledger/git/fabric/examples/e2e_cli: No such file or directory")
	exit 1
fi
chmod +x download-dockerimages.sh
./download-dockerimages.sh
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot download docker images")
	exit 1
fi
echo "[INFO] Downloading docker images for hyperledger...OK."

# Installation done
echo "[INFO] Installation completed."
