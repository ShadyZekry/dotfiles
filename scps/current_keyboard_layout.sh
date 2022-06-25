# !bin/bash

setxkbmap -print -verbose 10 |\
  grep layout |\
  awk '{split($0,a," "); print a[2]}'
