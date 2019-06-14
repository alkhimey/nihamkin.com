Building Text to Speech Service Based on Festival
##################################################

:date: 2019/06/14 13:00:00
:tags: Javascript, TTS, T2S, Personal Assistant, Festival, Scheme
:authors: Artium Nihamkin

.. role:: javascript(code)
   :language: javascript

.. role:: scheme(code)
   :language: scheme

.. raw:: html

   <audio controls="controls">
         <source src="/files/festival/intro.wav" type="audio/wav">
         Your browser does not support the <code>audio</code> element.
   </audio>

Last week I participated in Hackathon where we built a demo of domain specific
personal assistant. One of the components of such system is the text to speech
component.

In this post I will explain how I installed Festival speech synthesis system,
how I managed to alter the system to fit our specific domain requirements and
how I wrapped it with a Node.js server.

Festival
========

.. image:: /files/festival/festival.jpg
    :alt: Festival logo
    :align: center

Festival is a speech synthesis system (also called speech to text, STT or S2T).
It has two maintainers and therefore two websites (which might be confusing a
bit):

1. `The Center of Speech Technology Research - The University of Edinburgh <http://www.cstr.ed.ac.uk/projects/festival/>`_
2. `Carnegie Mellon University Speech Group <http://www.festvox.org/festival/index.html>`_

Another thing one should know about festival is the difference between Festival
and festvox. Festival is the speech synthesis system itself. On the other hand,
festvox is the name of a set of tools used to create voices for Festival.
Sometimes the whole project (Festival + festvox) are called by the festvox
name, so do not be confused.

Basic Installation on Linux
============================

Although Festival can be installed on some distributions from a package
manager like `apt`, we will build it from source.

I tested these instructions on Ubuntu 18.04 and 16.04.

At the time of writing this blog post, the latest version of Festival is
**2.5**.

Got to http://www.festvox.org/packed/festival/2.5/ and download **all** five
`tar.gz` archives that appear there.

Additionally, got to the `voices` subdirectory and
download:

1. *festvox_kallpc16k.tar.gz*
2. *festvox_rablpc16k.tar.gz*
3. *festvox_cmu_us_awb_cg.tar.gz*
4. *festvox_cmu_us_awb_cg.tar.gz*

You can download additional voices, but these are basic.

Put all the files in a single directory.

Now extract all the archive using the following command:

.. code-block:: shell

    for a in `\ls -1 *.tar.gz`; do gzip -dc $a | tar xf -; done

The directory structure will now look like this:

.. code-block:: shell

    ~/Festival$ ls -l
    total 126804
    drwxr-xr-x  9 artium artium     4096 May 26  2018 festival
    -rw-rw-r--  1 artium artium   789013 Jun  8 13:49 festival-2.5.0-release.tar.gz
    -rw-rw-r--  1 artium artium  1925748 Jun  8 13:49 festlex_CMU.tar.gz
    -rw-rw-r--  1 artium artium  1474233 Jun  8 13:49 festlex_OALD.tar.gz
    -rw-rw-r--  1 artium artium   243656 Jun  8 13:49 festlex_POSLEX.tar.gz
    -rw-rw-r--  1 artium artium 52653464 Jun  8 23:56 festvox_cmu_us_awb_cg.tar.gz
    -rw-rw-r--  1 artium artium 61933982 Jun  8 23:56 festvox_cmu_us_rms_cg.tar.gz
    -rw-rw-r--  1 artium artium  4103663 Jun  8 13:49 festvox_kallpc16k.tar.gz
    -rw-rw-r--  1 artium artium  5369131 Jun  8 13:49 festvox_rablpc16k.tar.gz
    drwxr-xr-x 23 artium artium     4096 Jun  8 23:50 speech_tools
    -rw-rw-r--  1 artium artium  1328624 Jun  8 13:49 speech_tools-2.5.0-release.tar.gz

Notice that only two new directories were created. This is because all archives
share the same directory structure and thus when extracting files, they go into
the correct place inside *festival* automatically.

Now make sure *ncurses5* is installed:

.. code-block:: shell

    sudo apt install libncurses5

Now go inside the :code:`speech_tools` directory and run:

.. code-block:: shell

    ~/Festival/speech_tools$ ./configure

Followed by:

.. code-block:: shell

    ~/Festival/speech_tools$ make

Just for reference, here is the compiler setup I used:

.. code-block:: shell

    $ gcc -v
    Using built-in specs.
    COLLECT_GCC=gcc
    COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/7/lto-wrapper
    OFFLOAD_TARGET_NAMES=nvptx-none
    OFFLOAD_TARGET_DEFAULT=1
    Target: x86_64-linux-gnu
    Configured with: ../src/configure -v --with-pkgversion='Ubuntu 7.4.0-1ubuntu1~18.04' --with-bugurl=file:///usr/share/doc/gcc-7/README.Bugs --enable-languages=c,ada,c++,go,brig,d,fortran,objc,obj-c++ --prefix=/usr --with-gcc-major-version-only --program-suffix=-7 --program-prefix=x86_64-linux-gnu- --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify --enable-libmpx --enable-plugin --enable-default-pie --with-system-zlib --with-target-system-zlib --enable-objc-gc=auto --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic --enable-offload-targets=nvptx-none --without-cuda-driver --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
    Thread model: posix
    gcc version 7.4.0 (Ubuntu 7.4.0-1ubuntu1~18.04)

After building :code:`speech_tools` it is possible to build *Festival* itself.
There is no need to put :code:`speech_tools/bin` in the :code:`PATH` for this
purpose. Just make sure you follow the directory hierarchy I showed earlier.

Run:

.. code-block:: shell

    ~/Festival/festival$ ./configure

Followed by:

.. code-block:: shell

    ~/Festival/festival$ make

After building is finished, if you run :code:`make test` some tests will fail.
Some because the copyright message of the latests version was changed, some
because of missing voices and others because reasons I do not understand. For
reference, `here </files/festival/test_results.txt>`_ is the output I got.

These failing tests are not a no-go situation. We can use festival with no
problem. But first lets add it into :code:`PATH` (change the path of *bin* to
reflect your location):

.. code-block:: shell

    export PATH=$PATH:/home/artium/Festival/festival/bin

Now we can run :code:`festival` which will start the interpreter.

Let's test it. Notice that to exit the interpreter you need to press
:code:`Ctrl+ D`.

.. code-block:: scheme

    festival> (SayText "hello")
    #<Utterance 0x7f25e1a58690>
    festival> Linux: can't open /dev/dsp

You probably does not hear anything and get this :code:`can't open /dev/dsp`
message. The reason is that Ubuntu does not have the `OSS
<https://en.wikipedia.org/wiki/Open_Sound_System>`_ modules by default. There
are two ways to solve this:

1. Install `osspd` (:code:`sudpo apt-get install osspd`)

2. Tell festival to use `ALSA <https://en.wikipedia.org/wiki/Advanced_Linux_Sound_Architecture>`_ for sound output.

The second solution is highly recommended. You need to open
:code:`~/.festivalrc` file and add these lines:

.. code-block:: scheme

    (Parameter.set 'Audio_Command "aplay -q -c 1 -t raw -f s16 -r $SR $FILE")
    (Parameter.set 'Audio_Method 'Audio_Command)

Now running the :code:`SayText` command should output the speech through the
speakers or headphones. Make sure you have output device attached to the
computer.


Saving to File
==============

To save a *WAV* file, many online tutorials recommend the `text2wave` program
that was build along with festival. For me, running it gives a segfault, so
here is an alternative way using festival itself.

.. code-block:: scheme

    (utt.save.wave (SayText "This is an example text") "test.wav" 'riff)

This method is ok for testing but the problem is that :code:`SayText` will
actually say the text and only then the file will be saved.

Here is a  better way to accomplish the same task:

.. code-block:: scheme

    (set! utt1 (Utterance Text "This is an example text"))
    (utt.synth utt1)
    (utt.save.wave utt1 "test2.wav" 'riff)

Modifying the System
====================

One of the requirements of our domain specific personal assistant is that
numbers should be pronounces digit by digit. For example the number "300.25"
should be pronounced "three zero zero two five" and not "three hundred dot
twenty five"

Using `SABLE <https://www.cs.cmu.edu/~awb/festival_demos/sable.html>`_ markup it
is possible to use the :code:`<SAYAS MODE="literal">` tag. But I wanted this to
work with text mode not sable mode. I did not find a built-in way to tell
festival to use literal pronunciation when synthesizing an utterance. So I had
to implement it myself.

I followed the `tutorial here <http://festvox.org/festtut/notes/festtut_toc.html>`_
and used the `example on the bottom of chapter 5 <http://festvox.org/festtut/notes/festtut_5.html#SEC37>`_
to figure out what change should I make to festival.

The result is the following code that should be executed after setting a voice.
I will not get into details of festival's architecture and Scheme syntax here.

.. code-block:: scheme

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;                                                                 ;;
    ;; Custom definition required for our personal assistant project   ;;
    ;; Required because domain specific requirement.                   ;;
    ;;                                                                 ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (set! previous_token_to_words token_to_words)

    (define (token_to_words token name)
        "In case of a real number, will pronounce the digits one by one excluding the decimal point"
        (cond 
            (
                (string-matches name "[0-9]+\\.[0-9]+" )
                (mapcar num-to-literal (filter is_digit (symbolexplode name))) ; ;; (utf8explode utf8string) ?
            ) 
            (
                t 
                (previous_token_to_words token name)
            )
        )
    )

    (define (num-to-literal num)
        "Returns the literal word of numeric characters"
        (car
            (cdr 
                (assoc 
                    (parse-number num)
                    '(
                        (1 one) (2 two) (3 three)
                        (4 four) (5 five) (6 six)
                        (7 seven) (8 eight) (9 nine) 
                        (0 zero)
                    )
                )
            )
        )
    )

    (define (filter pred lst)
        "A new list is returned containing only the item matching the predicate"
        (reverse (filter-help pred lst '()))
    )

    (define (filter-help pred lst res)
        (cond 
            (
                (null? lst) res
            )
            (
                (pred (car lst)) 
                (filter-help pred (cdr lst)  (cons (car lst) res))
            )    
            (
                t 
                (filter-help pred (cdr lst)  res)
            )        
        )
    )


    (define (is_digit input)
        "Is input a single digit number?"
        (string-matches input "[0-9]")
    )


Here is an example of synthesis of the phrase "The radio frequency is 432.78":

.. raw:: html

   <audio controls="controls">
         <source src="/files/festival/numbers.wav" type="audio/wav">
         Your browser does not support the <code>audio</code> element.
   </audio>

Web Service
============

For the web service I used Node.js with Express.

My strategy was:

1. Receive the a text through a POST request.
2. Generate a scheme code that would synthesize this text into speech and save
   the speech into WAV file.
3. Save the scheme code in a temporary script file.
4. Invoke a festival process in batch mode and give it the scheme script as a
   parameter.
5. When finished synthesis, use Express's `res.download <https://expressjs.com/en/api.html#res.download>`_
   API call to send a response with the WAV file.


Here is an example of :code:`festival.js` helper module:

.. code-block:: Javascript

    const path = require("path")

    const prod_dir = "/tmp/"

    exports.get_sys_err_path = function (cb) {
        cb(prod_dir + "static/error_in_tts.wav")
    }

    exports.get_sound_file_path = function (text, cb) {

        var timestamp = Date.now().toString();

        var fs = require("fs");

        var voice = "cmu_us_fem_cg"
        
        // Important: must call vocie BEFORE custom require
        var data = `(voice_${voice})` 
        // Notice: path delimiter might not be good for Windows
        data += `(require "${path.resolve(".")}/custom")`
        data += `(set! utt1 (Utterance Text "${text}"))`
        data += '(utt.synth utt1)'
        data += `(utt.save.wave utt1 "${timestamp}.wav" 'riff)`
        
        var scriptFullPath = prod_dir + timestamp + '.scm'
        fs.writeFile(scriptFullPath, data, (err) => {
            if (err) console.log(err);
            console.log("Created file: " + scriptFullPath);
        });

        // Precondition: festival is in $PATH
        const
            { spawn } = require('child_process'),
            ls = spawn('festival', ['--batch', timestamp + '.scm'], { cwd: prod_dir });

        ls.stdout.on('data', data => {
            console.log(`stdout: ${data}`);
        });

        ls.stderr.on('data', data => {
            console.log(`stderr: ${data}`);
        });

        ls.on('close', code => {
            console.log(`child process exited with code ${code}`);

            if (code != 0) {
                Festival.get_sys_err_path(function(filepath) {
                    cb(filepath)
                })
            } else {
                cb(prod_dir + timestamp + '.wav')
            }

        });
    }


The complete code of the service can be found in `this repository <https://github.com/constrained-pa-hackathon/response-generation-component>`_.


This process is not very efficient (and the implementation **is not
secure**.  Can you spot why?)

I measured the time to receive a response from the server for the most simplest
text: *I*. it was 1.11 seconds.

Here are some examples of the average response times of different phrases I
measured:


.. table::

    ============================== ====
    **Phrase**                     **Time**
    ------------------------------ ----
    I                              1.1s
    Test                           1.2s
    This is a test                 1.4s
    This is a longer test          1.8s
    The frequency was set to 30000 2.4s
    ============================== ====

And that is just the "text to speech" part. When integrated with all the other
steps of the personal assistant pipeline, we got a response latency that was
hardly acceptable. A user should "feel" the interaction with the assistant thus
the program can not "stop" and think about a reply every time a simple question
is asked. It was good enough for a Hackathon and a demonstration of a proof of
concept, so we did not attempt to optimize.

Anyway, here are some ideas of why it takes that much time (no particular
order):

1. There are several reads and writes of files for each request.
2. Each request causes a full Festival process to be forked. Initialization of
   the process and Festival itself takes time.
3. Network latency.
4. Downloading the WAV file (~100KB) takes time (bandwidth).
5. Festival itself is slow in synthesizing the WAV files.

We could use festival's `built-in server capability
<http://www.festvox.org/docs/manual-2.4.0/festival_28.html#Server_002fclient-API>`_
to overcome the disk writes and process forking issues.

As for latency, bandwidth and general slowness of Festival, the best course of
action in my opinion is to use `Flite <http://www.festvox.org/flite/>`_ instead of Festival and do the synthesis
locally on the client itself.
