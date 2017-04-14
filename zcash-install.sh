# Check usage of the script
if [ "$#" != 2 ]; then
	(>&2 echo -e "USAGE:\n\t./zcash-install.sh user password")
	exit 1
fi

# Install dependencies
echo "[INFO] Installing ZCash dependencies..."
sudo apt-get install build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python zlib1g-dev wget bsdmainutils automake
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install ZCash dependencies")
	exit 1
fi

# Installing ZCash
echo "[INFO] Getting ZCash from git..."
mkdir -p ~/.zcash/git ~/.zcash/data
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot create the working directory of ZCash")
	exit 1
fi

git clone https://github.com/zcash/zcash.git ~/.zcash/git
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot clone the repository of ZCash")
	exit 1
fi

cd ~/.zcash/git
git checkout v1.0.0-beta2
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot checkout repository of ZCash")
	exit 1
fi

# Fetch ZCash parameters
echo "[INFO] Fetching ZCash parameters (takes ~5mins)..."
./zcutil/fetch-params.sh
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot fetch ZCash parameters")
	exit 1
fi

echo "[INFO] Removing generated testnet..."
rm -rf ~/.zcash/testnet3

# Compile and build ZCash
echo "[INFO] Compiling and Building ZCash (takes ~25mins)..."
./zcutil/build.sh -j$(nproc)

# Applying configurations to ZCash
echo "[INFO] Applying ZCash configurations..."
echo -e "testnet=1\naddnode=testnet.z.cash\nrpcuser=$1\nrpcpassword=$2\ngen=1" > ~/.zcash/zcash.conf
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot apply ZCash configurations...")
	exit 1
fi

# Install ZCash
echo "[INFO] Installing ZCash..."
sudo ln -s $HOME/.zcash/git/src/zcashd /usr/bin/zcashd
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install zcashd")
	exit 1
fi
sudo ln -s $HOME/.zcash/git/src/zcash-cli /usr/bin/zcash-cli
if [ "$?" != "0" ]; then
	(>2& echo "[ERROR] Cannot install zcash-cli")
	exit 1
fi

echo "[INFO] Installation completed."
