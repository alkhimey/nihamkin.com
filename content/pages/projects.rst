Projects
########

:tags: projects
:slug: projects
:summary: This page contains some projects I did as a hobby (not part of my
          professional work) or as part of university courses.
:url: projects
:save_as: projects/index.html

This page is dedicated to several of my hobbyist projects.

Since I am a software engineer, most of these projects are software related.

Additional projects not mentioned here can be found on my `Github page`_.

.. _Github page: https://github.com/alkhimey/


Linux Kernel Modules with Ada
==============================

- **Description:** A framework for writing Linux kernel modules using Ada
  programming language.
- **Year:** 2016-2018
- **Source:** https://github.com/alkhimey/Ada_Kernel_Module_Toolkit

My attempt to develop **Linux Kernel Modules** using the **Ada** programming
language.

This is a proof of concept that I am still working on it. My goal is to
demonstrate the usefulness of Ada's strong typing system for this kind of
application.

Follow my blog to see how I progress.

CelloWar
==================

- **Description:** An android multiplayer game created during
  Global Game Jam 2018.
- **Year:** 2017
- **Source:** https://github.com/alex-ilgayev/CelloWar
- **GGJ Page:** https://globalgamejam.org/2018/games/cellowar
- **Partners:** Alex Ilgayev

This is a turn based, two-player game for Android. It was created during
Global Game Jam 2018.

For the client part, we did not use anything beyond what **Android's NDK**
provided. All the graphics are drawn on a :code:`Canvas`.

For the game server, we used Tomcat and implemented our own
queueing protocol.

.. image:: /files/project_images/CelloWar.PNG
   :width: 400 px
   :alt: Screenshot of the CelloWar game.


Let There be Light
==================

- **Description:** A game created with Construct 2 during Global Game Jam 2017.
- **Year:** 2018
- **Source:** https://github.com/alkhimey/Wave/
- **Demo:** http://ggj17.s3-website.eu-central-1.amazonaws.com/
- **GGJ Page:** http://globalgamejam.org/2017/games/let-there-be-light
- **Partners:** Andrey Smirnov (art), Yuval Neumann (programming),
  Ben Saban (design).

This game was created during Global Game Jam 2017. We used
**Construct 2** as the game engine.

Moving the mouse up and down will alter the path that the glowing moon is
following. The player must guide the moon to consume the glowing orbs, otherwise
it will fade and die.

.. image:: /files/project_images/screenshot_from_2017-01-21_21-49-28.png
   :width: 400 px
   :alt: Screenshot of the "Let There be Light" game

Ada Curve
==========

- **Description:** Drawing splines with OpenGL bindings for Ada.
- **Year:** 2016-2017
- **Source:** https://github.com/alkhimey/Ada_Curve

A little demonstration of different spline constructing algorithms.
The included algorithms are: De Castelijau (Bezier curves),
De Boor (B Splines), Catmull Rom and
Lagrange Interpolation (both on equidistant nodes and on Chavyshev nodes).

**Ada** programming language is used and the graphics are done with **OpenGL**
bindings to Ada.

.. image:: /files/project_images/ada_curve2.gif
   :width: 400 px
   :alt: Knockyo is a word play of Knock and Tokyo. Unfortunately our hosts, the Murata corporation is HQ in Osaka.

Knockyo
=======

- **Description:** A toy built with "Arduino" and "Murata" sensors.
- **Year:** 2015
- **Source:**  `Download </files/project_images/knockyo.zip>`_
- **Partners:** Evyatar Tamir, Daniel Zhitomirskii, Nadav Weiss

This is a toy that was developed during a hackathon sponsored by “Murata”,
a Japanese hardware manufacturer.

We used an **Arduino** with sensors produced by Murata to create a rhythmic
toy.

After the toy plays a sound pattern, the player has to tap on the mini drum in
a way that reproduces the same pattern. The accuracy of the reproduction
determines the score which is displayed on a neopixel ring.
A light sensor is used for hand gesture input commands such as starting a
game or recording a custom sound patterns.
Murata's shock sensor is concealed  in the drum.

Remeber: *Knockyo is the best Game in Tokyo!*

.. image:: /files/project_images/knockyo.jpg
   :width: 400 px
   :alt: Knockyo is the best toy in Tokyo!


Iava
====

- **Description:** Developing a custom language called Iava
- **Year:** 2012
- **Source:** `Main project </files/project_images/IAVA.tar.gz>`_, `Eclipse plugin </files/project_images/IAVA_Plugin.tar.gz>`_
- **Partners:** Hadar Sivan, Alex Ilgayev, Alex Prutkov, Shai Barad,
  Pavel Kharakh, Bar Weiner, Arnon Yogev

This was done during the "yearly project in software engineering" at the
Technion.

In this project we developed a custom language that has similar but simpler
syntax as Java. We developed the "whole package": compiler, standard library,
a plugin for **Eclipse** and a manual.

The focus of this project was not the technology but rather practicing sound
software engineering techniques.

We used **Trac** to manage our work and **svn** for source control. Tracs's
wiki was used for internal documentation. We also wrote formal design
documents.

As per requirements of our professor, we organized our work into several
iterations, with a demo and review of the system at the end of each one.

Big effort was put into testing. We did automatic tests at every level and
for every component of our system.

.. image:: /files/project_images/IAVA_High_Level_Design.png
   :width: 400 px
   :alt: High level design diagram of our IAVA building system


3D Model Viewer
===============

- **Description:** 3D model viewer developed as part of computer graphics
  course.
- **Year:** 2011
- **Source:** https://app.assembla.com/spaces/cg_2011/subversion/source/HEAD/trunk/skeleton_2008
- **Partners:** Alex Ilgayev

This is a 3D model viewer with many features that demonstrate what we learned
during our computer graphics course at the Technion.

The highlight of our viewer was the ability to render images in cell shading
style (aka *toon shading*). We tuned this shader to produce images that look
like manga drawings.

.. image:: /files/project_images/170600_1723940292197_1301573_o.jpg
   :width: 400 px
   :alt: Demonstration of cell shader we developed

.. image:: /files/project_images/171100_1723940412200_5928512_o.jpg
   :width: 400 px
   :alt: Another demonstration of cell shader we developed

.. Spartanization Plug-in for Ecplise
.. ==================================
..
.. - **Description:** An Eclipse pluging that can refactor you code to minimize
.. token count.
.. - **Year:** 2013
.. - **Source:** https://bitbucket.org/alkhimey/spartanrefactoring
.. - **Blog post:** TBD
..
.. This is a project I
..
.. image:: /files/spartanization_refactoring.png
..   :width: 400 px
..   :alt: Refactoring ternary expressions


Tower Defense with Kinect
=========================
- **Description:** A game that uses player gestures to attack advancing
  enemies.
- **Year:** TBD
- **Partners:** Alex Ilgayev

Back in the day when Kinect was a novelty poineering cheap real time 3d scanning,
we recieved a 
