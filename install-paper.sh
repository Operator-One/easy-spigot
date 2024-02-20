#!/bin/sh

#Build PaperMC
echo "Starting build of PaperMC"
mv /home/serveruser/minecraft-server/Paper/build/libs/paper* /home/serveruser/minecraft-server/paper.jar
echo "eula=true" > eula.txt 
#First run file building (for modifying via script if needed)
java -jar -Xmx2G -Xms2G /home/serveruser/minecraft-server/paper.jar &
sleep 5
JAVA_PID=$(jobs -p | tail -n 1)
sleep 60
kill $JAVA_PID
exit 0