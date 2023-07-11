#!/bin/sh
# the script doesn't seem to like removing '-' chars from the filenames, which causes issues when splitting
IFS=$'\n'

if [ $1 = "-h" ] || [ $1 = "--help" ]
then
	echo "param 1=music file. param 2=timestamp file."
	echo "timestamps must be formatted hh:mm:ss - [songname]"
	exit
fi

if [ $# -ne 2 ];
then
	echo "Invalid input. Please provide the album as param 1 and the timestamps as param 2."
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

music=$1
timestamps=$2
filetype=`echo "$1" | sed 's/.*\.\(.*\)$/\1/'`

itter=0

for i in `cat $timestamps`
do
	if [ $itter -ne 0 ]
	then

	time2=`echo $i | sed 's/\(........\).*/\1/'`
	ffmpeg -i "$music" -metadata artist="$artistname" -metadata album="$albumname" -metadata genre="$genretype" -ss $time1 -to $time2 "$filename".$filetype
	songname=`echo $i | sed -e 's/[^A-Za-z0-9._-]/_/g' | sed 's/.*-\s\?\(.*\)$/\1/'`
	filename=`echo "$artistname-$songname"`
	time1=$time2

	else
		itter=1
		time1=`echo $i | sed 's/\(........\).*/\1/'`
		songname=`echo $i | sed -e 's/[^A-Za-z0-9._-]/_/g' | sed 's/.*-\s\?\(.*\)$/\1/'`
		filename=`echo "$artistname-$songname"`
	fi
done

ffmpeg -i "$music" -metadata artist="$artistname" -metadata album="$albumname" -metadata genre="$genretype" -ss $time1 "$filename".$filetype

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
then
	rm "$music"
	rm "$timestamps"
fi
