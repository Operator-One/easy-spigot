# Use Alpine Linux as the base image
FROM alpine

#Open Ports
EXPOSE 25565/tcp
EXPOSE 19132/udp

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
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/banned-ips.json -o banned-ips.json
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/banned-players.json -o banned-players.json
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/ops.json -o ops.json
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/server.properties -o server.properties
RUN curl -H "Authorization: token ${GITHUB_TOKEN}" -L https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/config/whitelist.json -o whitelist.json
# Command to run the SpigotMC server and Minecraft Connect executable
#Fix Permissions/Ownership
RUN chown -R serveruser:servergroup /home/serveruser
USER serveruser
#First run file building (for modifying via script if needed)
RUN java -jar -Xmx2G -Xms2G /home/serveruser/minecraft-server/paper.jar &
RUN sleep 5
RUN JAVA_PID=$(jobs -p | tail -n 1)
#Adjust this timer as needed, the more plugins == the more time it'll take to do this. 
RUN sleep 25
RUN kill $JAVA_PID ; sleep 5
CMD java -jar -Xmx1G -Xms256M -XX:+UseZGC /home/serveruser/minecraft-server/paper.jar
