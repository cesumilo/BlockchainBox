# Installing docker
echo "[INFO] Installing docker..."
sudo apt-get -y remove docker docker-engine
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot remove docker and/or docker-engine")
	exit 1
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

# Running chain.com using docker
echo "[INFO] Running chain.com using docker..."
sudo docker run -it -p 1999:1999 chaincore/developer
if [ "$?" != "0" ]; then
	(>&2 echo "[ERROR] Cannot run chain.com")
	exit 1
fi
echo "[INFO] Running chain.com using docker...OK."

# Open dashboard
echo "[INFO] Ooening chain.com dashboard..."
open http://localhost:1999
echo "[INFO] Ooening chain.com dashboard...OK."
