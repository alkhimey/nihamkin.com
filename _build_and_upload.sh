#!/bin/bash      

echo Building the blog...
blogofile build

echo Adding files to git...
git add .

echo Issuing git status...
git status
read -p "Press [Enter] key to start commiting..."

echo Commiting changes...
git commit

echo Pushing changes to server...
git push

echo Sending to production server...
#scp -r _site/* sartium@stud.technion.ac.il:~/public_html
s3cmd --delete-removed sync ./_site/* s3://www.nihamkin.com
