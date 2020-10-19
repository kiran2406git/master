#!/bin/sh

# Install Build Tools
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt
#echo "Installing build-essential package" >> /home/$5/install.progress.txt
#echo "Installing build-essential package" >> /home/$5/install.progress.txt
sudo apt-get -y install build-essential
echo "build-essential package installation completed" >> /home/$5/install.progress.txt
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt

echo "Installing packaging-dev package" >> /home/$5/install.progress.txt
sudo apt-get -y install packaging-dev
echo "packaging-dev package installation completed" >> /home/$5/install.progress.txt
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt

sudo -u $5 mkdir /home/$5/downloads
sudo -u $5 mkdir /home/$5/lib
sudo -u $5 mkdir /home/$5/agent1

# Install NodeJS, npm, and gulp

echo "Installing NodeJS package" >> /home/$5/install.progress.txt
sudo curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
echo "NodeJS package installation completed" >> /home/$5/install.progress.txt
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt

echo "Installing npm package" >> /home/$5/install.progress.txt
sudo npm install -g npm@latest
#sudo -u $5 npm install gulp --save-dev
echo "npm package installation completed" >> /home/$5/install.progress.txt
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt

echo "Installing zip package" >> /home/$5/install.progress.txt
#install zip package
sudo apt-get -y install zip
echo "zip installation completed" >> /home/$5/install.progress.txt
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt

echo "Installing powershell & Az module package" >> /home/$5/install.progress.txt
#Install latest powershell & Az module
# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Update the list of products
sudo apt-get update
# Install PowerShell
sudo apt-get install -y powershell
#install Az module
sudo pwsh -Command Install-Module -Name Az -AllowClobber -Force -AcceptLicense
sudo pwsh -Command Import-Module -Name Az
echo "powershell & Az module installation completed" >> /home/$5/install.progress.txt
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt

# Install latest release of .NET Core
echo "Installing .NET" >> /home/$5/install.progress.txt
sudo -u $5 mkdir /home/$5/lib/dotnet
cd /home/$5/downloads
sudo -u $5 wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get -y install apt-transport-https
sudo apt-get -y update
sudo apt-get -y install dotnet-runtime-2.0.6
#cd /home/$5/lib/dotnet
#sudo -u $5 tar zxfv /home/$5/downloads/dotnet-ubuntu.16.04-x64.latest.tar.gz
sudo apt-get -y install apt-transport-https
sudo apt-get -y update
sudo apt-get -y install dotnet-sdk-2.2
echo ".NET installation completed" >> /home/$5/install.progress.txt
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt

# Install Docker Engine and Compose
echo "Installing Docker Engine and Compose" >> /home/$5/install.progress.txt
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg  | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce=$6 docker-ce-cli=$6

sudo service docker start
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $5


COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
echo "Docker Engine and Compose installation completed" >> /home/$5/install.progress.txt
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt

# Install VSTS build agent dependencies

echo "Installing libunwind8 and libcurl3 package" >> /home/$5/install.progress.txt
sudo apt-get -y install libunwind8 libcurl3
echo "libunwind8 and libcurl3 installation completed" >> /home/$5/install.progress.txt
sudo /bin/date +%H:%M:%S >> /home/$5/install.progress.txt



echo "Installing first build agent" >> /home/$5/install.progress.txt
echo "Downloading VSTS Build agent package" >> /home/$5/install.progress.txt
cd /home/$5
#---------------------------------------------------------------------------------------------------------------
#set -e

echo "creating build agent" $i>> /home/$5/install.progress.txt
#provide the path where the agent will install and run, home for the agent

export VSTS_HOME=/home/$5/agent1

#Provide the work directoy
export VSTS_WORK=$VSTS_HOME/agent/_work
cd $VSTS_HOME

VSTS_AGENT=$4
VSTS_ACCOUNT=$1
VSTS_POOL=$3
VSTS_TOKEN=$2

sudo -u $5 mkdir -p "$VSTS_WORK"

if [ ! -e $VSTS_HOME/.token ]; then
echo "creating token file" >> /home/$5/install.progress.txt
touch $VSTS_HOME/.token
fi

if [ -z "$VSTS_TOKEN_FILE" ]; then
  if [ -z "$VSTS_TOKEN" ]; then
	echo 1>&2 error: missing VSTS_TOKEN environment variable
	exit 1
  fi
  echo "assigning token to token file" >> /home/$5/install.progress.txt
  VSTS_TOKEN_FILE=$VSTS_HOME/.token
  echo "token file: " $VSTS_TOKEN_FILE >> /home/$5/install.progress.txt
  echo -n $2 > "$VSTS_TOKEN_FILE"
fi
  
#. env.sh
#export VSO_AGENT_IGNORE=_,MAIL,OLDPWD,PATH,PWD,VSTS_AGENT,VSTS_ACCOUNT,VSTS_TOKEN_FILE,VSTS_TOKEN,VSTS_POOL,VSTS_WORK,VSO_AGENT_IGNORE

if [ $(dpkg-query -W -f='${Status}' jq 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
echo "Installing jq package" >> /home/$5/install.progress.txt
sudo apt-get update
sudo apt-get install -y jq
echo "jq installation completed" >> /home/$5/install.progress.txt
fi


if [ -n "$VSTS_AGENT" ]; then
  export VSTS_AGENT="$(eval echo $VSTS_AGENT)"
fi

if [ -n "$VSTS_WORK" ]; then
  export VSTS_WORK="$(eval echo $VSTS_WORK)"
  sudo -u $5 mkdir -p "$VSTS_WORK"
fi

#touch /vsts/.configure
#rm -rf $VSTS_HOME/agent
#sudo -u $5 mkdir $VSTS_HOME/agent
cd $VSTS_HOME/agent


echo "Determining matching VSTS agent..." >> /home/$5/install.progress.txt
VSTS_AGENT_RESPONSE=$(curl -LsS \
  -u user:$(cat "$VSTS_TOKEN_FILE") \
  -H 'Accept:application/json;api-version=3.0-preview' \
  "https://$VSTS_ACCOUNT.visualstudio.com/_apis/distributedtask/packages/agent?platform=linux-x64")
echo "-------------------------------------------------------------------" >> /home/$5/install.progress.txt
  echo "VSTS_AGENT_RESPONSE: " $VSTS_AGENT_RESPONSE >> /home/$5/install.progress.txt
echo "-------------------------------------------------------------------" >> /home/$5/install.progress.txt

if echo "$VSTS_AGENT_RESPONSE" | jq . >/dev/null 2>&1; then
  VSTS_AGENT_URL=$(echo "$VSTS_AGENT_RESPONSE" \
	| jq -r '.value | map([.version.major,.version.minor,.version.patch,.downloadUrl]) | sort | .[length-1] | .[3]')
   
fi
echo "-------------------------------------------------------------------" >> /home/$5/install.progress.txt
echo "VSTS_AGENT_URL: " $VSTS_AGENT_URL >> /home/$5/install.progress.txt
echo "-------------------------------------------------------------------" >> /home/$5/install.progress.txt

if [ -z "$VSTS_AGENT_URL" -o "$VSTS_AGENT_URL" == "null" ]; then
  echo 1>&2 error: could not determine a matching VSTS agent - check that account \'$1\' is correct and the token is valid for that account
  exit 1
fi


echo "Downloading and installing VSTS agent...">> /home/$5/install.progress.txt
curl -fkSL -o vstsagent.tar.gz $VSTS_AGENT_URL
tar zxvf vstsagent.tar.gz --no-same-owner & wait $!
#curl -LsS $VSTS_AGENT_URL | tar -xz --no-same-owner & wait $!

echo "Download completed" >> /home/$5/install.progress.txt
#source ./env.sh
echo "Configuring Agent" >> /home/$5/install.progress.txt
echo "${VSTS_AGENT:-$(hostname)}" >> /home/$5/install.progress.txt
echo "https://$VSTS_ACCOUNT.visualstudio.com" >> /home/$5/install.progress.txt
echo $(cat "$VSTS_TOKEN_FILE") >> /home/$5/install.progress.txt
echo "${VSTS_POOL:-Default}" >> /home/$5/install.progress.txt
echo "${VSTS_WORK:-_work}" >> /home/$5/install.progress.txt
./bin/Agent.Listener configure --unattended --agent "${VSTS_AGENT:-$(hostname)}" --url "https://dev.azure.com/$VSTS_ACCOUNT" --auth PAT --token $(cat "$VSTS_TOKEN_FILE") --pool "${VSTS_POOL:-Default}" --work "${VSTS_WORK:-_work}" --replace 

echo "Configuring completed" >> /home/$5/install.progress.txt
#./bin/Agent.Listener run &
echo "Installing agent service" >> /home/$5/install.progress.txt
sudo ./svc.sh install
echo "Agent as service installed" >> /home/$5/install.progress.txt
echo "starting service" >> /home/$5/install.progress.txt
sudo ./svc.sh start
echo "Service started" >> /home/$5/install.progress.txt


echo "----------------------------------------------------------------------------------------" >> /home/$5/install.progress.txt
