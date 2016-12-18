#!/bin/bash

for each in `mysqladmin -u user -ppassword processlist | awk '{print $2, $4, $8}' | grep mailer | grep shiksha | awk '{print $1}'`
do 
	mysqladmin -u root -ppassword kill $each;
done
