#!/bin/sh

GITHUB_OWNER1="Pugmatt"
GITHUB_REPO1="BedrockConnect"
GITHUB_OWNER2="DownThePark"
GITHUB_REPO2="SetHome"
GITHUB_OWNER3="EssentialsX"
GITHUB_REPO3="Essentials"

# URL to GitHub API for fetching the latest release
API_URL_BC="https://api.github.com/repos/$GITHUB_OWNER1/$GITHUB_REPO1/releases/latest"
API_URL_SH="https://api.github.com/repos/$GITHUB_OWNER2/$GITHUB_REPO2/releases/latest"
API_URL_EX="https://api.github.com/repos/$GITHUB_OWNER3/$GITHUB_REPO3/releases/latest"

# Use curl to fetch the latest release data and jq to parse the JSON for the .jar file's URL
# Note: Install jq if you haven't (e.g., sudo apt-get install jq)
JAR_URL_BC=$(curl -s $API_URL_BC | jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url')
JAR_URL_SH=$(curl -s $API_URL_SH | jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url')
JAR_URL_EX=$(curl -s $API_URL_EX | jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url' | head -n 1)

#Install packages (remove for container installation and implement this in your Dockerfile)
sudo dnf update -y
sudo dnf install bind-utils wget curl git java-1.8.0-openjdk.x86_64 java-17-openjdk.x86_64 -y
sudo firewall-cmd --zone=public --add-port=25565/tcp --permanent
sudo firewall-cmd --zone=public --add-port=19132/udp --permanent
sudo firewall-cmd --zone=public --add-port=19133/udp --permanent
sudo firewall-cmd --reload

#Create Directories
mkdir $HOME/minecraft-server
mkdir $HOME/minecraft-backup
mkdir -p $HOME/minecraft-server/plugins

#Pull latest Bedrock Connect and place jar in minecraft folder
if [[ $JAR_URL_BC == http* ]]; then
  # Use wget or curl to download the .jar file
  cd $HOME/minecraft-server
  echo "Downloading $JAR_URL_BC..."
  curl -L $JAR_URL_BC -o bedrock-connect.jar
  echo "Download completed: bedrock-connect.jar"
else
  echo "Failed to find a .jar file in the latest release."
fi

#Geyser Spigot download
cd $HOME/minecraft-server/plugins
echo "Downloading Geyser Spigot..."
curl -L https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -o geyser-spigot.jar
echo "Download completed: geyser-spigot.jar"

#Pull latest SetHome Plugin
if [[ $JAR_URL_SH == http* ]]; then
  # Use wget or curl to download the .jar file
  cd $HOME/minecraft-server/plugins
  echo "Downloading $JAR_URL_SH..."
  curl -L $JAR_URL_SH -o set-home.jar
  echo "Download completed: set-home.jar"
else
  echo "Failed to find a .jar file in the latest release."
fi

#Pull latest Essentials Plugin
if [[ $JAR_URL_EX == http* ]]; then
  # Use wget or curl to download the .jar file
  cd $HOME/minecraft-server/plugins
  echo "Downloading $JAR_URL_EX..."
  curl -L $JAR_URL_EX -o essentials-x.jar
  echo "Download completed: essentials-x.jar"
else
  echo "Failed to find a .jar file in the latest release."
fi

#Pull latest spigot from Jenkins
echo "Downloading Latest Spigot Server..."
cd $HOME/minecraft-server
curl -L https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -o BuildTools.jar
echo "Download completed: BuildTools.jar"

#Build spigot
cd $HOME/minecraft-server
echo "Building/configuring spigot, this process will take a few minutes to complete"
java -jar -Xmx2G -Xms2G -XX:+UseZGC BuildTools.jar
mv spigot-*.jar $HOME/minecraft-server/spigot.jar
echo "eula=true" > eula.txt 
java -jar -Xmx2G -Xms2G -XX:+UseZGC $HOME/minecraft-server/spigot.jar &
sleep 5
JAVA_PID=$(jobs -p | tail -n 1)
sleep 60
kill $JAVA_PID

#Modify Spigot to work with BedrockConnect (uses default Bedrock 19132 port) and host on any
echo "Modifying plugin files for public/LAN hosting also opening ports on firewalld (if installed)"
sed -i '17 s/.*/  address: 0.0.0.0/' $HOME/minecraft-server/plugins/Geyser-Spigot/config.yml
sed -i '49 s/.*/  address: 0.0.0.0/' $HOME/minecraft-server/plugins/Geyser-Spigot/config.yml
sed -i '19 s/.*/  port: 19133/' $HOME/minecraft-server/plugins/Geyser-Spigot/config.yml

#Check for backup and copy if folder has contents (place the world folders in the minecraft-backup dir)
sourceDir="$HOME/minecraft-backup"
destDir="$HOME/minecraft-server"
if [ "$(find "$sourceDir" -mindepth 1 -print -quit)" ]; then
    echo "Directory is not empty, copying contents..."
    # Copy the contents. Add -r for recursive copy if there are directories.
    cp -r "$sourceDir"/* "$destDir"
    echo "Contents copied to $destDir."
else
    echo "Directory is empty or does not exist."
fi

#Pull Start Script
chmod +x $HOME/minecraft-server/spigot.jar
chmod +x $HOME/minecraft-server/bedrock-connect.jar
cd $HOME/minecraft-server
wget https://github.com/Operator-One/easy-spigot/raw/main/start-spigot-mc.sh
chmod +x $HOME/minecraft-server/start-spigot-mc.sh