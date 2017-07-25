#!/bin/bash
##-------------------------------------------------##
##                   mp3sort.sh                    ##
##-------------------------------------------------##
# Sorts the contents of a specified directory 
# containing mp3s (ignoring any other files) into 
# subdirectories based on album name.  
# mp3sort.sh will create subdirectories as required 
# in the target directory. 
# mp3sort also prints an index file inside each
# album subdirectory containing the extracted 
# metadata.
# Usage - mp3sort.sh inputdir targetdir

#TODO - Needs reliance on id3v2 removed as that library is now unsupported

# check dependencies are met
if [ ! -e $(type id3v2) ] ; then
  printf '%-s\n' "Dependency not met: id3v2" ;
  exit ;
fi

#ensure the correct number of arguments
if [ $# -lt 2 ] ; then
  printf '%-s\n%-s\n' "Error: not enough arguments supplied" "Usage: mp3sort.sh [options] inputdir targetdir" ;
  exit ;
fi

#make temporary dir
if [ ! -e ~/temp/mp3sort/ ] ; then
  mkdir -p ~/temp/mp3sort/ ;
fi

#capture contents of inputdir in a variable
INPUT=$(ls $1) ;

#---- start text filtering loop -----
for MP3NAME in $INPUT ;
do
#only process mp3 files
case $MP3NAME in
  *mp3*)
#print metadata to tmp file
id3v2 -l $1/$MP3NAME > ~/temp/mp3sort/$MP3NAME.data ;

# filter relevant info from raw metadata
ALBUM=$(cat ~/temp/mp3sort/$MP3NAME.data | sed -n '/^TALB/p' | sed 's/.*): //') ;
TRACK=$(cat ~/temp/mp3sort/$MP3NAME.data | sed -n '/^TIT2/p' | sed 's/.*): //') ;
COMPOSER=$(cat ~/temp/mp3sort/$MP3NAME.data | sed -n '/^TCOM/p' | sed 's/.*): //') ;
PERFORMER=$(cat ~/temp/mp3sort/$MP3NAME.data | sed -n '/^TPE1/p' | sed 's/.*): //') ;
GENRE=$(cat ~/temp/mp3sort/$MP3NAME.data | sed -n '/^TCON/p' | sed 's/.*): //' | awk '{print $1}') ;
TRACKNO=$(cat ~/temp/mp3sort/$MP3NAME.data | sed -n '/^TRCK/p' | sed 's/.*): //') ;
PUBLISHER=$(cat ~/temp/mp3sort/$MP3NAME.data | sed -n '/^TPUB/p' | sed 's/.*): //') ; 
YEAR=$(cat ~/temp/mp3sort/$MP3NAME.data | sed -n '/^TYER/p' | sed 's/.*): //') ;  

# print fields in human-readable format to file
printf '%-s\n%-s\n%-s\n%-s\n%-s\n' "Album: $ALBUM" "Track: $TRACK" "Composer: $COMPOSER" "Performer: $PERFORMER" "Genre: $GENRE" "Track number: $TRACKNO" "Publisher: $PUBLISHER" "Year: $YEAR" >> $2/initial_output ;
;;
esac

done
#-----  end loop  ------

#filter output to extract album names and make album directories
grep Album $2/initial_output | sed "s#/#,#gp" | while read ALBUM ; do
    if [ ! -x "${ALBUM/Album: /}" ] ; then
    mkdir "${ALBUM/Album: /}"
    fi
done

## move files into new subdirs ##

#new input VAR
INPUT2=$(ls $1) ;

for MP3NAME2 in $INPUT2 ;
do
#only process mp3 files
case "$MP3NAME2" in
  *mp3*)
    # cp mp3 files to new subdirs
    cp "$1/$MP3NAME2" "$2/$(/usr/bin/id3v2 -l "$1/$MP3NAME2" | sed -n '/^TALB/p' | sed 's/.*): //' | sed 's#/#,#g')" ;
  ;;
esac

# clear tmp data so as not to interfere with future runs.
rm -r ~/temp/mp3sort/* ;

return 0





