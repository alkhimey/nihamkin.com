Tags: C++, generics
date: 2014/05/04 23:00:00
title: Template Argument Deduction
draft: False

With automatic template deduction, it is possible to omit the template argument when instantiating a template function. The compiler will deduce the type from the actual parameter sent to the function. This is of course assuming there are no ambiguities.

For example:

    :::c++
    
    template<class T>
    T max(T x, T y) {}
    
    int main(void) {
        return max(0,1);       // equivalent to max<int>(0,1);
    }

As I have found recently, there is more to this feature than meets the eye.

Assume that we want to write a function that would merge two std vectors. A usage example would look like this:

    :::c++
    
    vector<int> v1(5,10), v2(4,12),v3;
    
    v3 = merge_vectors(v1,v2);

Since _vector_ is a class template, the following signature would not compile:

    :::c++
    vector merge_vectors(vector v1, vector v2) {
         // ...
    }

> error: invalid use of template-name ‘std::vector’ without an argument list

We do not want to create a separate function for each vector instantiation we use in our program . The solution is to use a function template:

    :::c++
    template<class T>
    vector<T> merge_vectors(vector<T> v1, vector<T> v2) {
         // ...
    }

The deduction here is more complex than in the first example. _T_ is deduced not by the parameters sent to the function, but by the generic argument used to instantiate those parameters. This is important because we want to constraint the parameters to be vectors, we just do not care what kind of vectors they are.



