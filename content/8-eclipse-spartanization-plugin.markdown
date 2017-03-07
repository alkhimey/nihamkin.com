Tags: Eclipse, Software Engineering, Spartanization Plugin
date: 2013/03/09 02:00:00
title: Spartanization Plug-In For Eclipse
draft: False

I would like to share an Eclipse plug-in that I have recently developed. It possible to install it from the following  update site: [http://update.nihamkin.com/spartan/](http://update.nihamkin.com/spartan/). 

<p align="center">
<script type="text/javascript">
       url_site = 'http://marketplace.eclipse.org/node/722342';
</script>
<script src="http://marketplace.eclipse.org/sites/all/modules/custom/eclipse_drigg_external/js/button.js" type="text/javascript"></script>
<br>
<a href="http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=722342" title="Drag and drop into a running Eclipse Indigo workspace to install Spartan Refactoring">
  <img src="http://marketplace.eclipse.org/sites/all/modules/custom/marketplace/images/installbutton.png"/>
</a>
</p>

If you are not familiar with "spartan programming", you can read about it on [this](http://www.codinghorror.com/blog/2008/07/spartan-programming.html) Jeff Atwood's post or [here](http://ssdl-wiki.cs.technion.ac.il/wiki/index.php/Spartan_programming) for more detailed description.



![Refactoring Example](/files/spartanization_refactoring.png)

My plug-in makes it possible to perform some of the spartanizations automatically. The following refactorings will be added into the Eclipse's refactor menu:

1. **Convert Conditional to Ternary -** when possible, this refactoring will convert short if-else statements into ternary statements thus reducing the number of lines.

2. **Eliminate Redundant Equalities -** will remove *true* or *false* from expressions which explicitly compare a Boolean with *true* or with *false*.

3. **Shortest Conditional Branch First -** will switch between *if* and *else* branches of *if-else* statements to make sure that the shortest branch is always first.

There are two ways to apply the refactoring; either on the selected text, or if no text is selected, on a whole project (depends on the file active in the editor).

The plug in is not polished yet. Some edge cases should be included. For example it is desirable that "Eliminate Redundant Equality" will also eliminate comparisons to *null* or that all refactoring that add parentheses will add them only when needed (currently "*a != b*" will be refactored into "*!(a)*" ).

Until I find time to fix these, feel free to take a look at the [source code](https://bitbucket.org/alkhimey/spartanrefactoring) and maybe fork it and adjust it for your own needs. You can use it as an example of how to work with the refactoring framework of Eclipse.

