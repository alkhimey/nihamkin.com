#!/bin/bash 


POSTS_DIR=_posts
FILE_EXT=markdown
TEXT_EDITOR=emacs

read -d '' TEMPLATE <<"EOF"
---
categories: 
date: 
title: 
draft: True
---

EOF


if [ $# -le 0 ]; then
	echo "Usage: $0 postfix-name"
	exit
fi
if [ $# -ge 2 ]; then 
	echo "Warning: whitespaces in the name will be ignored" 
fi


cd $POSTS_DIR
last=`ls *.$FILE_EXT | sed 's/^\([0-9]*\).*/\1/g' | sort -n | tail -1`
next=`expr $last + 1`
next_name=${next}-$1.$FILE_EXT
echo "Creating new file ($next_name)..."
echo "$TEMPLATE" > $next_name
echo "Opening file in $TEXT_EDITOR..."
( $TEXT_EDITOR $next_name & )

