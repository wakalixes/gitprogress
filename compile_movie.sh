#!/bin/bash

# convert diffimage_000_001.png -gravity south -background black -splice 0x920 movimage_000.png
# identify diffimage_000_001.png

debug=1

# get list of commit dates

cd checkout
cd Dissertation

commitnum=0
commitlist=$(git log --reverse | grep 'commit ' | cut -d ' ' -f2)

for commithash in $commitlist
do
  commitdate=$(git show -s --format=%ci $commithash)
  commitdate=$(echo "$commitdate" | tr ' ' '\t' | cut -f1)
  #echo "$commitdate"
  datestrings[$commitnum]=$commitdate
  commitnum=$(($commitnum+1))
done

# get diff-image list
cd ..
cd ..
cd diffimages
diffimagefilelist=$(ls -1 diffimage*)
diffimagefilearray=($(ls -1 diffimage*))

read -p "press enter to delete old movieimage files... "
rm movieimage*

# get largest diff-image properties
maxheight=0
for item in $diffimagefilelist
do
  imageprops=$(identify "$item")
  sizeinfo=$(echo "$imageprops" | tr ' ' '\t' | cut -f3)
  imgwidth=$(echo "$sizeinfo" | tr 'x' '\t' | cut -f1)
  imgheight=$(echo "$sizeinfo" | tr 'x' '\t' | cut -f2)
  if [ "$imgheight" -gt "$maxheight" ] 
  then
    maxheight=$imgheight
  fi
  if [ "$debug" -gt "0" ]
  then
    echo "properties of diffimage $item"
    echo "$imageprops"
    echo "width: $imgwidth pixel"
    echo "height: $imgheight pixel"
    echo
  fi
done
maxheight=$(($maxheight+$maxheight%2))
if [ "$debug" -gt "0" ]
then
  echo "$maxheight"
  echo
fi

# create movie-images
i=0
for item in $diffimagefilelist
do
  movieimgfile=$(echo "movieimage_$(printf "%03d" $i).png")
  echo "generating movie-image $movieimgfile from file $item ..."
  itemprops=$(identify "$item")
  itemsizeinfo=$(echo "$itemprops" | tr ' ' '\t' | cut -f3)
  itemheight=$(echo "$itemsizeinfo" | tr 'x' '\t' | cut -f2)
  if [ "$debug" -gt "0" ]
  then
    echo "properties of current diffimage"
    echo "$itemprops"
    echo "height: $itemheight pixel"
    echo
  fi
  heightdiff=$(($maxheight-$itemheight))
  if [ "$debug" -gt "0" ]
  then
    echo "difference in height: $heightdiff"
    echo
  fi
  convert $item -flop -gravity south -background black -splice 0x$heightdiff $movieimgfile
  convert $movieimgfile -gravity west -background black -splice 16x0 $movieimgfile
  convert $movieimgfile -rotate 270 -gravity southwest -fill white -annotate +2+2 ${datestrings[$i]} $movieimgfile
  i=$(($i+1))
done

# create movie
videoframerate=30
framesperimg=6
imgframerate=$(($videoframerate/$framesperimg))
videofile="movie_out.mp4"
read -p "press enter to delete old movie file... "
rm $videofile
echo "creating video file $videofile ..."
ffmpeg -framerate $imgframerate -i movieimage_%03d.png -c:v libx264 -r $videoframerate -pix_fmt yuv420p $videofile
