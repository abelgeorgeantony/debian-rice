# From Debian 12 base installation to GNOME rice!

## Index
 - [Editing sudoers list](#adding-a-user-to-the-sudoers-list)
 - [Connecting to WIFI](#connecting-to-wifi-from-a-cli)
 - [Turning on night light](#trying-to-turn-on-night-lightblue-light-filter)
 - [Install apps](#installing-the-apps-related-to-my-rice)
 - [Change font size](#changing-the-size-of-every-textfont)
 - [Install custom fonts](#installing-custom-fonts)


### Adding a user to the sudoers list!
The user account will not be automatically added to the sudoers list. So to add yourself to the sudo list, first go into **su** by executing:
```
su
```
Then it will ask for the **su** password(The password of your user account will not work, should give the root password).\
After becoming **su**, execute:
```
sudo visudo
```
This will open up a file to edit. Add:
```
yourusername    ALL=(ALL:ALL) ALL
```
Under
```
root    ALL=(ALL:ALL) ALL
```

After saving the file the user mentioned will be added to the sudoers list.

### Connecting to wifi from a CLI
It can be usefull to know your wifi interface name.
**List wifi devices:**
```
sudo ip link show
```
**Start WPA interactive shell:**
```
sudo wpa_cli
```
**Usefull commands in WPA interactive shell:**
Scan for wifi nearby:
```
scan
scan_results
```
Add a new network:
```
add_network
```
The above command will return a number which is the network ID. Let's take 0 as an example.
```
set_network 0 ssid "SSID_here"
set_network 0 psk "Passphrase_here"
enable_network 1
```
To get an IP address via DHCP:
```
sudo dhclient
```
After this the wifi should be connected.

### Trying to turn on "Night Light"/"Blue light filter"
A command to put up a night light filter using **gammastep** has been added in the **Sway config**. If you need to do it manually:
```
gammastep -O <Temperature(1000k - 25000k)>
```
Warning: **Trying to run gammastep while a gammastep process started by the Sway config or someone else is already running will crash the running gammastep process and seems to mess up the currently running TTY.**

### Installing the apps related to my rice
There is a script named "installapps.sh"(The script is not yet completed!) at **./scripts**. It will download the apps automatically. The script should be executed as sudo. The list of apps can be found out by reading the script. The apps will be declared in their respective arrays. Install the apps either using the script or manually.

### Changing the size of every text/font
I usually keep my laptop at a small distance from me because I have an external keyboard and laptop stand, so it is pretty stressing to look at the UI and its texts, as they are too small. An easy and fast trick is to go to accessibility settings and turn on **Large Text** option. Although this might not make it very precisely comfortable, it will atleast ease some stress when setting up the rice.\
To change the text size according to your liking open the **Gnome Tweaks** app. If you are on a system like ubuntu, Tweaks might not be installed. So install it first. In the Tweaks app there is a section named **Fonts** in the sidebar. You can customise mostly everything about your font in here.\
My settings for font:\
I usually use the large text option with the custom values in the Tweaks app.\
Interface Text: 16\
Monospace Text: 16\
Scaling Factor: 1.30\
I also change the default zoom of pages in firefox to **133%**. Firefox->Settings->Zoom->Default Zoom.

### Setting up GNOME extensions
Refer to ./guides/Gnome-Extensions.md for the list of extensions and its configurations.\

### Installing custom fonts
My native language is Malayalam. So when browsing the web I sometimes come across content that is displayed in Malayalam, the characters are replaced by placeholder characters. This is because Malayalam fonts are not included with debian. To install a font:\
First get a font from somewhere(Usually files that end with .ttf, some fonts can be found at **./fonts**). Then put the file in **/usr/local/share/fonts** (to access system-wide), **~/.local/share/fonts** (to access user-specific).
