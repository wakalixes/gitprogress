#!/bin/bash

debug=0
cd checkout
cd Dissertation

read -p "press enter to delete old mastertex files... "
rm ../../texfiles/mastertex*

commitnum=0
commitlist=$(git log --reverse | grep 'commit ' | cut -d ' ' -f2)

for commithash in $commitlist
do

  echo "git commit number: $commitnum hash: $commithash"

  masterhash=$(git ls-tree -r $commithash | grep \diss-tex/diss-master.tex$ | tr ' ' '\t' | cut -f3)
  if [ -n "$masterhash" ]
  then
    mastertex=$(git cat-file $masterhash -p)
    #echo "$mastertex"
    texfiles=$(echo "$mastertex" | grep \\.tex | grep -Po '{\K[^}]*')
    if [ "$debug" -gt "0" ]
    then
      echo "-------------------------"
      echo "found necessary tex-files"
      echo "-------------------------"
      echo "$texfiles"
      echo
    fi

    if [ "$debug" -gt "0" ]
    then
      echo "------------------------------"
      echo "concatinating diss-master file"
      echo "------------------------------"
    fi
    disstex=$(echo "$mastertex")
    for item in $texfiles
    do
      if [ "$debug" -gt "0" ]; then echo "item: diss-tex/$item"; fi
      filehash=$(git ls-tree -r $commithash | grep \\diss-tex/$item | tr ' ' '\t' | cut -f3)
      if [ "$debug" -gt "0" ]; then echo "githash: $filehash"; fi
      #read -p "keypress to continue... "
      filetex=$(git cat-file $filehash -p)
      disstex=${disstex//'\input{'$item'}'/$filetex}
      #echo "$disstex"
    done
    if [ "$debug" -gt "0" ]; then echo; fi

    filename="../../texfiles/mastertex_$(printf "%03d" $commitnum)_$masterhash.tex"
    echo "saving to file $filename"
    echo "$disstex" > $filename
    echo
 
    commitnum=$(($commitnum+1))
  fi
done

# git ls-tree -r HEAD | grep \\.tex$ | tr ' ' '\t' | cut -f3 		# list of *.tex-hashes
# read -p "keypress to continue... "
# diff mastertex_023_6031d56ea646cfba612b9f34a90246f0cb2611fa.tex mastertex_024_6031d56ea646cfba612b9f34a90246f0cb2611fa.tex | cut -d " " -f1 | grep ">" | wc -l

