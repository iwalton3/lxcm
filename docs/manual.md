# What is it?

LXCM is a container management system for managing lxc containers. It
was designed to make containers easy to use. It manages the underlying
configuration, filesystems, ip addresses, and user/group id mappings of
the containers. It also includes a firewall manager for managing port
forwards into containers and other access rules, with support for
aliases and automatic resolution of container IP addresses.

The container filesystem uses various layered filesystems to achieve an
optimal usage of disk space across multiple containers. A template is a
read-only basis for a container, which multiple containers can share.
Changes from the template are stored in a scratchfs, which can be
backed-up and reverted to recover from problems. All containers are
isolated from each other and run as separate user and group ranges.
Assuming an up-to-date kernel, escaping from a container is extremely
difficult.

# Installation

LXCM may only be installed on up-to-date Debian and Ubuntu systems.
If only the firewall manager component is desired, lxcm may be
installed on any system. It is *critical* that the host system LXCM
is installed on be clean and up-to-date.

Installation of lxcm is easy. As root, download lxcm and run the install
command:

```bash
git clone https://github.com/iwalton3/lxcm
cd lxcm
bash lxcm install
```

The script will automatically install all the dependencies and configure
the system for managing containers.

To use the system on Ubuntu, two additional commands are needed to allow
containers to function and to get command completion:

```bash
chmod 755 /var/lib/lxc
echo ". /etc/bash_completion" >> ~/.bashrc
```

Regardless of which system you use, you need to restart your shell or
enter this command to load the command completions:

```bash
. /etc/bash_completion
```

# Getting Help

LXCM has a built-in help command feature listing command syntax. To
access it, simply run the program without arguments:

```bash
lxcm
```

LXCM also has full support for tab completion. To get a list of commands
or suggestions, press the tab key twice.

# Creating and Managing Templates

## Creating Templates

There are currently 4 ways to create a template, depending on the use
case. Containers may also be created by using the container creation
wizard. (See "Creating Containers".)

### Create a Blank OS Template

You can create a base template from one of lxc’s built-in template
recipes. This results in a base system that may be used to create
container from scratch. Some supported operating systems include debian,
ubuntu, centos, and alpine. (Note: To create a centos container, you
must run `apt install rpm`, as wrong as that may seem!)

```bash
lxcm template debian debian-template
```

### Migrate a System over SSH

You can download a system over ssh and use that as the basis of a
container. Please note that this may take some time to complete,
especially if the system has a graphical environment installed. You need
to have root SSH enabled on the system you are migrating from. Sshjail
is supported, but the user will need to confirm the connection.

```bash
lxcm migrate [some ip address] [template-name]
```

### Create from Old Filesystem

You can move the old file structure from the previous system into the
LXCM templates folder if you want to use it as the basis for a template.
For instance, this creates the template “prior-system” from the old
filesystem.

```bash
mv /old /var/lib/lxcm/templates/prior-system
```

### Create from Container

If a lot of changes are made to a container, these changes do not
propagate back to other containers made from the same template. Instead
of having to create a backup of the modified container and restore it to
new containers, a modified container may be turned into a new template,
saving time and disk space.

```bash
lxcm compose [container name] [template name]
```

## Managing Templates

LXCM supports compression and deletion of templates. Compressing a
template will make it take up less space, but all containers running
from the template must be restarted.

```bash
lxcm compress [template name]
```

Deleting a template frees up the space that template was using. **It
will delete all containers and container backups dependent on the
template!**

```bash
lxcm destroy-template [template name]
```

You can list the templates using this command:

```bash
lxcm list-templates
```

# Creating and Managing Containers

Containers are based on a template. If you have not already made a
template, you must make one before creating any containers. Containers
contain a scratchfs, which are all the changes that have been made to
the container that are not in the template. Unlike some other systems,
these scratch filesystems are persisted across container restarts.

## Creating Containers

You can use the guided wizard to create a container (and any templates
needed):

```bash
lxcm ez
```

To create a container based on a template, run the following command:

```bash
lxcm new [template name] [container name]
```

Containers are created nearly instantly, as all the initial files are
contained in the template and do not need to be copied to create a
container.

## Starting and Stopping Containers

To start the container, run this command:

```bash
lxcm start [container name]
```

Starting a container will, by default, not start any services in the
container except init. To configure services to start on container
startup, enter this command:

```bash
lxcm edit-startup [container name]
```

List all the commands you want to run on the system, being sure to put
“&” after any that need to be run in the background. You can use
standard service start commands, such as `systemctl` or `service`,
depending on the container OS.

To stop or restart a container, run the corresponding command command:

```bash
lxcm stop [container name]
lxcm restart [container name]
```

## Managing Containers

### Listing Containers

You can list the containers using this command:

```bash
lxcm list-containers
```

### Shell Access

You can launch a command line as root into a container using this
command:

```bash
lxcm shell [container name]
```

If you are concerned that a container is infected, you can run a safe
shell or clean the configuration:

```bash
lxcm safe-shell [container name]
```
```bash
lxcm clean [container name]
```

Cleaning a container removes shell configurations, as well as some
executables that are not needed to manage the container. (These include
iptables, su, and sudo.)

### Backups and Restoration

The changes to a container that have been made since the template may be
backed up and restored. Backups are container-specific. To create a
backup, use this command:

```bash
lxcm backup [container name] [backup name]
```

To list the backups for a container, use this command:

```bash
lxcm list-backups [container name]
```

To restore a container, use this command:

```bash
lxcm restore [container name] [backup name]
```

To revert all the changes made to a container, use this command. It
restores the state to that of the template:

```bash
lxcm scrub [container name]
```

You can also restore a container backup to a different container,
although if the template is different the results are hard to predict.

```bash
lxcm force-restore [source container] [backup name] [destination
container]
```

To look at a backup without restoring it, use the inspect command:

```bash
lxcm inspect [container name] [backup name]
```

### Copying Files To and From Containers

The put and get commands allow for file copies between the host system
and the containers, managing all uid/gid shifts in the process:

```bash
get CONTAINER CONTANER-PATH [LOCAL-PATH]
put CONTAINER LOCAL-PATH [CONTANER-PATH]
```

### Managing Autostart

Containers may be started with the system. This configuration may be
changed using the autostart command:

```bash
lxcm autostart [container name] manual/auto
```

The install command installs a systemd unit that allows this feature
to function. To manually start autostart containers, or stop all
containers, the service command may be used:

```bash
lxcm service start/stop
```

# Managing Firewall Rules

## Port Forwarding

Containers are, by default, not accessible from the host or outside
network. To make a service on a container available, a port forward must
be created. The port forwards have three modes:

1.  private – The service is available to other containers only.
2.  public – The service is available to other servers on the network
    only.
3.  both – The service is available everywhere.

Regardless of which option is selected, the services are always
available from the host the containers are running on if any port
forward is set. Port ranges may be specified using two numbers with
a dash between them (such as 11000-13000). This is useful for ftp, as
it requires a range of ports forwarded for passive connections.

The command to create a port forward is this:

```bash
lcxm forward add [tcp/udp/both] [host port] [container port] [container name] [private/public/all]
```

To remove a port forward, run the same command with “remove” instead of
“add”. To get a list of port forwards, use this command:

```bash
lcxm list-forwards
```

## Firewalls

LXCM has a built-in firewall rule manager with support for aliases and
automatic container name resolution.

### Creating a Firewall Policy

To create an alias, use this rule:

```bash
alias [name] [ip or ip ranges]
```

You can specify multiple ip addresses or ranges by separating them with
commas. Do not include spaces with the commas. Aliases may be used in
place of ip addresses to make the rules easier to understand and change.

To filter between containers, use local rules:

```bash
local [tcp/udp port] allow/deny [container,]
```

Please note that local rules also affect outbound traffic from a
container, due to a bug in the system. Using a local rule to deny
traffic from port 80 to other containers also denies traffic to update
servers. If possible, consider making the forward public only instead of
blocking with local rules.

To filter from the outside world to and from containers, use container
rules:

```bash
outc [tcp/udp port] allow/deny [container,] [to alias/ip,]
```
```bash
inc [tcp/udp port] allow/deny [alias/ip,] [to container,]
```

To filter traffic from the outside world to and from the host, use host
rules:

```bash
in [tcp/udp port] allow/deny [alias/ip,]
```
```bash
out [tcp/udp port] allow/deny [to alias/ip,]
```

There are no known issues with container and host rules conflicting.

### Loading a Firewall Policy

Firewall policies are saved into a file and then loaded with lxcm using
a command. They may also be constructed dynamically using a script.

To load a firewall from a file, use:

```bash
lxcm fw load [firewall file]
```

The current firewall may also be saved to a file:

```bash
lxcm fw save [firewall file]
```

To update firewall rules with a text editor and re-apply them, use this
command:

```bash
lxcm fw edit
```

The firewall rules will be applied immediately after closing the text
editor.

To manage firewall rules dynamically with a script, clear the firewall,
add all the rules, and reload it:

```bash
lxcm fw clear
lxcm fw append [firewall rule…]
[more firewall append commands…]
lxcm fw reload
```

You also need to reload the firewall if you reboot the system. You can
add an @reboot entry to crontab to do this for you.

# Known Issues

Currently, I am aware of the following issues with the container system:

1.  FTP requires a port forward range to work. They can be specified with
    the normal port forward syntax, just use a dash: 11000-13000.
2.  The using winbind requires special changes to be made, as it uses gid
    and uid ranges outside of the allocated area of the container.
3.  Splunk cannot run from any directory except /extrafs, which is
    excluded from backups. See “Special Filesystems”.

# Internal Details

## Special Filesystems

There are two "magic" filesystems in lxcm. They are /mnt and /extrafs.
Both are NOT covered by backups. (Restores, scrubs, and backups do not
affect files stored there.)

1.  mnt: Allows elevation of uids and gids for easy file copy. Place
    your files from the bode system in `/var/lib/lxcm/CONTAINER/mnt`. They
    will be accessible from within the container and moved into it
    without you having to manually translate the uids and gids.
2.  extrafs: Allows use of programs which cannot tolerate a layered
    filesystem, such as splunk. Move the `/opt/splunk/var/lib` folder to
    `/extrafs` and then symlink the lib folder. (`ln -s /extrafs/lib
    /opt/splunk/var/`)

## Layered Filesystem

This is an overview of how LXCM arranges the filesystems for containers.
LXCH means `/var/lib/lxcm/`.

1.  `LXCH/templates/[TMPT]` - The mount point for a squashed template,
    or home of an unsquashed template. Files here are normal.
2.  `LXCH/containers/[CONT]/templatemount` - The mountpoint for the
    template, with the uid/gid increase in effect.
3.  `LXCH/containers/[CONT]/scratchfs` - Contains the changes the
    container makes from the template. Files here have an elevated
    uid/gid.
4.  `LXCH/containers/[CONT]/mnt` - Contains files you want to copy
    in/out of the container. Files here are normal.
5.  `LXCH/containers/[CONT]/extrafs` - Contains files for special needs
    applications. Files here have an elevated uid/gid.
6.  `LXCH/containers/[CONT]/backups` - This is where the backup files
    for a container are stored.
7.  `/var/lib/lxc/[CONT]/rootfs` - The actual root filesystem for a
    container. Files here have an elevated uid/gid.

## Addressing Scheme

Containers use an internal addressing scheme of 192.168.100.0/24.
Containers are numbered automatically, and all firewall and forward
rules are translated to the IP address before being installed into
iptables. Containers are not allowed to talk to each other directly.
Containers are forced to communicate with each other by hitting the host
ip address of the system, and the port forward specified must be either
private or all (the default). Public forwards are only accessible from
the host and external systems. Container IPs also correspond to their
uid/gid offset. This information is stored in
`LXCH/containers/[CONT]/sNum`. The uid/gid is 100000 times the sNum
value.

## Container Limits

To prevent denial of service attacks, containers have limitations placed
on them. Containers are limited to 5000 processes, 20 percent of CPU,
and 256MB of RAM by default. RAM and CPU limits are only enforced when
the system is at maximum load. Normally a container can use as much RAM
and CPU as it wants.
