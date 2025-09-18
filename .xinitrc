#!/bin/sh
xrandr --output eDP-1 --mode 1920x1200
feh --bg-fill /home/kas/Pictures/Wallpaper/m.jpg
setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle,caps:escape"
xset s 600 600 &
xss-lock -- slock &
xset dpms 300 600 900 &
dwmblocks &
picom --vsync &
xclip &
exec dwm
