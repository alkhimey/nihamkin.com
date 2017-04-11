Tags: Blogofile
date: 2013/02/22 20:00:00
title: Start New Blogofile Post With a Single Command
url: 2013/02/22/start-new-blogofile-post-with-a-single-command
save_as: 2013/02/22/start-new-blogofile-post-with-a-single-command/index.html



I wrote a bash script which should allow starting blogofile blog posts more conveniently. This will set up everything needed with a single command.

This script will perform:

1. Create a file in the _\_posts_ directory. The file name will be prefixed with the next number in the sequence (personal choice to enumerate the markdown files for better organization)

2. The file will contain a starting template for a markdown blog post (a header with placeholders for title, date etc.)

3. Add the file to source control.

4. Open the file in emacs.

The script is:

    :::bash 
    #!/bin/bash 
    
    
    POSTS_DIR=_posts
    FILE_EXT=markdown
    TEXT_EDITOR=emacs
    SOURCE_CONTROL_CMD="git add"
    
    read -d '' TEMPLATE <<"EOF"
    Tags: 
    date: 
    title: 
    draft: True
    
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
    echo "Adding file to source control"
    ( $SOURCE_CONTROL_CMD $next_name )
    echo "Opening file in $TEXT_EDITOR..."
    ( $TEXT_EDITOR $next_name & )


The way it is currently written, it supposed to work from the main directory (one above "_\_posts_"), but feel free to tweak it for your needs. 

Do not forget to add a "\_" prefix, otherwise when you build, blogofile will copy it into "_\_site_".
