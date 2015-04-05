#!/bin/bash

debug=0
texfilelist=$(ls -1 texfiles)
cd diffimages

read -p "press enter to delete old diffimage files... "
rm diffimage*

i=0
for item in $texfilelist
do
  filenew=$item
  if [ $i -gt "0" ]
  then
    echo "generating diff-image for files $i and $(($i+1)) ..."
    #read -p "keypress to continue... "
    screen -dmS session ../diffuse/diffuse_patched ../texfiles/"$fileold" ../texfiles/"$filenew" &
    sleep 2
    #wmctrl -c diffuse_patched
    killall python
    numold=$(echo "$fileold" | cut -d '_' -f2)
    numnew=$(echo "$filenew" | cut -d '_' -f2)
    mv image.png diffimage_"$numold"_"$numnew".png
  fi
  fileold=$filenew
  i=$(($i+1))
done

# ./diffuse_patched ../../../../texfiles/mastertex_023_d56f1c763a9342377d20dad659ead4e06f47999b.tex ../../../../texfiles/mastertex_024_d56f1c763a9342377d20dad659ead4e06f47999b.tex
