Tags: Blogofile, Emacs
date: 2012/10/13 15:00:00
title: Strange Blogofile IO Error
url: 2012/10/13/strange-blogofile-io-error/
save_as: 2012/10/13/strange-blogofile-io-error/index.html
summary: Sometimes when building a blogofile site I encounter "No such file or directory" IO error. In this article I will explain the cause of the error as well as how to prevent it.

Sometimes when building a blogofile site I encounter the following IO error:
    
    :::python
    Traceback (most recent call last):
      File "/usr/local/bin/blogofile", line 9, in <module>
        load_entry_point('Blogofile==0.7.1', 'console_scripts', 'blogofile')()
      File "/usr/local/lib/python2.7/dist-packages/Blogofile-0.7.1-py2.7.egg/blogofile/main.py", line 135, in main
        args.func(args)
      File "/usr/local/lib/python2.7/dist-packages/Blogofile-0.7.1-py2.7.egg/blogofile/main.py", line 201, in do_build
        writer.write_site()
      File "/usr/local/lib/python2.7/dist-packages/Blogofile-0.7.1-py2.7.egg/blogofile/writer.py", line 53, in write_site
        self.__write_files()
      File "/usr/local/lib/python2.7/dist-packages/Blogofile-0.7.1-py2.7.egg/blogofile/writer.py", line 103, in __write_files
        t_file = open(t_fn_path)
    IOError: [Errno 2] No such file or directory: './.#index.html.mako'
    
This error was a bit confusing. Why does it say that index.html.mako does not exist when it is open right here in my editor? 

Well the editor, specifically Emacs is the cause of problem here. If you do not save your files immediately before running _blogofile build_ there is a chance that an Emacs auto-save file will appear in your directory. The file looks like _#index.html.mako#_ and blogofile probably have problems with the unusual file name. Once you save your files with _C-x C-s_ the file will be gone.

Alternatively you can make Emacs save the auto-save files in one dedicated directory. Here is an [emacswiki article](http://emacswiki.org/emacs/AutoSave) that explains how to achieve this.
