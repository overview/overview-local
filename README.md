
Running Overview
================

While the [public Overview server](https://overviewdocs.com) is recommended for most Overview users, there are some cases where running your own server is necessary. Overview consists of a number of different components and platforms, each requiring careful configuration and setup, making a local installation complicated. To simplify the process, we use [docker](http://docker.com) images, which allow us to package up all the pieces needed by Overview in a way that can be run on many different platforms.

A fair amount of setup is still necessary however, and you should be comfortable working on the command line, on whatever platform you're using.


## Initial Setup

1. Install Docker for your platform. Follow the _Get Started with Docker_ link on http://docker.com.
1. Install git from https://git-scm.com/downloads.


### Configuring Docker on OS X and Windows

1. Start the _Docker Quick Start Terminal_ application. Behind the scenes, a new virtual machine will be created, that will act as the docker host. This machine is the common platform on which Overview will run. Unfortunately, it is configured with a small amount of RAM. To increase the memory, first quit the Docker terminal.
1. Start the _Virtual Box_ application. Find the Machine named _default_. It should be listed as _Running_. Right-click on the machine, and select _Shutdown_.
1. Making sure _default_ is selected, click on _Settings_.
1. Select the _System_ tab.
1. Increase the amount of _Base Memory_. Assuming that your computer has at least 8gb of RAM, allocate 4096Mb to the _default_ virtual machine.
1. Click _OK_ to save the change.
1. Start the _Docker Quick Start Terminal_ again.
The terminal should say something like, `docker is configured to use the default machine with IP 192.168.99.100`. This IP address will be the address you use to connect to Overview.

### Download configuration

1. In the Docker terminal, navigate to the directory where you want the Overview configuration files to be installed.
1. Run:

        git clone https://github.com/overview/overview-local.git

The result should be a directory called overview-local
1. `cd overview-local`
1. `./run-overview.sh`
This will start to download all the Overview components. The download may take a while, depending on your connection speed. Once the download is complete, Overview should be running, available at `http://192.168.99.100:9000` (or whatever IP address you noted above).
If you don't remember the address, running `docker-machine ip default` from the Quick Start terminal will tell you.

## Subsequent startups


Overview will keep running until you restart the computer. To restart, 
1. Start the `Docker Quick Start Terminal` application
2. cd to the `overview-local` directory
3. `./run-overview.sh`

Overview should start without trying to download anything


## Updating Overview

Once new features have been deployed to http://overviewdocs.com, you can update your own local installations. From the `Docker Quick Start Terminal`, run

      ./update-overview.sh

## Issues

During the initial setup, or subsequent update, the process may become stuck, with a message saying something like:

        Layer already being pulled by another client. Waiting.

This problem appears to be a [known issue](https://github.com/docker/docker/issues/12823) with Docker. To get past the problem:

  - Ctrl-C in the Quick Start Terminal to interrupt the 
  - Stop the host: `docker-machine stop default`
  - Quit the _Docker Quick Start Terminal_ and restart it
  - Delete the stuck download: `docker rmi $(docker images --filter 'dangling=true' -q --no-trunc)`
  - Resume downloading: `./run-overview.sh`

        



## Technical details

We use [Docker Compose](https://docs.docker.com/compose/) to specify how the different Overview components are started. The `config` directory contains the definition files:
  - `services.yml` is used to start up the third-party services used by Overview: a postgres database, a redis server, and a Apollo ActiveMQ message broker.
  - `db-setup.yml` is used to run the database evolution.
  - `overview.yml` is used to start the main Overview components: the web front end, the document set worker, and worker processes.


A container is created and run for each separate Overview component. In addition, data containers are used for persistent storage:

  - overview-database-data
  - overview-searchindex-data
  - overview-blob-storage

Deleting these containers will result in all data to be deleted from your Overview installation.


