# Winbox in Wine
### Without leaving Docker!

## How to start
 - make sure you have docker installed.
 - make sure you have a VNC client _(at least macOS comes with one preinstalled)_

Then just run `docker-compose up`
Or everything in one go `docker-compose up -d && open vnc://localhost`


### Under the hood
The docker-image create
- a xserver session
- a vnc server
- a wine_process that runs winbox

### Known issues
- If you force quit the container you need to delete the `.docker-volumes` folder in order to get it to start again.
- CMD + space seems to be toxic

### Improvements
 - Include wine-mono and wine-gecko at build time?