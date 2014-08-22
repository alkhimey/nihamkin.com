---
categories: C++, Ada
date: 2014/05/06 22:00:00
title: Range Constrained Types in C++
draft: True
---

One of the first things a new Ada programmer will learn about Ada is it's type system. A feature I like very much, and is actually very usefull within Ada programs is the ability to create a subtype of a descreete type which has a subrange of the original type's range. For example:

$$code(lang=ada)
subtype Positive is Integer range 1 .. Integer'Last;
$$/code

Being a subtype of _Integer_, _Positive_ is fully compatiable with it and can be used wherever _Integer_ is apllicable. Ada's runtime system however, will guard against assignemts of values lower than 1 and wil dispatch a runtime error whenever this happens.

I decided to try an implement this feature in C++. There is an unofficial Boost library already [adresses](http://www.boost.org/doc/libs/1_48_0/boost/date_time/constrained_value.hpp) addressing this feature. However reading the implementation reveals that _constrained_value_ is not a proper subtype of _valaue_type_. There are examples where instances of the first, can not substitute the other:

$$code(lang=c++)

void f(bounded_int<int, 0, 100>::type x) { ... };

...

bounded_int<int, 0, 100>::type x = 5;
x++; // Compilation error: operator not defined.
f(x); // Compilation error: casting operator not defined.

$$/code

The goals of my implementaion are:
* Proper subtyping of the base type. 
* Smallest possible performance and memory penalty.
* Simple interface.


### How to Use ###

The code itself can be found on [github](). Just grab the file named _subtype_range_constrained.h_.

Here are some usage examples:

$$code(lang=c++)
   
$$/code






== TODO: Rewrite ==
In C++, primitives are weakly typed and assgning _short_ to _int_ is considered normal.  I do not think there is a lot of real value in this feature. For me it was simply a challenging excersice. I wellcom any attempts to review my code. Please write in the comments of add a pull request on github.