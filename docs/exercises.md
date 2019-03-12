This document lists exercises you can do to familiarize yourself with `lxcm`. Unlike the tutorials, the exercises do not give exact procedures to complete them. You may find the tutorials and the manual helpful to assist with completing the exercises.

# 1 Basics

## 1.1 Container Management

### 1.1.1 Create a Debian Container (Wizard)

Using the `lxcm ez` wizard feature, create a new container called "debiantest" based off the `debian` template. The wizard will handle creation of the `debian` template.

### 1.1.2 Create a CentOS Template (Command Line)

Without using the wizard, create a new `centos` template.

### 1.1.3 Create a CentOS Container (Command Line)

Without using the wizard, create a new container based on the `centos` template called "centostest".

### 1.1.4 Delete the CentOS Container

Delete the container "centostest" that you just created.

## 1.2 Container Usage

### 1.2.1 Getting a Shell

Open a shell inside the "debiantest" container. Display the contents of "/etc/passwd" and then exit out of the shell.

### 1.2.2 Installing a Program

Install the `nginx` service inside the "debiantest" container.

### 1.2.3 Configuring Startup

Configure the `nginx` service to start on container start. Restart the container and verify the `nginx` service is running using the `pidof` tool.

## 1.3 Port Forwards and Firewall

### 1.3.1 Global Port Forward

Configure the "debiantest" container's `nginx` server to be accessible from anywhere. Nginx runs on port 80 by default. Upon completion, the service should be accessible from other computers.

### 1.3.2 Removing Forwards

Remove the forward you just added to the `nginx` server.

### 1.3.3 Local Port Forward

Create another container called "debiantest2" and start it. Configure the "debiantest" container's `nginx` server to be accessible from other containers. Verify the service is accessible from "debiantest2", but not from another computer.

### 1.3.4 Firewall Configuration - Egress

Create a firewall rule on "debiantest2" that prevents it from connecting to the internet via ports 80 and 443.

### 1.3.5 Firewall Configuration - Removal

Remove all of the firewall rules.

# 2 Advanced Features

## 2.1 Advanced Template Creation

### 2.1.1 Migration

Create a template based on another linux computer's contents. You will need root access to the system over ssh. (Skip this exercise if you do not have a system to migrate.)

### 2.1.2 Container Composition

Create a new template from the "debiantest" system called nginx. Create a new container from that template and verify the system has nginx installed.

## 2.2 Backups and Restoration

### 2.2.1 Container Backup

Take a backup of "debiantest" called initial.

### 2.2.2 Container Restore

Uninstall nginx from "debiantest". Restore the backup you created in the previous exercise, and confirm that nginx is now installed again.

### 2.2.3 Cross-container restore

Restore the initial backup from "debiantest" to "debiantest2".

### 2.2.4 Container Scrub

Scrub the container "debiantest2". Confirm that all changes made to the container have been lost.

### 2.2.5 Inspecting Backups

Add a file called "testfile" to "debiantest2". Take a backup of the container and delete the file. Inspect the backup of the container and confirm the file exists in the backup.

## 2.3 File Management

### 2.3.1 Transfer to Container

Create a text document called "test1". Copy the file to the "debiantest" container.

### 2.3.1 Transfer from Container

Create a text document called "test2" inside the "debiantest" container. Copy the file to the Desktop folder outside the container.

# 3 Comprehensive Exercises

## 3.1 FTP Server

Create a new debian container called ftp. Install a vsftpd server on that container configured to serve the folder "/ftp" inside the container. Create the port forwards required for ftp to work from other computers. Verify functionality by downloading a file.

## 3.2 PhpBB Server

Create two new debian containers: mysql and phpbb. Install mysql on one and configure it so that the server is only accessible from other containers. Install phpbb on the other and configure it for external access over port 80 (http). Ensure the program works by creating a new forum post.

## 3.3 Automatic Container Creation

Create a shell script that will create a new apache web server container.




