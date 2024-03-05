# Use Alpine Linux as the base image
FROM alpine

#Open Ports
EXPOSE 25565/tcp

# Install dependencies
RUN apk add curl git jq openjdk17
RUN addgroup servergroup && adduser -D -G servergroup serveruser
ARG GITHUB_TOKEN
ARG REPO_OWNER
ARG REPO_NAME
ARG OWNER_EMAIL

#Begin main building
WORKDIR /home/serveruser/minecraft-server
RUN git config --global user.email ${OWNER_EMAIL}
RUN git config --global user.name ${REPO_OWNER}
RUN git clone https://github.com/PaperMC/Paper.git
RUN cd /home/serveruser/minecraft-server/Paper && sh /home/serveruser/minecraft-server/Paper/gradlew applyPatches ; sleep 2
RUN cd /home/serveruser/minecraft-server/Paper && sh /home/serveruser/minecraft-server/Paper/gradlew createReobfBundlerJar ; sleep 2
RUN mv /home/serveruser/minecraft-server/Paper/build/libs/paper* /home/serveruser/minecraft-server/paper.jar
RUN echo "eula=true" > eula.txt 

#RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/papermc/install-paper.sh -o install-paper.sh ; sleep 2
#RUN sh install-paper.sh

#Set these files to your own fork for customization. 
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/server-config/banned-ips.json -o banned-ips.json
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/server-config/banned-players.json -o banned-players.json
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/server-config/ops.json -o ops.json
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/server-config/server.properties -o server.properties
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/server-config/whitelist.json -o whitelist.json
# Command to run the SpigotMC server and Minecraft Connect executable
#Fix Permissions/Ownership
RUN chown -R serveruser:servergroup /home/serveruser
USER serveruser
#First run file building (for modifying via script if needed) this is in-case you add plugins that you need config/additional folders expanded from Jar. 
RUN java -jar -Xmx2G -Xms2G /home/serveruser/minecraft-server/paper.jar &
RUN sleep 5
RUN JAVA_PID=$(jobs -p | tail -n 1)
#Adjust this timer as needed, the more plugins == the more time it'll take to do this. 
RUN sleep 25
RUN kill $JAVA_PID ; sleep 5
#Custom config for PaperMC itself
WORKDIR /home/serveruser/minecraft-server/config
#Running defaults, something with changing tick rate is causing crash. Figuring it out.
#RUN rm -f /home/serveruser/minecraft-server/config/paper-global.yml && curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/server-config/config/paper-global.yml -o paper-global.yml
#RUN rm -f /home/serveruser/minecraft-server/config/paper-world-defaults.yml && curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/server-config/config/paper-world-defaults.yml -o paper-world-defaults.yml
#Custom config for Bukkit and Spigot
WORKDIR /home/serveruser/minecraft-server
RUN rm -f /home/serveruser/minecraft-server/bukkit.yml && curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/server-config/bukkit.yml -o bukkit.yml
RUN rm -f /home/serveruser/minecraft-server/spigot.yml && curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/server-config/config/spigot.yml -o spigot.yml
#SRC Cleanup
RUN rm -rf /home/serveruser/minecraft-server/Paper
#Start As
CMD java -jar -Xmx1G -Xms256M -XX:+UseZGC /home/serveruser/minecraft-server/paper.jar
