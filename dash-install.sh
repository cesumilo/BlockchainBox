# Check usage of the script
if [ "$#" != "2" ]; then
	(>&2 echo -e "USAGE:\n\t./dash-install.sh user password")
	exit 1
fi

# Cleaning previous installation
echo "[INFO] Cleaning previous installation..."
sudo rm -rf ~/.dash
echo "[INFO] Cleaning previous installation...OK."

# Creating working directory for dash
echo "[INFO] Creating working directory for Dash..."
mkdir ~/.dash
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot create the Dash directory")
	exit 1
fi

# Downloading Dash
echo "[INFO] Downloading Dash..."
cd ~/.dash
wget https://bamboo.dash.org/artifact/DASHL-DEV/JOB1/build-latestSuccessful/gitian-linux-dash-dist/dashcore-0.12.1-linux64.tar.gz
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot download Dash")
	exit 1
fi

tar xvzf dashcore-0.12.1-linux64.tar.gz
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot extract Dash from tar.gz")
	exit 1
fi

rm dashcore-0.12.1-linux64.tar.gz
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot remove the file called dashcore-0.12.1-linux64.tar.gz")
	exit 1
fi

# Installing Dash
echo "[INFO] Installing Dash..."
mkdir -p ~/.dash/data
sudo cp ~/.dash/dashcore-0.12.1/bin/dashd /usr/bin/dashd
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot copy dashd binary")
	exit 1
fi

sudo cp ~/.dash/dashcore-0.12.1/bin/dash-cli /usr/bin/dash-cli
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot copy dash-cli binary")
	exit 1
fi

# Setup Dash configurations
echo "[ERROR] Applying Dash configurations..."
echo -e "rpcuser=$1\nrpcpassword=$2" > ~/.dash/dash.conf
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot apply configurations in $HOME/.dash directory")
	exit 1
fi

# Running Dash daemon
echo "[INFO] Running Dash daemon..."
dashd -datadir="$HOME/.dash/data" -regtest -daemon
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot run Dash daemon...")
	exit 1
fi

echo "[INFO] Installation completed."
