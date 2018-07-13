Experimenting with Bats
#######################

:date: 2018/08/07 23:00:00
:tags: bats, linux, kernel, testing, bash
:authors: Artium Nihamkin
:category: Ada Linux Kernel Module

.. role:: ada(code)
   :language: ada

I had some progress with my `Ada Kernel Module Framework <https://github.com/alkhimey/Ada_Kernel_Module_Framework>`_.
Currently, what I have is a demo of a kernel module opening a character
device.

While finishing that part, I realized that a good automatic testing strategy
needs to be developed.
At current stage, I do not even know which Ada features are supported. The
framework is so fragile that any change can cause regression problems.

Therfore I decided to explore testing with Bats - `Bash Automated Testing System <https://github.com/bats-core/bats-core>`_.

Strategy
========

How does one test a **famework**?

My approach is to write a set of kernel modules that would demonstrate the
different Ada features and Linux kernel API bindings that are supported by the
framework.

Each such module is written in a way that would allow executing the following
procedure:

1. Build the module.
2. Insert it into the Kernel.
3. Observe output through reading the message log.
4. Operate on the module using a special user space program or a shell script.
5. Cleanup

Of course, everything have to be automated to allow efficient regression
testing.


Bats
====

Bats is a `TAP <https://testanything.org/>`_-compliant testing framework for Bash. It provides a simple way
to verify that the UNIX programs behave as expected.

To install Bats on Ubuntu, it is required to add a :code:`ppa` repository
(as of 17.10):

.. code-block:: shell

    $ sudo add-apt-repository --yes ppa:duggan/bats
    $ sudo apt-get update
    $ sudo apt-get --yes install bats

It seems that there is an active and helpful community surrounding this tool
and that is an important advantage for using it.

Basics
------

Bats tests have the form form of shell scripts with :code:`bats` extension
and :code:`#!/usr/bin/env bats` shebag.

Each bats file is broken down into several test steps that look like:

.. code-block:: shell

    @test "Build module" {
      run make
      [ "$status" -eq 0 ]
    }


Assertions
----------

One of the drawbacks of Bats is the fact that there is no proper, convinient
way to make assertions. Fortunately, there is a third party script that makes
it possible.

I found it in the `following repostiroy <https://github.com/mbland/go-script-bash/tree/master/lib/bats>`_.

In case of failure, the assertion function will display the expected and actual
result.

To load the function, one have to use bat's :code:`load` command. I decided to
organize stuff in a way that there is a single :code:`environment` script that
loads all the other dependencies (currently only one):

.. code-block:: shell

    load ../../testing-utils/environment

.. code-block:: shell

    #! /bin/bash
    #
    # Environment script for Bats tests
    #
    #

    # Assertion helpers were taken from
    #    https://github.com/mbland/go-script-bash/tree/master/lib/bats
    . "${BASH_SOURCE%/*}/assertions"


It is then possible to use :code:`assert_success`, :code:`assert_equal` and
similar commands:

.. code-block:: shell

    @test "Build module" {
       make
       assert_success
    }

For other assert commands, `the source code of the script <https://github.com/mbland/go-script-bash/blob/master/lib/bats/assertions>`_
is very clear and well documented. Worth opening it and reading.


Steps
-----

The first step would be to perform some precondition tests. These do not
provide more safety because if one of these fails, then some other consecutive
test is ought to fail as well. The reason to have these "sanity" tests is
to make it easier to debug the **reason** of failure.

Currently I only check if there is no loaded module with the same name as the
one about to be built.

.. code-block:: shell

    MODULE_NAME='hello'

    lsmod_check() {
       lsmod | grep "$1"
    }

    @test "verify there is no hello module already loaded" {
       run lsmod_check $MODULE_NAME
       assert_failure
    }

Next, the module is built and loaded:

.. code-block:: shell

    @test "build module" {
        make
        assert_success
    }

    @test "verify creation of loadable module with the correct name" {
        run ls_check $MODULE_FILE
        assert_success
    }

    @test "insert module" {
        sudo insmod hello.ko
    }

Now, we want to assert that the module operated correctly during it's
insertion.

In the module's code, there are strategically placed :code:`printk` calls which
print into the kernel log:

.. code-block:: c

    int init_module(void)
    {
        printk(KERN_ERR "Init module.\n");

        printk(KERN_ERR "Hello Ada.\n");
        adakernelmoduleinit();
        ada_foo();
        printk(KERN_ERR "%s\n", "After Ada");

        return 0;
    }

In Ada code, :code:`Kernel_IO` wrapper can be used:

.. code-block:: Ada

    Linux.Kernel_IO.Put_Line ("Creating device...");
    Device := Linux.Device.Device_Create(
        Class       => Class,
        Parent      => Linux.Device.NONE_DEVICE,
        Devt        => Linux.Char_Device.Make_Dev(Major, 13),
        Driver_Data => LT.Lazy_Pointer_Type (System.Null_Address),
        Name        => "artiumdevice");
    Linux.Kernel_IO.Put_Line ("Created device, check /dev");

The log can be read with the :code:`dmesg` command. It's output is parsed
and used for validation:

.. code-block:: shell

    @test "check module init and entry into the ada part" {
        result="$(sudo dmesg -t | tail -17 | head -1)"
        assert_equal 'Init module.' "$result"

        result="$(sudo dmesg -t | tail -16 | head -1)"
        assert_equal 'Hello Ada.' "$result"
    }

Finally, it is important to clean everything and bring it back to original
state. This is not 100% possible since the module itself could have made some
unpredictable changes to the Kernel.

.. code-block:: shell

    @test "remove module" {
        sudo rmmod hello.ko
    }

    @test "clean files" {
    make clean
    }


Running
--------

Here is some success example:

.. code-block:: shell

    $ bats test.bats
    ✓ verify there is no hello module already loaded
    ✓ build module
    ✓ verify creation of loadable module with the correct name
    ✓ insert module
    ✓ check module init and entry into the ada part
    ✓ remove module
    ✓ clean files

    7 tests, 0 failures


And here is an example where I messed the module a little bit:

.. code-block:: shell

    $ bats test.bats
    ✓ verify there is no hello module already loaded
    ✓ build module
    ✓ verify creation of loadable module with the correct name
    ✓ insert module
    ✗ check module init and entry into the ada part
    (in test file test.bats, line 47)
        `assert_equal 'Init module.' "$result"' failed
    Actual value not equal to expected value:
        expected: 'Init module.'
        actual:   'xyz'
    ✓ remove module
    ✓ clean files

    7 tests, 1 failure



Whats Next
----------

One thing I did not demonstrate yet is how to test module's "file" interface.

My plan to do this is by implementing a helper user space program. This program
will call the file operations and output the results. A bats script will
drive this program.

For simple operations like :code:`read` and :code:`write`, bash commands could
be used directly.

I will probably write more about this in some future blog post.
