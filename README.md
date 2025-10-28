# test-cymem-threadsafety

Multithreaded tests for [cymem](https://github.com/explosion/cymem) memory pool operations.

## Overview

This project tests the thread-safety of cymem's memory pool implementation by running
concurrent memory operations (allocation, reallocation, and freeing) across multiple threads.
It's designed to verify that cymem's memory management works correctly in multithreaded
environments, particularly with Python's free-threaded build.

**Note:** This project depends on a
[fork of cymem](https://github.com/lysnikolaou/cymem/tree/free-threading) that implements
free-threaded support until that has been merged upstream.

## Building

This project uses Meson as the build system via meson-python. To build:

```bash
# Inside a virtual environment
python -m pip install -r requirements/build.txt
spin build
```

## Running Tests

The test suite includes concurrent operations on cymem's Pool:

```bash
python -m pip install -r requirements/test.txt
spin test
```
