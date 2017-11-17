We recommend the [public Overview server](https://www.overviewdocs.com). But we
also support users who want to run Overview on their own machines. You'll want to do this if you need greater security, larger document sets, or custom modifications.

You'll need to use a command line to follow these instructions. Don't worry:
we'll guide you carefully. Copy/paste each command, and all should be fine. Any
errors? File an issue on GitHub.

Please note that Overview is licensed under [AGPL 3.0](http://www.gnu.org/licenses/agpl-3.0.en.html). If you want to modify the code to run a custom server, please contact info@overviewdocs.com for a license. We can also do custom development work for you.

# Contents
- [Installation](#installation)
   - [Linux](#linux)
   - [Mac](#mac)
   - [Windows](#windows)
   - [Giving Overview enough resources](#resources)
- [Administration](#administration)
   - [Starting Overview](#starting)
   - [Stopping Overview](#stopping)
   - [Upgrading Overview](#upgrading)
   - [Enabling multi-user mode](#multi-user)
   - [Enabling SSL and public access](#ssl)
   - [Backing up](#backup)
   - [Uninstalling](#uninstalling)
- [Troubleshooting](#troubleshooting)

# <a name="installation">Installation</a>

**Note: On Windows and Mac docker 1.9.1 will not work due to an ongoing [docker bug](https://github.com/docker/docker/issues/18180). Type `docker -v` to see which version you have. The latest version 1.10.1 may fix the problem, if not try 1.9.0. Linux install should work fine on any version.**

## <a name="linux">Installation: Linux</a>

We've tested in Ubuntu Linux 15.10 (Vivid); other distributions should work just
as well.

0. Open the "Terminal" program.
1. Install dependencies. On Ubuntu: `sudo apt-get install git docker.io`
2. Install `docker-compose`. You'll need version 1.4 or higher. On Ubuntu: `sudo pip install docker-compose`
3. Make yourself a member of the `docker` group. Run `sudo usermod -a -G docker $USER` and then *log out* (of your entire desktop environment) and *log back in*. You can check the docker groups with the `groups` command to see that it is working.
4. Copy/paste this command into the terminal and press Enter: `curl https://raw.githubusercontent.com/overview/overview-local/master/install-from-scratch.sh | sh`

You may need to install a few things to get `pip`; `sudo apt-get install python-setuptools python-dev build-essential`
`sudo easy_install pip`. 

If you get the error `ERROR: Couldn't connect to Docker daemon at http+docker://localunixsocket - is it running?` you probably need to log out and back in again, so that the newly updated environment variables can take effect.

If all goes well, you'll see screen after screen of progress bars. Grab a
coffee; in half an hour or so, return to see Overview's URL on the screen.
(It's probably [http://172.17.42.1:9000/](http://172.17.42.1:9000/).)

## <a name="mac">Installation: Mac OS X</a>

1. Install Docker, from [https://www.docker.com/docker-toolbox](https://www.docker.com/docker-toolbox).
2. Install `git`, from [https://git-scm.com/downloads](https://git-scm.com/downloads).
3. Open the _Docker Quick Start Terminal_. Not the regular OS X Terminal app, or you'll get an error and need to [start Docker manually](https://github.com/overview/overview-local#starting-overview) (We'll call this "the terminal" from now on.)
4. Give Overview more resources (see below)
6. Copy/paste this command into the terminal and press Enter: `curl https://raw.githubusercontent.com/overview/overview-local/master/install-from-scratch.sh | sh`

If all goes well, you'll see screen after screen of progress bars. Grab a
coffee; in half an hour or so, return to see Overview's URL on the screen.
(It's probably [http://192.168.99.100:9000/](http://192.168.99.100:9000/).)

## <a name="windows">Installation: Windows</a>

1. Install Docker, from [https://www.docker.com/docker-toolbox](https://www.docker.com/docker-toolbox).
2. Open the _Docker Quick Start Terminal_. (We'll call this "the terminal" from now on.)
3. Give Overview more resources (see below)
4. Copy/paste this command into the terminal and press Enter: `curl https://raw.githubusercontent.com/overview/overview-local/master/install-from-scratch.sh | sh`

If all goes well, you'll see screen after screen of progress bars. Grab a
coffee; in half an hour or so, return to see Overview's URL on the screen.
(It's probably [http://192.168.99.100:9000/](http://192.168.99.100:9000/).)

## <a name="resources">Giving Overview enough resources (on OS X and Windows)</a>

Linux users should skip this section, but Windows and Mac users probably need it.

On OS X and Windows, Overview runs in Docker's "virtual machine". The virtual
machine restricts the amount of memory and number of processors Overview can
use.

We recommend you give Overview at least 3GB of memory; the more, the faster it
will be.

Here's how to give the Docker virtual machine more memory:

1. Start the _Docker Quick Start Terminal_ application.
1. Stop the virtual machine: `docker-machine stop default`
1. Set virtual machine memory to 3Gb.
  - OS X: `VBoxManage modifyvm default --memory 4096`
  - Windows: `/c/Program\ Files/Oracle/VirtualBox/VBoxManage modifyvm default --memory 4096`
1. Restart the virtual machine: `docker-machine start default`

You don't _need_ to use the command line. When you installed Docker, it gave
you a "VirtualBox" icon. Open that program to change more settings. For
instance, if you assign Overview two processors, file imports will finish much
sooner.

# <a name="administration">Administration</a>

## <a name="starting">Starting Overview</a>

When you want to start Overview, run `~/overview-local/start` in a terminal.That `curl | sh` command you used to install Overview stored some files on your computer to make future startups much quicker. 

On Windows and Mac, if you see this error

    ERROR: Couldn't connect to Docker daemon - you might need to run `docker-machine start default`.
   
it means the Docker Virtual Machine got shut down, so you need to start it again by running these commands

    docker-machine start default
    eval "$(docker-machine env default)"

then run `start` again.

## <a name="stopping">Stopping Overview</a>

Overview uses lots of memory, and that can make your computer a bit sluggish.
Open a terminal and run `~/overview-local/stop` to shut it down.

## <a name="multi-user">Enabling multi-user mode</a>

Overview-local runs by default in single user mode, meaning there is only one user and no logins. To enable logins and multiple users, add the following line to `~/overview-local/config/overview.env`

    OV_MULTI_USER=true

The default user and password is `admin@overviewdocs.com`. You should change the password immediately. You can create new user accounts through the Admin menu when logged in. The registration form on the front page will by default print confirmation and password reset emails to the console, unless you [configure an SMTP server](https://github.com/overview/overview-server/wiki/Configuration).

See also [configuration](#configuration) below.

## <a name="multi-user">Enabling SSL and public access</a>

Normally, overview-local only listens on the "localhost" network interface.
That means other computers won't have access to your files (unless you have
bizarre firewall rules or a virus).

If you want to create a publicly-visible Overview service, add lines like
these to `~/overview-local/config/overview.env`.

    OV_MULTI_USER=true
    OV_DOMAIN_NAME=overview.example.com

Make `OV_DOMAIN_NAME` a DNS name you control.

(You should also [configure an SMTP server](https://github.com/overview/overview-server/wiki/Configuration).)

Now run `./start`.

This tells Overview to listen for connections from _anywhere_ on ports 80
and 443. In short, it makes your computer a web server.

Now you need the rest of the world to see your web server. The instructions
vary _greatly_ depending on your network. You may need to involve system
administrators or your Internet service provider.

Here's an example setup that would work on some home networks.

Let's pretend you already control a DNS domain named `example.com` via an
online hosting service and you are connecting to the Internet via an ISP
that provides stable IP addresses, leaves ports 80 and 443 open, and supplied
a router you can log into.

1. Find your public IP address. (Search online for "What is my IP".)
2. Register `A`, `AAAA`, `CNAME` records with your DNS hosting service, pointing
   all of them to your IP address. (If your DNS hosting service allows `ALIAS`
   records, those are a great way to only type in your IP address once.) You'll
   need `overview.example.com`, `overview-plugin-word-cloud.example.com`,
   `overview-plugin-entity-filter.example.com`,
   `overview-plugin-multi-search.example.com`,
   `overview-plugin-file-browser.example.com`, and
   `overview-plugin-fields.example.com`.
3. Make incoming traffic on ports 80 and 443 reach your computer. Log in to your
   router and go to the "port forwarding" section. Add an entry for port 80 and
   an entry for port 443, and point both at your computer. (You'll need your
   network-internal IP address -- something like `192.168.1.2` -- and not your
   public IP address.)
4. Browse to `http://overview.example.com`. You should see your documents.

Debug by running `./tail-logs` and reading the `overview-proxy` messages. It
will prompt, one step at a time, to register DNS records and ensure traffic is
routed correctly. Once `overview-proxy` says "SSL is enabled" for a URL, that
means a web server on the Internet accessed Overview on port 80.

Having routing problems? Sorry: in general, we can't help you solve them. One
common mistake is that your computer can't access _itself_ at the DNS address
you gave, but computers on the rest of the Internet can.

## <a name="upgrading">Upgrading Overview</a>

Does Overview have some new features you want? Open a terminal and do this:

1. `~/overview-local/stop`
2. `~/overview-local/update`
3. `~/overview-local/start`

The `update` command pulls down any changed docker images from Docker Hub. If you are wondering how to update the docker images please see [Overview Docker](https://github.com/overview/overview-docker).

Be aware that the `start` command also updates the overview-local code locally. 

## <a name="backuplinux"></a><a name="backupwinmac"></a><a name="backup">Backing up Overview's data</a>

You can copy all Overview's data into a single file.

Run `~/overview-local/backup backup.tar.gz`. This will create a file called `backup.tar.gz`
in the `overview-local` directory. (It will always be in that directory.) Store
it somewhere safe.

Watch out! The backup may be corrupt if you run this command _while Overview is
running_. We cannot recover from a corrupt backup. Play it safe: stop Overview
before you back up.

The first time you run the backup, you'll see a lot of messages about pulling
Docker images. That'll just happen the one time; every other invocation will be
silent.

## <a name="restorelinux"></a><a name="restorewinmac"></a><a name="restore">Restoring Overview from a backup</a>

After you've installed Overview and tested that it works, you can wipe all its
data and replace it with a backup's data.

Place your backup file (let's call it `backup.tar.gz`) in the `~/overview-local`
directory. (It _must_ be in that directory.)

Now run: `~/overview-local/restore-from-backup backup.tar.gz`.

This command will stop Overview and wipe all its data.

Overview backups are forward-compatible with newer versions of Overview for one
year. In other words: if you keep Overview up to date (by running `update`), you
will be able to restore from any backup that is less than one year old. (Don't
take that to mean a two-year-old backup is worthless. You can restore and
re-backup your data with interim versions of Overview to bring it up to date. We
haven't written instructions for this task.)

# <a name="uninstalling">Uninstalling</a>

If you want Overview gone forever, open a terminal and run these commands:

    ~/overview-local/stop                  # stop Overview
    rm -rf ~/overview-local                # remove Overview-related commands
    docker rm -v overview-blob-storage     # delete PDFs and uploaded files
    docker rm -v overview-database-data    # delete database
    docker rm -v overview-searchindex-data # delete search index
    docker rmi $(docker images -f dangling=true -q) # free disk space


# <a name="troubleshooting">Troubleshooting</a>

If Overview isn't running correctly, we'd love for you to file an issue on our
Issues page. Please open a terminal and run `~/overview-local/dump-logs` as
well; show us those logs so we'll know what Overview was thinking when it failed
you.

If you're curious, you can run `~/overview-local/tail-logs` and watch Overview's
log messages as they appear, while you use Overview in a browser window.

## <a name="configutation">Configuration</a>

We set default options in `overview-local/config/overview.defaults.env`.
**DO NOT EDIT `overview.defaults.env`**. Instead, copy/paste the variables you
want to edit into `overview-local/config/overview.env` alongside it, and edit
there.

Configuration options are documented [here](https://github.com/overview/overview-server/wiki/Configuration)

## Plugin views are empty or show broken links

This can happen if you are running a server that is accessible by other machines. Overview gets confused about the externally reachable address of the plugin servers. To fix this, set the OVERVIEW_ADDRESS environment variable before starting the server, like this:

    export OVERVIEW_ADDRESS=52.87.230.123
    ./start

Note that plugins communicate with the server on ports 3000-3100 (defined [here](https://github.com/overview/overview-local/blob/master/config/plugins.yml)) so adjust your firewall accordingly.

Also, only plugin views created after this change will work. Add a new view or re-upload your documents to get working plugins.

## `Cannot pull with rebase: You have unstaged changes.`

Did you try editing `overview.defaults.env` (or any other file)? That would
break Overview in a future version, and it's unnecessary. Copy the contents
of `overview.defaults.env` into `overview.env`, then run `git reset --hard`.

If that doesn't solve your problem, please add an issue to this project.

## Microsoft Edge says "Hmm, we can't reach this page."

We are aware of this issue: it affects lots of projects that use our technology.
We know of no workaround at present. Use any other web browser -- even Internet
Explorer, which also comes pre-installed on your Windows computer -- and
Overview will work fine.

