#!/bin/bash

mirror=http://mirror.ox.ac.uk/sites/mirror.centos.org/6.9/isos/x86_64
image=CentOS-6.9-x86_64-bin-DVD

wget ${mirror}/md5sum.txt > /tmp/md5.out 2>&1

for image in ${image}{1,2}.iso
do
  nohup wget ${mirror}/${image} > ${image}.out 2>&1 &
  grep ${image} md5sum.txt >> /tmp/files-to-check.txt
done

echo "Waiting for files to download..."
jobs
wait
echo "Verifying MD5 sums..."
md5sum -c /tmp/files-to-check.txt

if [ "$?" -eq "0" ]; then
  echo "All files downloaded successfully."
else
  echo "Some files failed."
  exit 1
fi

