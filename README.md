Running Overview
================

We recommend the [public Overview server](https://www.overviewdocs.com). But we
also support users who want to run Overview on their own machines.

Here are some reasons to run Overview on your own machine(s):

* You want total control over your documents. (We think Overview is secure from
  most attacks; but we can't fight a subpoena.)
* You want to experiment with large document sets. (Overview can handle one or
  two gigabytes; above that, our servers may groan.)
* You want to rebrand Overview. (Unless you're paying us, we won't go out of
  our way to help you in this case.)
* You don't have Internet access.

If you need your own Overview instance, read on!

## Setup

### For OS X

1. Install the Docker tools, as described at <https://docs.docker.com/installation/mac/>.
1. Install `git` if not installed already, for example from <https://git-scm.com/downloads>.
1. Follow the directions in the _Configuring Docker on OS X and Windows_ section. 
1. In the _Docker Quick Start Terminal_ (referred to  as 'the terminal' from now on), navigate to the directory where you want the Overview configuration files to be installed.
1. Run:

        git clone https://github.com/overview/overview-local.git

The result should be a directory called _overview-local_.

1. `cd overview-local`
1. `./start`

This will start to download all the Overview components. The download may take a while, depending on your connection speed. After setup is complete, the names of the Overview components are displayed, and the command prompt will be available again.

1. Run `docker-machine ip default` to find Overview's IP address (probably _192.168.99.100_).
1. Open <http://192.168.99.100:9000> (or the IP address returned in the above step) in your browser.

### For Windows

_Note: Windows 10 is not supported yet_

1. Install the Docker tools, as described at <https://docs.docker.com/installation/windows/>. This will install `git`. If you already have git installed on your system, there may be conflicts. Either uninstall your previous version before installing Docker, or tell the Docker installer to not install the `MSYS-git UNIX tools`.
1. Follow the directions in the _Configuring Docker on OS X and Windows_ section.
1. In the _Docker Quick Start Terminal_ (referred to  as 'the terminal' from now on), navigate to the directory where you want the Overview configuration files to be installed.
1. Run:

        git clone https://github.com/overview/overview-local.git

The result should be a directory called _overview-local_.

1. `cd overview-local/windows`
1. `./init-overview.sh`

This will start to download all the Overview components. The download may take a while, depending on your connection speed. The terminal display will be confusing, as updates are written to the top of the screen. When download is complete, the command prompt will be available again (hitting _Return_ a number of times will clear the screen). 

1. `./start-overview.sh`

The names of the Overview components will be displayed.

1. Run `docker-machine ip default` to find Overview's IP address (probably _192.168.99.100_).
1. Open <http://192.168.99.100:9000> (or the IP address returned in the above step) in your browser.


### For Ubuntu

_Installation on other Linux distros should also be possible. See <https://docs.docker.com/installation/>._

1. Install docker, as described at <https://docs.docker.com/installation/ubuntulinux/>.
1. Install docker-compose, as described at <https://docs.docker.com/compose/install/>. Simplest is: `sudo pip install docker-compose`
1. If `git` is not installed, install it.
1. Navigate to the directory where you want the Overview configuration files to be installed. Run `git clone https://github.com/overview/overview-local.git`. The result should be a directory called _overview-local_.
1. `cd overview-local`
1. `./start`

This will start to download all the Overview components. The download may take
minutes or hours, depending on your connection speed. When it's done, you'll
be presented with a link. Open it in your web browser.

When you want to free up all the resources Overview is using, run `./stop`

### Configuring Docker on OS X and Windows

1. Start the _Docker Quick Start Terminal_ application. Behind the scenes, a new virtual machine will be created, that will act as the docker host. This machine is the common platform on which Overview will run. Unfortunately, it is configured with a small amount of RAM. 
1. Stop the virtual machine: `docker-machine stop default`
1. Set virtual machine memory to 4Gb (assuming your system has 8Gb).
  - OS X: `VBoxManage modifyvm default --memory 4096`
  - Windows: `/c/Program\ Files/Oracle/VirtualBox/VBoxManage modifyvm default --memory 4096`
1. Restart the virtual machine: `docker-machine start default`

Docker uses Virtual Box to setup and run the docker host. The Virtual Box application can be used to change memory, disk, and networking settings if the defaults are not sufficient.

## Subsequent startups

Overview will keep running until you restart the computer. Restarting does not require the downloads needed in the setup step and will be much quicker.

### For OS X

1. Start the `Docker Quick Start Terminal` application
1. `cd overview-local` 
1. `./start`


### For Windows

1. Start the `Docker Quick Start Terminal` application
1. `cd overview-local/windows` 
1. `./start-overview.sh`


### For Ubuntu

1. `cd overview-local` 
1. `./start`



## Updating Overview

Once new features have been deployed to http://overviewdocs.com, you can update your own local installation. Overview will be updated while preserving your data.

### For OS X

1. Start the `Docker Quick Start Terminal` application
1. `cd overview-local`
1. `./update`
1. `./start`


### For Windows

1. Start the `Docker Quick Start Terminal` application
1. `cd overview-local/windows`
1. `./update`
1. `./init-overview.sh`
1. `./start-overview.sh`

### For Ubuntu

1. `cd overview-local`
1. `./update`
1. `./start`


## Issues


### Stuck during setup

During the initial setup or subsequent updates, the process may become stuck, with a message saying something like:

        Layer already being pulled by another client. Waiting.

If this message is shown and there appears to be no progress after several minutes, the download may not be able to proceed without restarting. This problem appears to be a [known issue](https://github.com/docker/docker/issues/12823) with Docker. To get past the problem:

  - Ctrl-C to interrupt the download.
  - Restart Docker
    * OS X and Windows: `docker-machine restart default`
    * Ubuntu: `sudo restart docker`
  - Delete the stuck download: `docker rmi $(docker images --filter 'dangling=true' -q --no-trunc)`
  - Restart the command that was stuck (eg. `./start`, `./init-overview.sh`, `./update`)

        
### No response from web server

- Make sure you're using the correct IP address, as returned by `docker-machine ip default`
- The web server may not have started yet. Run `docker logs -f web`. Try connecting once the server reports

         Listening for HTTP on /0:0:0:0:0:0:0:0:9000

(you can then hit `Ctrl-c` to stop viewing the log and return to the terminal prompt.)


### Error during startup

During start up, the below message may be displayed:

         Error response from daemon: Cannot start container worker. System error: read parent: connection reset by peer

Restart Docker:

  - Remove all started containers: `docker rm -f $(docker ps -q)`
  - Restart Docker  
    * OS X and Windows: `docker-machine restart default`
    * Ubuntu: `sudo restart docker`
  - On Windows, recreate containers `./init-overview.sh`.
  - Restart overview (`./start` on Ubuntu and OS X,  or `./start-overview.sh` on Windows)



## Technical details

For Ubuntu and OS X, we use [Docker Compose](https://docs.docker.com/compose/) to specify how the different Overview components are started. The `config` directory contains the definition files:

  - `services.yml` is used to start up the third-party services used by Overview: a postgres database and a redis server.
  - `db-setup.yml` is used to run the database evolution.
  - `overview.yml` is used to start the main Overview components: the web front end, the document set worker, and worker process.
  - `plugins.yml` is used to start the plugins and configure Overview to know about them.

Docker Compose is not (yet) supported for Windows, so the scripts in the _windows_ directory mimic the functionality.

A container is created and run for each separate Overview component. In addition, data containers are used for persistent storage:

  - `overview-database-data`
  - `overview-searchindex-data`
  - `overview-blob-storage`

Deleting these containers will result in all data to be deleted from your Overview installation.
