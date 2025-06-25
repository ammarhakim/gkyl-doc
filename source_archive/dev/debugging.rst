.. _debugging:

On Utlilizing The Built-In Debugger For Lua
=======================================================


The debugger included with `Gkeyll` is a simple command line debugger for lua code. It is included in the `gkyl/Tool` directory is a file `debugger.lua`. This file is coppied from the distribution which can be found at https://github.com/slembcke/debugger.lua. The debugger can be used to debug any lua file compiled using `Gkeyll``` by adding the following lines to the code:

.. code-block:: lua

  local dbg = require "Tool.debugger"
  dbg()

The command `dbg()` will trigger a break point and then the debugger will be started. It is sometimes nice to define dbg to be global at the input file level so that it can be called from any files in the core of `Gkeyll`. 

For a tutorial of how the debugger works, the original repo has a tutorial.lua which provides a comprehensive tutorial in how to use the debugger. Furthermore, by just typing h, the debugger will print out a list of commands that can be used to debug the code, listed below:

.. code-block:: console

    [return] - re-run last command
    c(ontinue) - contiue execution
    s(tep) - step forward by one line (into functions)
    n(ext) - step forward by one line (skipping over functions)
    p(rint) [expression] - execute the expression and print the result
    f(inish) - step forward until exiting the current function
    u(p) - move up the stack by one frame
    d(own) - move down the stack by one frame
    w(here) [line count] - print source code around the current line
    t(race) - print the stack trace
    l(ocals) - print the function arguments, locals and upvalues.
    h(elp) - print this message
    q(uit) - halt execution

Future work can include imbedding the .c and .h files into `Gkeyll`.