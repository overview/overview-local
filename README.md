**You're in the right place. The Overview Docs public server was decommissioned
Aug. 1, 2021.** Follow these instructions to use Overview Docs.

This project lets users run Overview Docs on their own machines.

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

## <a name="linux">Installation: Linux</a>

We've tested in Ubuntu Linux 18.04.4 LTS (Bionic Beaver); other distributions
should work just as well.

1. Open the "Terminal" program.
1. [Install Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository):
    ```
    sudo apt-get update
    sudo apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    ```
1. Install `docker-compose`:
    ```
    sudo apt-get install docker-compose
    ```
1. Make yourself a member of the `docker` group. Run `sudo usermod -a -G docker $USER` and then *log out* (of your entire desktop environment) and log back in. Reopen your terminal and type `groups`; make sure you're in the `docker` group.
1. Copy/paste this command into the terminal and press Enter:
    ```
    curl https://raw.githubusercontent.com/overview/overview-local/master/install-from-scratch.sh | sh
    ```

If you get the error `ERROR: Couldn't connect to Docker daemon at http+docker://localunixsocket - is it running?` you probably need to log out and back in again, so that the newly updated environment variables can take effect.

If all goes well, you'll see progress bars. Grab a coffee; in a few minutes, return
to see Overview's URL on the screen. (It's [http://localhost:9000/](http://localhost:9000/).)

## <a name="mac">Installation: Mac OS X</a>

1. Install [Docker for Mac](https://docs.docker.com/docker-for-mac/install/).
1. Give Docker more resources (see below).
1. Install `git`, from [https://git-scm.com/downloads](https://git-scm.com/downloads).
1. Open Mac OS's _Terminal_.
1. Copy/paste this command into the terminal and press Enter: `curl https://raw.githubusercontent.com/overview/overview-local/master/install-from-scratch.sh | sh`

If all goes well, you'll see progress bars. Grab a coffee; in a few minutes, return
to see Overview's URL on the screen. (It's [http://localhost:9000/](http://localhost:9000/).)

## <a name="windows">Installation: Windows 10</a>

1. Install [Docker for Windows](https://docs.docker.com/docker-for-windows/install/).
1. Give Docker more resources (see below).
1. Install [Git for Windows](http://gitforwindows.org/).
1. Open _Git Bash_. (We'll call this "the terminal" from now on.)
4. Copy/paste this command into the terminal and press Enter: `curl https://raw.githubusercontent.com/overview/overview-local/master/install-from-scratch.sh | sh`

If all goes well, you'll see progress bars. Grab a coffee; in a few minutes, return
to see Overview's URL on the screen. (It's [http://localhost:9000/](http://localhost:9000/).)

## <a name="resources">Giving Overview enough resources (on OS X and Windows)</a>

Linux users should skip this section, but Windows and Mac users probably need it.

On OS X and Windows, Overview runs in Docker's "virtual machine". The virtual
machine restricts the amount of memory and number of processors Overview can
use.

We recommend you give Overview at least 3GB of memory.

Here's how to give the Docker virtual machine more memory:

1. Stop overview-local.
1. Open Docker's "Settings".
1. Go to "Advanced".
1. Set memory to 3Gb.
1. Click "Apply".

# <a name="administration">Administration</a>

## <a name="starting">Starting Overview</a>

When you want to start Overview, run `~/overview-local/start` in a terminal.
That `curl | sh` command you used to install Overview stored some files on
your computer to make future startups much quicker. 

Overview and its plugins bind to `localhost` on ports `9000` and `3000-3010`.

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

Overview-local runs by default in single user mode, meaning there is only one user and no logins. To enable logins and multiple users, add the following lines to `~/overview-local/config/overview.env`

    OV_MULTI_USER=true
    OV_APPLICATION_SECRET=some-imp0ssib1e-t0-guess-string-of-about-80-chars
    
Create your own random `OV_APPLICATION_SECRET`. If you don't, anybody will be able to log in as any user and access any user's documents. On Linux and Mac OS, this command will display a random 80-char string: `< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c80; echo`

The default user and password is `admin@overviewdocs.com`. You should change the password immediately. You can create new user accounts through the Admin menu when logged in. The registration form on the front page will by default print confirmation and password reset emails to the console, unless you [configure an SMTP server](https://github.com/overview/overview-server/wiki/Configuration).

See also [configuration](#configuration) below.

## <a name="multi-user">Enabling SSL and public access</a>

Normally, overview-local only listens on the "localhost" network interface.
That means other computers won't have access to your files (unless you have
bizarre firewall rules or a virus).

If you want to create a publicly-visible Overview service, add lines like
these to `~/overview-local/config/overview.env`.

    OV_MULTI_USER=true
    OV_APPLICATION_SECRET=your-random-80char-secret
    OV_DOMAIN_NAME=overview.example.com

Be sure to supply your own `OV_APPLICATION_SECRET`, as documented above.

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
   `overview-plugin-metadata.example.com`.
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

    ~/overview-local/stop                                    # stop Overview
    rm -rf ~/overview-local                                  # remove Overview-related commands
    docker volume rm overviewlocal_overview-acme             # delete SSL certificates
    docker volume rm overviewlocal_overview-blob-storage     # delete PDFs and uploaded files
    docker volume rm overviewlocal_overview-database-data    # delete database
    docker volume rm overviewlocal_overview-searchindex-data # delete search index
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

## Disk space problems

If Docker or your programs log errors such as "No space left on device", it
may be because Docker is storing old, unused versions of Overview. (Every
`./stop` and `./start` has the potential to download a new version of
Overview, leaving old images unused. To delete those images, you may run:
`docker system prune -a`. If you run Overview on a dedicated machine, you
may wish to schedule this command to run regularly.

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

