# Add dependences repository
echo "[INFO] Adding NXT repositories..."
sudo apt-add-repository ppa:webupd8team/java
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot add dependencies repositories")
	exit 1
fi

# Update repositories
echo "[INFO] Updating repositories..."
sudo apt-get update
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot update repositories")
	exit 1
fi

# Installing dependencies
echo "[INFO] Installing dependencies..."
sudo apt-get install oracle-java8-installer
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install NXT dependencies")
	exit 1
fi

# Download NXT
echo "[INFO] Downloading NXT"
mkdir ~/.nxt
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot create NXT working directory")
	exit 1
fi

cd ~/.nxt

wget https://bitbucket.org/JeanLucPicard/nxt/downloads/nxt-client-1.11.4.zip
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot download NXT")
	exit 1
fi

sudo apt-get install zip unzip
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install unzip")
	exit 1
fi

unzip nxt-client-1.11.4.zip -d ~/.nxt
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot unzip NXT file")
	exit 1
fi

sudo rm nxt-client-1.11.4.zip
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot remove zip file")
	exit 1
fi

# Applying NXT properties
echo "[INFO] Applying NXT properties..."
echo -e "nxt.isTestNet=true\nnxt.shareMyAddress=false" > ~/.nxt/nxt/conf/nxt.properties
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot applying properties in $HOME/.nxt/nxt/conf")
	exit 1
fi

# Installing NXT
echo "[INFO] Installing NXT"
sudo ln -s ~/.nxt/nxt/run.sh /usr/bin/nxt 
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install NXT")
	exit 1
fi

echo "[INFO] Installation completed."
