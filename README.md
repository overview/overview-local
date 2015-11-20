We recommend the [public Overview server](https://www.overviewdocs.com). But we
also support users who want to run Overview on their own machines.

Here are some reasons to run Overview on your own machine(s):

* You want total control over your documents. (We think Overview is secure from
  most attacks; but we can't fight a subpoena.)
* You want to experiment with large document sets. (Overview can handle one or
  two gigabytes; above that, our servers may groan.)
* You want to develop your own visualization or processing
  [plugin](https://github.com/overview/overview-server/wiki/Writing-a-Plugin).
* You need to work without Internet access.

If you need your own Overview instance, read on!

You'll need to use a command line to follow these instructions. Don't worry:
we'll guide you carefully. Copy/paste each command, and all should be fine. Any
errors? File an issue on GitHub.

# Installation

## Installation: Linux

We've tested in Ubuntu Linux 15.10 (Vivid); other distributions should work just
as well.

0. Open the "Terminal" program.
1. Install dependencies. On Ubuntu: `sudo apt-get install git docker`
2. Install `docker-compose`. You'll need version 1.4 or higher. On Ubuntu: `sudo pip install docker-compose`
3. Make yourself a member of the `docker` group. Run `sudo usermod -a -G docker $USER` and then log out (of your entire desktop environment) and log back in.
4. Copy/paste this command into the terminal and press Enter: `curl https://raw.githubusercontent.com/overview/overview-local/master/install-from-scratch.sh | sh`

If all goes well, you'll see screen after screen of progress bars. Grab a
coffee; in half an hour or so, return to see Overview's URL on the screen.
(It's probably [http://172.17.42.1:9000/](http://172.17.42.1:9000/).)

## Installation: Mac OS X

1. Install Docker, from [https://www.docker.com/docker-toolbox](https://www.docker.com/docker-toolbox).
2. Install `git`, from [https://git-scm.com/downloads](https://git-scm.com/downloads).
3. Open the _Docker Quick Start Terminal_. (We'll call this "the terminal" from now on.)
4. Copy/paste this command into the terminal and press Enter: `curl https://raw.githubusercontent.com/overview/overview-local/master/install-from-scratch.sh | sh`

If all goes well, you'll see screen after screen of progress bars. Grab a
coffee; in half an hour or so, return to see Overview's URL on the screen.
(It's probably [http://192.168.99.100:9000/](http://192.168.99.100:9000/).)

## Installation: Windows

1. Install Docker, from [https://www.docker.com/docker-toolbox](https://www.docker.com/docker-toolbox).
2. Open the _Docker Quick Start Terminal_. (We'll call this "the terminal" from now on.)
3. Copy/paste this command into the terminal and press Enter: `curl https://raw.githubusercontent.com/overview/overview-local/master/install-from-scratch.sh | sh`

If all goes well, you'll see screen after screen of progress bars. Grab a
coffee; in half an hour or so, return to see Overview's URL on the screen.
(It's probably [http://192.168.99.100:9000/](http://192.168.99.100:9000/).)

## Giving Overview more resources (on OS X and Windows)

On Linux, Overview gets access to system memory; Linux users should skip this
section.

On OS X and Windows, Overview runs in Docker's "virtual machine". The virtual
machine restricts the amount of memory and number of processors Overview can
use.

If Overview is running too slowly, try these steps to speed it up:

1. Start the _Docker Quick Start Terminal_ application.
1. Stop the virtual machine: `docker-machine stop default`
1. Set virtual machine memory to 4Gb (assuming your system has 8Gb).
  - OS X: `VBoxManage modifyvm default --memory 4096`
  - Windows: `/c/Program\ Files/Oracle/VirtualBox/VBoxManage modifyvm default --memory 4096`
1. Restart the virtual machine: `docker-machine start default`

You don't _need_ to use the command line. When you installed Docker, it gave
you a "VirtualBox" icon. Open that program to change more settings.

# Starting Overview when it's already installed

That `curl | sh` command above stored some files on your computer to make
future startups quicker. Next time you want to start Overview, run
`~/overview-local/start` in a terminal.

# Upgrading Overview

Does Overview have some new features you want? Open a terminal and do this:

1. `~/overview-local/stop`
2. `~/overview-local/update`
3. `~/overview-local/start`

# Stopping Overview

Overview uses lots of memory, and that can make your computer a bit sluggish.
Open a terminal and run `~/overview-local/stop` to shut it down.

# Backing up Overview's data

You can copy all Overview's data into a single file.

Run `~/overview-local/backup backup.tar.gz` and then store `backup.tar.gz`
somewhere safe.

If you're in the midst of using Overview when you run this, the backup may be
inconsistent. (We just use `tar` to back up a PostgreSQL directory.) To be safe,
you should stop Overview before you back it up.

The first time you run the backup, you'll get a lot of messages about pulling
Docker images. That'll just happen the one time; every other invocation will be
silent.

# Restoring Overview from a backup

After you've installed Overview and tested that it works, you can wipe all its
data and replace it with a backup's data.

Run `~/overview-local/restore-from-backup backup.tar.gz`, where `backup.tar.gz`
is your backup file.

This command will stop Overview itself.

# Debugging

If Overview isn't running correctly, we'd love for you to file an issue on our
Issues page. Please open a terminal and run `~/overview-local/dump-logs` as
well; show us those logs so we'll know what Overview was thinking when it failed
you.

If you're curious, you can run `~/overview-local/tail-logs` and watch Overview's
log messages as they appear, while you use Overview in a browser window.

# Uninstalling

If you want Overview gone forever, open a terminal and run these commands:

    ~/overview-local/stop                  # stop Overview
    rm -rf ~/overview-local                # remove Overview-related commands
    docker rm -v overview-blob-storage     # delete PDFs and uploaded files
    docker rm -v overview-database-data    # delete database
    docker rm -v overview-searchindex-data # delete search index
    docker rmi $(docker images -f dangling=true -q) # free disk space
