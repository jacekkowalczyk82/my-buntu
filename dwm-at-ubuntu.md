# How to install and DWM at Ubuntu 

* Install packages 

```
sudo apt install neofetch htop dwm suckless-tools stterm dmenu curl mc vim git emacs 
sudo apt install nitrogen 
```

* Run `nitrogen` and configure , add background directories and select you favourite image as wallpaper. 
* Select st as your default terminal emulator

```
sudo update-alternatives --config x-terminal-emulator 
```

   
* Create `~/.xinitrc` file 

```

#~/.xinitrc

exec nitrogen --restore &
#exec compton -b &

while true ; do 

    load=$(cat /proc/loadavg |cut -d " " -f 3 )
    uptime=$(uptime -p)
    load_uptime="Load15: ${load}; ${uptime}"

    xsetroot -name "`date '+%Y-%m-%d %H:%M.%S' ` $load_uptime "; sleep 1; 
done &

exec dwm

```

* Make it executable and create a symbolic link .xsession

```
chmod 755 ~/.xinitrc
ln -s ~/.xinitrc ~/.xsession

```

* Create a file `/usr/share/xsessions/custom-dwm.desktop`

```
[Desktop Entry]
Name=Custom-DWM
Exec=/etc/X11/Xsession

```


* **Voila  - Now you can select stock DWM or your custom DWM session on loggin screen.**
