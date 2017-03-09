Tags: Ada,  Software Engineering, Source Control
date: 2016/12/31 14:00:00
title: About the Pitfalls of Merge Conflicts
draft: False

I do not consider myself a novice software developer. And yet I still have not exceeded the list of things I can learn "the hard way".

Last month I had chance to learn about the dangers of resolving merge conflicts as well as how important is it to do a proper code review.

We use a "classic" work-flow in my work place (ancient as Greece itself). At the beginning of a development cycle, we open a branch for each feature that will be developed in that cycle. All the branches are based on the same baseline. When all developers are done, we merge the branches one by one, test the final result and it becomes the new baseline of the next development cycle. We have one specific developer whose responsibility is to merge all the features. Sometimes, when the conflict appears to be difficult, the authors of the conflicting parts are also invited to be involved. 

The following code snippets are simplified representations of what happened in our code base.

The base version of a certain file contained the following lines:


    :::ada
    if    Msg_1.Id = 1 then
       -- Do stuff 1
    elsif Msg_1.Id = 2 then
       -- Do stuff 2
    elsif Msg_1.Id = 3 then
       -- Do stuff 3
    end if;


One of the developers added ```Msg_2```:

    :::ada
    procedure Proc_Msg( Msg : Msg_Type ) is
    begin
       if    Msg.Id = 1 then
          -- Do stuff 1
       elsif Msg.Id = 2 then
          -- Do stuff 2
       elsif Msg.Id = 3 then
          -- Do stuff 3
       end if;
    end;
    
    -- ...
    
    Proc_Msg( Msg_1 );
    Proc_Msg( Msg_2 );

In the meantime, another developer was busy implementing a new message ID number:

    :::ada
    
    if    Msg_1.Id = 1 then
       -- Do stuff 1
    elsif Msg_1.Id = 2 then
       -- Do stuff 2
    elsif Msg_1.Id = 3 then
       -- Do stuff 3
    elsif Msg_1.Id = 4 then
       Buffer := Msg_1.Data;
       Buffer_Ready_Toggle := not Buffer_Ready_Toggle;
    end if;

Please believe me that under the constraints of our system, this way of using a toggle is a correct way to send a message to another process:

    :::ada
    if Local_Toggle /= Buffer_Ready_Toggle then
       Local_Toggle := Buffer_Ready_Toggle;
    
       -- Now do stuff with buffer ...
       
    end if;

I was present during the resolution of the conflict. It was late at night, and after some manual editing of the merge result we produced following result:

    :::ada
    procedure Proc_Msg( Msg : Msg_Type ) is
    begin
       if    Msg.Id = 1 then
          -- Do stuff 1
       elsif Msg.Id = 2 then
          -- Do stuff 2
       elsif Msg.Id = 3 then
          -- Do stuff 3
       elsif Msg.Id = 4 then
          Buffer := Msg_1.Data;
          Buffer_Ready_Toggle := not Buffer_Ready_Toggle;
       end if;
    end;
    
    -- ...
    
    Proc_Msg( Msg_1 );
    Proc_Msg( Msg_2 );

Unfortunately, this code contains two problems. It was pure luck that we noticed them. Compilation error in another part of the file caused us to recheck the whole file.

Can you find the problems yourself?


.

.

.

.

.

.

.

.

.

.

.

.

The first mistake is that the line ```Buffer := Msg_1.Data``` should actually be ```Buffer := Msg.Data```.

The second problem is a bug that will happen if both messages have ```Id``` of ```4```. In this case, the toggle changes will cancel each other.

The disturbing part of this story is that these problems could not have been detected by tests. Each developer's tests, even when run on the merged version would have passed successfully. 


## Conclusion

There are several lessons I learned from this incident.

* Our work-flow has problems. We already in the process of adopting [another work flow](http://nvie.com/posts/a-successful-git-branching-model/) that would reduce the number of conflicts and shift the responsibility of resolving them to the developers that actually participated in the relevant code.
* There should be more coordination between developers. Stand up meetings are good for this purpose, but additionally management should be involved for inter team/department coordination.
* Code reviews are important, especially after merge. There are bugs that are hard to catch using tests alone.
* Doing work late at night, when you are tired, is counterproductive. No matter how high the pressure is to deliver, the consequences will cost more that what you benefit. I have been bitten by this numerous times and still continue making this mistake.
