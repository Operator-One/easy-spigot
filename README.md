# Early stages of development and testing.

Automatically builds an optimized PaperMC docker container for you! Modify the dockerfile to your hearts content. 

If hosting publicly, you'll need to forward some ports:
- For Java MC: Port 25565/tcp

For Configuration, you will need to add the following build args to your docker build command:
- --build-arg GITHUB_TOKEN=TOKEN
- --build-arg REPO_NAME=easy-spigot
- --build-arg REPO_OWNER=Operator-One
- --build-arg OWNER_EMAIL=cullen.guimond@guinet.us

Email is required for the PaperMC build, otherwise, it'll crash.
