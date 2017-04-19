# Check usage of the script
if [ "$#" != 2 ]; then
	(>&2 echo -e "USAGE:\n\t./bitcoin-install.sh user password")
	exit 1
fi

# Clearning previous installation
echo "[INFO] Clearning previous installation..."
sudo rm -rf ~/.bitcoin
echo "[INFO] Clearning previous installation...OK."

# Add bitcoin repository
echo "[INFO] Adding bitcoin repository..."
sudo apt-add-repository ppa:bitcoin/bitcoin
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot add bitcoin repository")
	exit 1
fi
echo "[INFO] Adding bitcoin repository...OK."

# Update apt-get
echo "[INFO] Updating repositories..."
sudo apt-get update
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot update repositories to install bitcoin")
	exit 1
fi
echo "[INFO] Updating repositories...OK."

# Install bitcoin blockchain
echo "[INFO] Installing bitcoin blockchain..."
sudo apt-get install bitcoind
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install bitcoin")
	exit 1
fi
echo "[INFO] Installing bitcoin blockchain...OK."

# Settings Bitcoin
echo "[INFO] Applying bitcoin settings..."
mkdir ~/.bitcoin
echo "rpcpassword=$2\nrpcuser=$1" > ~/.bitcoin/bitcoin.conf
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot write bitcoin settings in $HOME/.bitcoin/bitcoin.conf")
	exit 1
fi
echo "[INFO] Applying bitcoin settings...OK."

echo "[INFO] Installation completed."
