# EdenAPI

EdenAPI is the main component of EdenServers v3. This API HAS to be started in a container without any exposed ports as there is no built-in authentification system.

# Getting Started

## Pre-requisites

You have to install Docker, Ruby v2.2. This API is supposed to be executed inside a container if you aim to use it on a production system. That's why we advise you to use CoreOS as host system. 

## Check out the code

Start by cloning the EdenAPI repository:

```git clone https://github.com/EdenServers/EdenAPI.git```

## Installing

```bundle install```
Then, you can simply start the API with rails s -b 0.0.0.0 on a development system.

If you want to run this API inside a container, you will need to mount /run/docker.sock inside your container.
We suggest you to start your api container with : 

```docker run -it -v /run/docker.sock:/run/docker.sock -p 8080:3000 edenservers/edenapi /bin/sh```
  
# Documentation

Documentation is available on readme.io here : [https://edenapi.readme.io/docs](https://edenapi.readme.io/docs)

