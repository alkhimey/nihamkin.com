#!/bin/bash      

echo Building the blog...
blogofile build
echo Sending to production server...
#scp -r _site/* sartium@stud.technion.ac.il:~/public_html
s3cmd --delete-removed sync ./_site/* s3://www.nihamkin.com
