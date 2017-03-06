---
categories: Ada, C++, Math 
date: 2016/06/12 02:00:00
title: Fixed Point Types and BAMs
draft: True
---

Floating point is the most widely used representation of real numbers. It is so common that some programmers synonimize **real** with **float**, unaware that there are other ways of reperesenting real numbers on a computer.

One such representation is the **fixed point** representation.


## What is a "Representaion"

Representation is a translation between some state of a unit of a memory to a numeric value.

For example, it is natural to represent unsigned integers as a seriese of bits, each bit having a weight $$latex 2^{0}, latex 2^{1}, latex 2^{2} $ etc. The numeric value is the weighted sum of the bits.

When approaching to signed integer representation the picture is not as straighforward. The common way is two's complement but one can also use one's complement representation as well as using the leading bit as sign bit and treating the rest of the sequense as unsigned integer.




## Fixed Point

Fixed point representation is similar to the familiar integer represntation.

An unsigned 16 bit integer is represented in the memory as a seriese of 16 bits. To decode it's value, each bit has to be multiplied by  $$latex 2^i $ where  $$latex i $ is the index of the bit (starting from 0).


Changing  $$latex 2^i $ to  $$latex 2^{i-k} $ allows representing numbers which are smaller than 1.


## Example
Let's change  $$latex 2^i $ to  $$latex 2^{i-2} $, which means that the value of the least significant bit is $$latex 2^{-2} $ and the next bit is $$latex 2^{i-1} $ and so on.


Using this representation, we are able to represent numbers 

## Facts


Some facts about this representation:

* This is exatly like multipling all the numbers in the integer range by a constant. This operation is called **scaling**. Developing this idea further, it is possible to scale by any number like 1/3, 5 or 12/7.
* There is a tradeoff between range and precision. Scaling by a number greater than 1 extends the range but reduces precision.
* Sometimes, the term **LSB** (least siginificant bit) is used to describe to the scaling factor.
* Scaling by a power of 2 can be viewed as moving around the binary point. Scale factor is greater than 1 will move the binary point to the right, scaling by a factor lesser than 1 will move the binary point to the left.
* Integer addition and substration that the processor performs on the memory stored values works as-is. No need to correct the results.
* Multiplication and division do not work as-is. After multiplying/dividing the memory stored values, additional multiplication by the scaling factor needs to done.
* It is possible to do **shifting** of the range as well by adding or substracting a constant. 

## More Examples



## Implementation

Some langages like Ada have sophisticated typing systems that have fixed point types build in.

In Ada it is possible to declare type and specify its's [delta](http://en.wikibooks.org/wiki/Ada_Programming/Keywords/delta) - the difference between two consequtive values of this type.

It is also possible to specify the range of the type.

For example, instances of the following type T:

$$code(lang=ada)

type T is delta 0.5 range -1 .. 2; 

$$/code

can store the following  values: -1, -0.5, 0, 0.5, 1, 1.5, 2. 

The Ada compiler will do the following:

* Choose the best underlying hardware data type.
* Deduce the scaling and shifting factors or issue compilation error if these factors are impossible.
* Produce runtime code to do the correction for operations like multiplication.
* Produce runtime code for range checking.


### Decimal

Some langages are more restrictive, allowing only specification of the abolute **decimal** precision.

Python's  [decimal](https://docs.python.org/2/library/decimal.html) package and SQL's [decimal](http://msdn.microsoft.com/en-us/library/ms187746.aspx) type are two examples of such implementations.

### C/C++ Implementation

C/C++ does not have these type build in. The fixed point representation is not well suited for non strongly typed langages. Different fixed point types have different representations for the dame values. This makes them non compatiable, forcing the type system to be at least partially strong.

Nevertheless, it is till possible to implement fixed point types of our own.


## Usage

Fixed point types widely used in embeded systems as floating point operations are relatively expensive and not always available in hardware.

Also, floating point representations are not simple. Different systems use different standarts.
Fixed point types are simple and straighforward and much easier to describe in an [ICD](http://en.wikipedia.org/wiki/Interface_control_document) document.

Another situation where one might prefer to use fixed point representation is when the data is bounded and have fixed precision. This is very common with physical quantities. If we know that an upper limit on the speed of an airplane is 4000 knots and the pitot tube tolerance is 0.03, then a 16 bit fixed point with an 0.0625 LSB can represent the speed without loosing precision.

### Binary Angular Measure (BAM) 

Bam, also know as Rads and various other names, is a special and very usefull case of fixed point type that is used to represent angles.

Bam is a two's complement number between -1 to 1 (excluding 1). To represent an angle between -180 to 180 (excluding 180) in Bams, one needs to scale the angle by 1/180.

In ada the definition of such type might look like this:

$$code(lang=ada)

type Bams is delta 2**-15 range -1 .. 1 - 2**-15; 

$$/code


