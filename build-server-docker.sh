#!/bin/sh

GITHUB_OWNER2="DownThePark"
GITHUB_REPO2="SetHome"
GITHUB_OWNER3="EssentialsX"
GITHUB_REPO3="Essentials"

# URL to GitHub API for fetching the latest release
API_URL_SH="https://api.github.com/repos/$GITHUB_OWNER2/$GITHUB_REPO2/releases/latest"
API_URL_EX="https://api.github.com/repos/$GITHUB_OWNER3/$GITHUB_REPO3/releases/latest"

# Use curl to fetch the latest release data and jq to parse the JSON for the .jar file's URL
# Note: Install jq if you haven't (e.g., sudo apt-get install jq)
JAR_URL_BC=$(curl -s $API_URL_BC | jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url')
JAR_URL_SH=$(curl -s $API_URL_SH | jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url')
JAR_URL_EX=$(curl -s $API_URL_EX | jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url' | head -n 1)

#Geyser Spigot download
cd /home/serveruser/minecraft-server/plugins
echo "Downloading Geyser Spigot..."
curl -L https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot -o geyser-spigot.jar
echo "Download completed: geyser-spigot.jar"

#Pull latest SetHome Plugin
if [[ $JAR_URL_SH == http* ]]; then
  # Use wget or curl to download the .jar file
  cd /home/serveruser/minecraft-server/plugins
  echo "Downloading $JAR_URL_SH..."
  curl -L $JAR_URL_SH -o set-home.jar
  echo "Download completed: set-home.jar"
else
  echo "Failed to find a .jar file in the latest release."
fi

#Pull latest Essentials Plugin
if [[ $JAR_URL_EX == http* ]]; then
  # Use wget or curl to download the .jar file
  cd /home/serveruser/minecraft-server/plugins
  echo "Downloading $JAR_URL_EX..."
  curl -L $JAR_URL_EX -o essentials-x.jar
  echo "Download completed: essentials-x.jar"
else
  echo "Failed to find a .jar file in the latest release."
fi

#Pull latest spigot from Jenkins
echo "Downloading Latest Spigot Server..."
cd /home/serveruser/minecraft-server
curl -L https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -o BuildTools.jar
echo "Download completed: BuildTools.jar"

#Build spigot
cd /home/serveruser/minecraft-server
echo "Building/configuring spigot, this process will take a few minutes to complete"
/etc/alternatives/jre_17_openjdk/bin/java -jar -Xmx2G -Xms2G BuildTools.jar
mv spigot-*.jar /home/serveruser/minecraft-server/spigot.jar
echo "eula=true" > eula.txt 
/etc/alternatives/jre_17_openjdk/bin/java -jar -Xmx2G -Xms2G /home/serveruser/minecraft-server/spigot.jar &
sleep 5
JAVA_PID=$(jobs -p | tail -n 1)
sleep 60
kill $JAVA_PID

#Modify Spigot to work with BedrockConnect (uses default Bedrock 19132 port) and host on any
echo "Modifying plugin files for public/LAN hosting.
sed -i '17 s/.*/  address: 0.0.0.0/' /home/serveruser/minecraft-server/plugins/Geyser-Spigot/config.yml
sed -i '49 s/.*/  address: 0.0.0.0/' /home/serveruser/minecraft-server/plugins/Geyser-Spigot/config.yml
sed -i '19 s/.*/  port: 19133/' /home/serveruser/minecraft-server/plugins/Geyser-Spigot/config.yml

#Pull Start Script
chmod +x /home/serveruser/minecraft-server/spigot.jar
cd /home/serveruser/minecraft-server