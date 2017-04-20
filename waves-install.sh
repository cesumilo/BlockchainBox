# Clean installation environment
echo "[INFO] Cleaning installation environment..."
sudo rm -rf ~/.waves
echo "[INFO] Cleaning installation environment...OK."

# Install dependencies
echo "[INFO] Installing dependencies..."
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install oracle java8 installer")
	exit 1
fi
echo "[INFO] Installing dependencies...OK."

# Download test net release from waves
echo "[INFO] Downloading waves testnet packages..."
cd /tmp
sudo rm -rf waves*
wget https://github.com/wavesplatform/Waves/releases/download/v0.6.4/waves-testnet-systemd-0.6.4.deb
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot download testnet systemd package")
	exit 1
fi
echo "[INFO] Downloading waves testnet packages...OK."

# Installation waves packages
echo "[INFO] Installing waves..."
sudo dpkg -i waves*.deb
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install waves from packages")
	exit 1
fi
echo "[INFO] Installing waves...OK."

echo "[INFO] Installation completed."
