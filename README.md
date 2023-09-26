# void-helper

Void Helper is a configuration script for Void Linux that guides you through several steps with questions.

It is recommended to run this script as a regular user, not root, for security reasons. It will determine if you have sudo or doas installed.

## Content of the script

* Check for updates
* Install recommended packages
* Install development packages (optional)
* Enable non-free repository (optional)
* Install shell (optional)
* Configure a graphical environment
	* Install a desktop environment (optional)
	* Install a window manager (optional)
	* Install a terminal emulator (optional)
	* Install a terminal text editor (optional)
	* Install a graphical text editor (optional)
	* Install a web browser (optional)
	* Install a media player (optional)
	* Install an office suite (optional)
	* Install graphic design programs (optional)
	* Install container or virtual machine programs (optional)
	* Install a backup program (optional)
* Configure audio (optional)
* Configure network management (optional)
* Configure Bluetooth (optional)
* Configure Printing (optional)
* Configure Notebook Power Saving (optional)
* Configure NFS for sharing files (optional)
* Enable services

## How to use

* In order to use this script, you need Git to clone this repository. You can
install Git with the following command:

`xbps-install git`

* After that, clone the repository:

`git clone https://codeberg.org/ravendev/void-helper.git`

* And execute me as a regular user:

`sh void-helper/void.sh`

## License

This script is licensed under the GNU General Public License Version 3.
