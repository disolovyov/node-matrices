# Matrices for Node

The matrices package provides some typical matrix calculations, with more
added as deemed necessary. Operations include addition, negation, product,
transposition, augmentation, slicing, equality with precision, and finding the
norm, determinant, and inverse.

To install matrices, do this:

    $ npm install matrices

## Building

This code uses the [Beans](https://github.com/dimituri/beans) toolset to build
Node and browser JavaScript, as well as documentation. The easiset way to work
on the source is by installing dependencies and running Beans from there:

    $ npm install
    $ npm run-script build

Otherwise you can use the CoffeeScript compiler to build things in a way you
like, e.g. by running:

    $ coffee -c -o lib src

# Documentation

Another way to get annotated source code is to clone this repository and use
[Docco](http://jashkenas.github.com/docco/) with Beans:

    $ npm run-script docs

Or standalone:

    $ docco src/*.coffee src/**/*.coffee

A `docs` directory should be created in the working directory root.
