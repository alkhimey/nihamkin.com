nihamkin.com
============

This is the source code used for my bolg. It is based on Pelican and is sttically generated.

The output is served statically from AWS S3.


Setting-Up Pelican
-------------------

```
apt-get install python-pip
pip install pelican
sudo apt-get install pelican
echo -e "export LC_ALL=en_US.UTF-8\nexport LANG=en_US.UTF-8" >> ~/.bashrc && source ~/.bashrc
```

Running Localy
---------------

```
make html
make serve
firefox http://127.0.0.1:8000/
```

Upload to s3
-------------
```
apt-get install s3cmd
Created IAM User and Access Key
s3cmd --configure 

make publish
make s3_upload

