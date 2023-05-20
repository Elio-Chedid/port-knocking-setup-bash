# Port knocking Setup Script

This bash script automates the setup of `openssh-server` and `knockd` on a Linux system. It installs the required packages, modifies the knockd configuration file, sets up the network interface card, starts the knockd service, and configures the firewall.

## Usage

1. Open a terminal and navigate to the directory where the script is located.

2. Make the script executable by running the following command:

   ```bash
   chmod +x script.sh
   ```

3. Run the script with root privileges:

   ```bash
   sudo ./script.sh
   ```

4. Follow the prompts and provide the necessary inputs when requested.

5. The script will install `openssh-server` and `knockd` if they are not already installed. It will then configure knockd, set up the network interface card, start the knockd service, and configure the firewall.

6. The script will display the status of the configured ports and provide information about the knock service setup.

## Notes

- This script assumes you are running it on a Linux system with package managers such as `apt-get` and `ufw` available.

- Ensure that you have root privileges or sufficient permissions to run the necessary commands and modify the configuration files.

- The script modifies the knockd configuration file `/etc/knockd.conf` and the knockd default configuration file `/etc/default/knockd`. It also modifies the `/etc/ufw/ufw.conf` file and uses the `ufw` command to enable and disable ports.

- The script prompts you to enter the name of the network card you want to use. By default, it selects the first available network card excluding `lo`, `vir`, `wl`, `docker`, and non-numeric interfaces. You can override this default by entering the name of the network card manually.

- Ensure that you review the script and understand the modifications it makes to your system before running it.

## Disclaimer

Please use this script with caution and responsibility. I am not responsible for any damage or unintended consequences caused by running this script on your system.

---
