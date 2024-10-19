MANUALLY INSTALL THE SOLARWINDS ORION AGENT FOR LINUX
-----------------------------------------------------

You may need to install Orion agent for Linux software manually. Use these instructions with the downloaded agent file from the web console.

To install the agent manually, complete the following steps:

1. Copy the downloaded swiagent.tar.gz to the remote Unix/Linux server: scp or sftp file to /tmp
2. Extract swiagent.tar.gz into a directory ("inst" used in this example):
    mkdir /tmp/inst
    cd /tmp/inst
    gzip -d -c ../swiagent.tar.gz | tar xvf -
3. Execute the installation using one of the following commands:
   Sudo to super user priviledges:
    sudo ./install.sh
   Run as root user:
    su
    ./install.sh
