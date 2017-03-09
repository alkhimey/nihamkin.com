Tags: Emacs
date: 2013/12/04 14:00:00
title: How to Enable Logging of Chat Sessions in ERC
draft: False


[ERC](http://www.emacswiki.org/emacs/ERC) is an irc client that runs inside emacs. I sometimes use it to ask question or read interesting discussions. 

It is very nice to have the code I am working on and some interesting discussion side by side on the screen.

Sometimes I read something interesting and later want to recall what exactly I read. 

For such cases ERC provide an ability to log chat sessions that the user is participating in. It is off by default, so it must be enabled in the configuration.

I have the following configuration in my _.emacs_, it took me some time to figure how to do it correctly, so I hope this information will help somebody else who is struggling as well:

    :::emacs-lisp
    ;; it is not possible to set erc-log-mode variable directly 
    (erc-log-mode) 
    ;; The directory should be created by user.
    (setq erc-log-channels-directory "~/.erc/logs/")
    (setq erc-generate-log-file-name-function (quote erc-generate-log-file-name-with-date))
    (setq erc-save-buffer-on-part nil)
    (setq erc-save-queries-on-quit nil)
    (setq erc-log-write-after-insert t)
    (setq erc-log-write-after-send t)

There are few tricky thing to consider here. Firstly, the logs directory should exist, if ERC does not find the provided path, it will do nothing.

Secondly, the call to _erc_log_mode_ enables logging. It can be confusing because unlike other configuration options, it is a call to a function. As the documentation says:

>  Erc Log Mode: <br>
>   Non-nil if Erc-Log mode is enabled. <br>
>  See the command &#96;erc-log-mode' for a description of this minor mode. <br>
>   Setting this variable directly does not take effect; <br>
>   either customize it (see the info node &#96;Easy Customization') <br>
>   or call the function &#96;erc-log-mode'. <br>

There are more ERC related customization options available. It is possible to see them with the following emacs sequence:

    :::emacs-lisp
    M-x customize-group RET erc RET

This will display a nice GUI-like editor for those options and also will group them according to functionality. 


