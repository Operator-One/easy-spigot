# Early stages of development and testing.

Automatically builds an optimized PaperMC docker container for you! Modify the dockerfile to your hearts content.
Would advise using this as a template for a private repo so private information can be passed to the server. 
Select "Use this Template" and then "Create Repo" to copy this. 

If hosting publicly, you'll need to forward some ports:
- For Java MC: Port 25565/tcp

For Configuration, you will need to add the following build args to your docker build command:
- --build-arg GITHUB_TOKEN=Your-Token
- --build-arg REPO_NAME=Your-Copied-Template-Repo
- --build-arg REPO_OWNER=Your-Username
- --build-arg OWNER_EMAIL=Your-GitEmail@example.com

Email is required for the PaperMC build, otherwise, it'll crash.

Be sure to assign yourself op in the ops.json template. UUID and Name required. 
