#!/bin/sh
IFS=$'\n'

if [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
	echo "param 1=music folder containing all songs you wish to tag. Filenames must have no spaces"
	exit
fi

if [ $# -ne 1 ];
then
	echo "Invalid input. Please provide the folder containing all songs as a parameter."
	exit
fi

if [ ! -d "$1" ]
then
	echo "This directory does not exist!"
	exit
fi

answer=N

echo -n "Enter artist name: "
read artistname
echo -n "Enter album name: "
read albumname
echo -n "Enter genre: "
read genretype
echo -n "Do you wish to delete the original files after splitting? (y/N): "
read answer

folder=$1

for i in `ls $folder`
do
	ffmpeg -i "$folder/$i" -metadata artist="$artistname" -metadata album="$albumname" -metadata genre="$genretype" $i
done

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
then
	rm -rf "$folder"
fi
