#!/bin/bash

work_dir=/home/public/scans
retire_age=40320       # minutes
die_age=80640

trash_dir=/${work_dir}/.Trash

find ${work_dir} -maxdepth 1 -type f -mmin +${retire_age} -print0 | xargs -0 -r mv --target-directory=${trash_dir}

find ${trash_dir} -maxdepth 1 -type f -mmin +${die_age} -print0 | xargs -0 -r unlink

