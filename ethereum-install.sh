# Install dependences for ethereum
echo "[INFO] Installing Ethereum depencies..."
sudo apt-get install software-properties-common
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install Ethereum dependencies from repositories")
	exit 1
fi

# Add Ethereum repositories
echo "[INFO] Adding Ethereum repositories..."
sudo apt-add-repository -y ppa:ethereum/ethereum
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot add ppa:ethereum/ethereum repository")
	exit 1
fi
sudo apt-add-repository -y ppa:ethereum/ethereum-dev
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot add ppa:ethereum/ethereum-dev repository")
	exit 1
fi

# Update repositories
sudo apt-get update
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot update repositories")
	exit 1
fi

# Install Ethereum
sudo apt-get install ethereum
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install ethereum")
	exit 1
fi

# Create genesis block
echo "[INFO] Initializing Ethereum Genesis"
mkdir -p ~/.ethereum/data
echo '{"nonce":"0x0000000000000042","timestamp":"0x0","parentHash":"0x0000000000000000000000000000000000000000000000000000000000000000","extraData":"0x0","gasLimit":"0x8000000","difficulty":"0x400","mixhash":"0x0000000000000000000000000000000000000000000000000000000000000000","coinbase":"0x3333333333333333333333333333333333333333","alloc":{}}' > ~/.ethereum/genesis_block.json
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot initialize Ethereum genesis")
	exit 1
fi

# Create new account in private network
echo "[INFO] Creating first Ethereum account"
geth --datadir ~/.ethereum/data account new
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot create new account on Ethereum")
	exit 1
fi

# Initialize Ethereum blockchain with our custom genesis block
echo "[INFO] Initialize Ethereum blockchain"
geth --datadir ~/.ethereum/data init ~/.ethereum/genesis_block.json
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot initialize Ethereum blockchain")
	exit 1
fi

echo "[INFO] Installation completed."
