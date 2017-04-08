Tags: C++, Ada
date: 2014/09/05 22:00:00
title: Range Constrained Types in C++
url: 2014/09/05/range-constrained-types-in-c++/
save_as: 2014/09/05/range-constrained-types-in-c++/index.html

One of the first things a new Ada programmer will learn is the ability to define constrained type. Which means that one can restrict the values that can be assigned to a variable of this specific type.

For example:

    :::ada
    subtype Positive is Integer range 1 .. Integer'Last;


Being a subtype of _Integer_, _Positive_ is fully compatible with it and can be used wherever _Integer_ is applicable. Ada's runtime system however, will guard against assignments of values lower than 1 and will dispatch a runtime error whenever this happens.

This feature enhances type safety and reduces probability for bugs. For example, one can safely divide an _Integer_ by _Positive_ without fear of dividing by zero. 

C++ does not have this feature. There is an unofficial Boost library [claiming](http://www.boost.org/doc/libs/1_48_0/boost/date_time/constrained_value.hpp) to implement it. However reading the implementation I found out that _constrained_value_ is not a proper subtype of _value_type_. There are examples where instances of the first, can not substitute the other:

    :::c++
    
    void f(bounded_int<int, 0, 100>::type x) { ... };
    
    ...
    
    bounded_int<int, 0, 100>::type x = 5;
    x++; // Compilation error: operator not defined.
    f(x); // Compilation error: casting operator not defined.
    
With these limitations, this feature becomes less useful.

Therefore, as an exercise, I decided to implement this feature on my own. The goals of my implementation were:

* Proper subtyping of the base type. 
* Smallest possible performance and memory penalty.
* Simple interface.
* Extensive automatic testing.

### How to Use ###

The code itself can be found on [github](https://github.com/alkhimey/ConstrainedTypes). Just grab the file named _subtype_range_constrained.h_ and add it to your project.

Here is a simple usage example:

    :::c++
    typedef ct::RangeConstrained<short, 1, 12> positive;
    
    int main(void) {
        positive p = 12;
        int x = -3;
    
        p = p + x;  // Ok
        p = x;      // Exception!
    }
    
