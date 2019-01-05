This tutorial covers the recent additions to lxcm.

# Creating Containers (Wizard)

The lxcm utility now includes an command called `ez`. When run, this allows you to make new containers by answering a series of questions. If a template is needed to create a container, you can create it using the wizard as well.

```bash
lxcm ez
```

Try creating a simple debian container running the apache web server.

# Using Tab Completion

The command line now has support for tab completion. Use tab at any time while typing commands or options to get suggestions. Tab completion can considerably reduce the amount of time it takes to use the utility.

# Copying Files

In the past, you used to need to deal with the special filesystems to copy files into and out of containers. Now there is a command that allows this to be done. It even supports tab completion for files inside containers.

```bash
lxcm put mysql my-new-file-database.sql
lxcm get mysql /etc/passwd
```

# Autostart

You can configure a container to start with your computer. To do so, use the autostart command:

```bash
lxcm autostart [container name] manual/auto
```

# Inspecting Backups

In the past, you needed to restore a backup to another container to be able to look at it without service downtime. Now you can mount a container backup read-only for your investigation needs:

```bash
lxcm inspect mysql "[backup name]”
```

