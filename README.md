# Satoshi Workbench

A docker workbench environment, pre-configured for running bitcoind.

## How to Setup
```sh
## Project Directory

/config      # Mounted as read-only at /config.
             # Useful for collecting our config files in 
             # one place, so we can tweak them between builds.

/home        # Mounted as read-write at /root/home.
             # Scripts placed in 'bin' are added to your PATH 
             # environment. The .bashrc script is loaded at login.

/image       # Copied to root filesystem '/' at build time.
             # Create your desired filesystem in here, using the 
             # proper paths. (for ex. binaries in /image/usr/bin/')

.env.sample  # Example of .env file. Used for setting variables that
             # are passed into the build and runtime environments.

compose.yml  # Container configuration file. Launch your container in 
             # detached mode by using: 'docker compose up --build -d'

Dockerfile   # Main build file for the docker container. Feel free to 
             # configure this file to your liking!

README.md    # You are here!
```

## How to Use
```sh
## Build and test-start the container.
docker compose up --build

## Start the container in detached mode.
docker compose up --build -d

## Log into a running container.
docker exec -it <container name> console
```

## Resources

**Docker Compose Reference**  
https://docs.docker.com/compose/compose-file

**Docker Builder Reference**  
https://docs.docker.com/engine/reference/builder

**Docker Exec Reference**  
https://docs.docker.com/engine/reference/commandline/exec
