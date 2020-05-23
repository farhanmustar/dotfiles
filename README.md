Configuration files for a ROS developer who uses vim and byobu.

Usage:

```bash
git clone https://github.com/patrickcjh/dotfiles ~/dotfiles
rsync -a ~/dotfiles/ ~
rm -rf ~/dotfiles
```

Touchpad Multi Finger Configuration Using Fusuma
#Makesure can scroll. need to update dirver if cannot
#Example sudo apt-get install xserver-xorg-input-synaptics
Set user as input group
```bash
sudo gpasswd -a $USER input
```
Logout then login back
```bash
sudo apt-get install libinput-tools xdotool
```
Install ruby then fusuma and its plugin(fusuma is a ruby program)
```bash
sudo apt install ruby
sudo gem install fusuma
sudo gem install fusuma-plugin-tap
```
Configure gesture at ~/.config/fusuma/config.yml
Add fusuma to startup (asume fusuma install at default. use ```which fusuma```)
```bash
gnome-session-properties
```
Add command ```/usr/local/bin/fusuma -d```

