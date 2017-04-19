# Cloning repository
echo "[INFO] Cloning Corda repository..."
mkdir -p ~/.corda/git/corda
git clone https://github.com/corda/corda ~/.corda/git/corda
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot clone Corda repository")
	exit 1
fi

# Cloning Corda app template
echo "[INFO] Cloning Corda App Template..."
mkdir -p ~/.corda/git/cordapp-template
git clone https://github.com/corda/cordapp-template ~/.corda/git/cordapp-template
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot clone Corda App Template repository")
	exit 1
fi

# Deploy Corda Nodes
echo "[INFO] Deploying Corda Nodes..."
cd ~/.corda/git/cordapp-template
git checkout -b m7 tags/release-M7.0
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot checkout release 7.0")
	exit 1
fi
./gradlew deployNodes
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot deploy Corda nodes")
	exit 1
fi

# Install Corda
echo "[INFO] Installing Corda..."
cd ~/.corda/git/corda
git checkout -b m7 tags/release-M7.0
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot checkout release 7.0")
	exit 1
fi
./gradlew install
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot install Corda")
	exit 1
fi

echo "[INFO] Use IntelliJ to finish installation."
