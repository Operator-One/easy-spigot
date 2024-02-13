#!/bin/sh

echo "Starting the Minecraft Server"
$HOME/minecraft-server/spigot.jar &
first_pid=$!

# Start the second program in the background
echo "Starting Bedrock Connect"
$HOME/minecraft-server/bedrock-connect.jar &
second_pid=$!

# Wait for all background processes to exit
wait $first_pid
wait $second_pid