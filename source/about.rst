About
+++++

Gkeyll v2.0 (also known as Gkyl, or G2) is a computational plasma
physics code mostly written in `LuaJIT <http://luajit.org>`_, with
time-critical parts written in C++. Gkyl contains solvers for
gyrokinetic equations, Vlasov-Maxwell equations, and multi-fluid
equations. Gkyl *contains ab-initio and novel implementations* of a
number of algorithms, and perhaps is unique in using a JIT compiled
typeless dynamic language for its implementation.

One of the main innovations in Gkyl is the blurring of boundaries
between user written code (i.e. input files) and backend solver
code. In fact, there is no difference: the front-end and back-end are
written in the same programming language, opening up a very powerful
way of composing simulations. All solver objects (grids,
data-structures, updaters) can be queried, modified and controlled by
the user, allowing complete control over the full simulation
cycle. The use of the highly optimized Just-in-Time (JIT) compiled
LuaJIT as the main programming language ensures that user written code
remains highly efficient. Of course, core kernels can always be
written in C/C++ and hooked in via LuaJIT's powerful `FFI
<http://luajit.org/ext_ffi.html>`_ facilities.
