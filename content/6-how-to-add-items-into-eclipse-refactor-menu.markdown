Tags: Eclipse, Plug-In, JDT
date: 2013/02/16 17:00:00
title: How to Add Items Into Eclipse's Refactor Menu
draft: false

Recently, I was writing a plug-in that performs some refactoring (of which I will write in a separate post). 

Writing the refactoring was not too complicated, but figuring out how add the menu items correctly into the Refactor menu took a lot of time.

I tried to figure this from the documentation and examples that I dug from google (some of which were incorrect), and finally *paulweb515* from #elicpse-dev channel explained me how it should be done. 
 
Here is the correct plugin.xml snippet:

$$code(lang=xml)


<?xml version="1.0" encoding="UTF-8"?>
<?eclipse version="3.2"?>
<plugin>

<extension
         point="org.eclipse.ui.actionSets">
      <actionSet
            description="Spartan Refactoring Actions"
            id="il.ac.technion.cs.ssdl.spartan.refactoring.actionSet"
            label="Spartanization"
            visible="true">
 		<menu
               label="Refactor"
               path="edit"
               id="org.eclipse.jdt.ui.refactoring.menu">
            <separator name="undoRedoGroup"/>
            <separator name="reorgGroup"/>
            <separator name="codingGroup"/>
            <separator name="reorgGroup2"/>
            <separator name="typeGroup"/>
            <separator name="typeGroup2"/>
            <separator name="codingGroup2"/>
            <separator name="typeGroup3"/>
            <separator name="spartanGroup"/>
            <separator name="scriptGroup"/>
		</menu>
	  	<menu
               id="il.ac.technion.cs.ssdl.spartan.refactoring.menu"
               label="Spartanization"
               path="org.eclipse.jdt.ui.refactoring.menu/spartanGroup">
            <separator name="group" />    
		</menu>

         <action
               class="il.ac.technion.cs.ssdl.spartan.refactoring.ShortestBranchAction"
               enablesFor="*"
               id="il.ac.technion.cs.ssdl.spartan.refactoring.actions.ShortestBranchAction"
               label="Shortest Conditional Branch First..."  
               menubarPath="org.eclipse.jdt.ui.refactoring.menu/il.ac.technion.cs.ssdl.spartan.refactoring.menu/group"
               style="push">
         </action>        
		 
		<!-- More actions -->
      
	  </actionSet>
   </extension>
</plugin>

$$/code

The Refactor *menu* tag is a copy of the original "Refactor" menu definition from *org.eclipse.jdt.ui*. It is important to copy all the separator definitions. For my plug-in, I have also added a new separator called *spartanGroup*.

The path for the Refactor menu is **org.eclipse.jdt.ui.refactoring.menu**.

It is possible to figure this information by looking at *plugin.xml* of the *org.eclipse.jdt.ui* plug-in. You can find it online (for example [here](http://grepcode.com/file_/repository.grepcode.com/java/eclipse.org/3.6.1/org.eclipse.jdt/ui/3.6.1/plugin.xml/?v=source)) or you can import the source code of your eclipse build following these steps:

1. File -> Import
2. Select *Plug-ins and Fragments* and click next.
3. In the "*Import From*" section choose "*The active target platform*". 
4. In the "*Import As*" section choose "*Project with source folders*"
5. In the next screen, locate your plug-in (*org.eclipse.jdt.ui*) and add it.
6. Click finish and the source code of the plug-in will be imported into your workspace.


