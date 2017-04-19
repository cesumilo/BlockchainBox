# Clean previous installation
echo "[INFO] Clean previous installation..."
sudo rm -rf ~/.lisk
echo "[INFO] Clean previous installation...OK."

# Get installation script from lisk
echo "[INFO] Getting lisk installation script for test net..."
mkdir -p ~/.lisk/data
wget https://downloads.lisk.io/lisk/test/installLisk.sh
mv installLisk.sh ~/.lisk/
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot get testnet lisk installation script")
	exit 1
fi
echo "[INFO] Getting lisk installation script for test net...OK."

# Install lisk
echo "[INFO] Installing lisk..."
bash ~/.lisk/installLisk.sh install -r test -d "$HOME/.lisk/data" -n -0 no
echo "[INFO] Installing lisk...OK."

# Clean install environment
echo "[INFO] Cleaning install environment..."
sudo rm -rf lisk-Linux* installLisk*
echo "[INFO] Cleaning install environment...OK."

echo "[INFO] Installation completed. Open http://{IP of device running Lisk}:7000/"
