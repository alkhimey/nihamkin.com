Tags: shell, sh, linux
date: 2013/08/17 04:00:00
updated: 2013/09/25 04:30:00
title: Combining ls and cat Commands
draft: False

        

Very often, when exploring contents of directory trees, I find myself confused between the the "ls" and "cat" commands and mistakenly type one instead of the other. Both these commands are used pretty often and conceptually they have similar meanings. One says "print out a content of directory". The other says "print out the content of a file".
     
Therfore, it is natural for these commands to be combined into a single one. So, I decided to write a shell script that would do exactly this.

The following shell script will choose to run "ls" or "cat" depending on the type of the parameter (file or directory).
     
    :::sh

    #!/bin/sh
    
    ## lc.sh
    ## Artium Nihamkin
    ## August 2013
    ## 
    ## This script will to run "ls" or "cat" depending the type of the input.
    ##
    ## Examples where "ls" is invoked:
    ##    ./lc.sh file.txt
    ##    ./lc.sh
    ## Examples where "cat" is invoked
    ##    ./lc.sh ~/directory.name
    ##    ./lc.sh does.not.exist
    ##    echo "xxx" | ./lc.sh 
    ##
        
    # If stdin present, assume user meant cat
    #
    if [ ! -t 0 ] 
    then
        cat "$@"
        return
    fi
    
    # Find the argument that is file/directory name and test it
    # to find out if it is an existing directory. Other arguments are 
    # options and thus will begin with an "-".
    #    
    for v in "$@" 
    do
        if [ '-' != `echo "$v" | cut -c1 ` ] 
        then
            if [ -d "$v" ]
            then
                # A directory, use "ls".
                #
                ls "$@"
                return
             else
                # Not a directory, use 'cat'.
                # If this is not a file or a directory then cat will
                # print an error message:
                # cat: xxx: No such file or directory
                #
                cat "$@"
                return
            fi
        fi  
    done

    # No file name provided, assume the user is trying to ls 
    # the working directory
    #
    ls "$@" 
 
Notice that running this script without a file/directory name parameter is equal to a plain "ls" which will list the working directory, but if you provide an stdin input it will assume the user is expecting the behavior of a "cat".
     
Assuming that you have put this script in */my/pah/to/lc.sh* path, you can now add an alias to this command:

    :::sh
    alias lc="/my/path/to/lc.sh"

     
Add this line into *~/.bashrc* and it will run every time you start an interactive shell.
     
    :::sh
    $ ls
    lc.sh
    $ lc
    lc.sh
    $ mkdir test
    $ echo "abc" > test/test.txt
    $ lc -l test
    total 4
    -rw-rw-r-- 1 artium artium 4 Aug 17 03:47 test.txt
     lc test/test.txt
    abc
    $ echo xyz | lc
    xyz
     
You can even go as far as adding an alias for the "ls" and "cat" commands, thus overriding them. This will allow you to call "ls" on files and "cat" on directories and still get a desired effect.

    :::sh 
    alias ls="/my/path/to/lc.sh"
    alias cat="/my/path/to/lc.sh"


     
There two thing you need to know here :

* If for saome reason you will need to run the original command, you can type an "\" before it's name (for example *"\ls"*) and this will disregard any aliases and run the original command.

* Aliases are not expanded inside non-interactive shell scripts. So if you write "ls" inside a script, it will call the original "ls". This is good bacuase we don't want to break existing scripts that might be relaying on some esoteric behavior of "ls" or "cat" which is not imitated in my script. This is true as long as those scripts did not run *shopt -s expand_aliases* which causes the expansion of aliases inside non-interactive scripts. Pretty rare and low risk, yet good to be aware.

