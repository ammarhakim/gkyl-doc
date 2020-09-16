About
+++++

Gkeyll v2.0 (also known as Gkyl, or G2) is a computational plasma
physics code mostly written in `LuaJIT <http://luajit.org>`_, with
time-critical parts written in C++. Gkyl contains solvers for
gyrokinetic equations, Vlasov-Maxwell equations, and multi-fluid
equations. Gkeyll *contains ab-initio and novel implementations* of a
number of algorithms, and perhaps is unique in using a JIT compiled
typeless dynamic language for its implementation.

One of the main innovations in Gkeyll is the blurring of boundaries
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

License
-------

**Gkeyll can be used freely for research at universities, national
laboratories and other institutions. In general, use in commerical
(for-profit) companies is not permitted, even if used for research. If
you want to use Gkeyll in a commerical enviornment, please ask us
first.**

We follow a *open-source but closed development model*.  Even though
read access to the code is available to everyone, write access to the
source-code repository is restricted to those who need to modify the
code. In practice, this means researchers at PPPL and our partner
institutions. In particular, this means that for write access you
either need to have jointly funded projects or jointly supervised
graduate students with Princeton University/PPPL.

In general, we allow users to "fork" the code to make their own
modifications. However, we would appreciate if you would work with us
to merge your features back into the main-line (if those features are
useful to the larger Gkeyll team). You can submit a "pull request" and
we will try our best to merge your changes into the
mainline. Contributed code should compile and have sufficient
unit/regression tests.

Gkeyll, Postgkyl and this documentation is copyrighted 2016-2020 by
Ammar Hakim and the Gkeyll Authors.
