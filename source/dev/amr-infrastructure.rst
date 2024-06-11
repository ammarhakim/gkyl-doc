.. _devAMRInfrastructure:

Static and adaptive mesh refinement (AMR) infrastructure in Gkeyll
==================================================================

The Gkeyll Moment app currently includes full capabilities for static/fixed mesh
refinement (SMR), with basic infrastructural support for full adaptive mesh refinement
(AMR) as well. There is an ongoing effort to extend Gkeyll's AMR capabilities, including
support for DG algorithms (in addition to the current support for finite volume
algorithms), integration with the Vlasov and gyrokinetics systems, GPU parallelization,
etc. Please expect this documentation page to be updated accordingly. The essential idea
behind SMR and AMR is that, if your simulation involves multiple characteristic length
scales (e.g. a multi-fluid simulation involving strong shock waves), then it can be
highly beneficial to use a computational mesh with a heterogeneous spatial resolution.
For instance, when modeling a shock profile around a moving object, the spatial
resolution required to resolve the shock may be much higher than the resolution required
to resolve any outgoing radiative effects, and therefore the simulation may be made
considerably more efficient by using a much finer mesh near the object, and a much
coarser mesh outside. For simulations involving eddies, vortices, fluid instabilities,
etc., the mesh may need to be dynamically refined and coarsened so as to track
the regions of interest correctly. To this end, Gkeyll uses modified versions of the
basic data structures proposed in [Berger1984]_ for block-structured/hierarchical AMR,
along with a modification to the finite volume update algorithm based on the method
outlined in [Berger1989]_.

Data structures for AMR in Gkeyll
---------------------------------

One of the core design features of Gkeyll is that, irrespective of one's choice of
physical coordinate system, all numerical algorithms assume a logically rectangular
computational mesh, which we shall henceforth denote by :math:`D`. In order to represent
the requisite recursive nesting of computational meshes necessary for AMR, we assume
that the total number of mesh refinement levels is :math:`l_{max}` (such that
:math:`l = 1` corresponds to the coarsest level of refinement, :math:`l = l_{max}`
corresponds to the finest level of refinement, and
:math:`l \in \left\lbrace 1, \dots, l_{max} \right\rbrace`). Each refinement level
:math:`l` consists of a collection of :math:`i_{max} \left( l \right)` individual
blocks/patches :math:`M_{l, i}`, where
:math:`i \in \left\lbrace 1, \dots, i_{max} \left( l \right) \right\rbrace`.
The overall computational mesh :math:`M_l` at refinement level :math:`l` is then simply
given by the union of all blocks/patches :math:`M_{l, i}` at that refinement level:

.. math::
  \forall l \in \left\lbrace 1, \dots, l_{max} \right\rbrace, \qquad
  M_l = \bigcup_{i \in \left\lbrace 1, \dots, i_{max} \left( l \right) \right\rbrace}
  M_{l, i}.

Note that, at present, Gkeyll assumes that all blocks/patches which exist at the same
refinement level are strictly non-overlapping:

.. math::
  \forall l \in \left\lbrace 1, \dots, l_{max} \right\rbrace, \qquad \forall i, j \in
  \left\lbrace 1, \dots, i_{max} \left( l \right) \right\rbrace,\\
  M_{l, i} \cap M_{l, j} = \varnothing \qquad \iff \qquad i = j,

and therefore the union operation in the above definition may be safely assumed to be
disjoint. However, the relevant algorithms may be easily extended to the case of
overlapping meshes too, and this capability is planned for future inclusion in Gkeyll.
The computational mesh :math:`D` corresponding to the entire problem domain is now simply
given by the coarsest mesh :math:`M_1`:

.. math::
  D = M_1 = \bigcup_{i \in \left\lbrace 1, \dots, i_{max} \left( l \right) \right\rbrace}
  M_{1, i}.

Finally, we must also introduce a family of *projection* operators (for *projecting*
values from coarse meshes to fine ones) and *restriction* operators (for *restricting*
values from fine meshes to coarse ones). Suppose that one has a fine mesh at refinement
level :math:`l` and a coarse mesh at refinement level :math:`l - 1`, such that the
difference in resolution (otherwise known as the *refinement factor*) between the two
meshes is given by :math:`r`; in one dimension, this means that the fine mesh contains
:math:`r` times as many cells as the coarse mesh; in two dimensions, this means that the
fine mesh contains :math:`r^2` times as many cells as the coarse mesh; etc. If
:math:`u_{i}^{fine}` denotes the cell-centered value of some conserved quantity in cell
number :math:`i` of the fine mesh in one dimension (with :math:`u_{i, j}^{fine}` being
the corresponding notation in two dimensions, etc.), and :math:`u_{i}^{coarse}` denotes
the cell-centered value of the same conserved quantity in cell number :math:`i` of the
coarse mesh in one dimension (with :math:`u_{i, j}^{coarse}` being the corresponding
notation in two dimensions, etc.), the coarse-to-fine projection operator is given by a
straightforward copy operation from coarse cells to fine cells:

.. math::
  u_{i}^{fine} = u_{\left\lfloor \frac{i}{r} \right\rfloor}^{coarse},

in one dimension, or:

.. math::
  u_{i, j}^{fine} = u_{\left\lfloor \frac{i}{r} \right\rfloor,
  \left\lfloor \frac{j}{r} \right\rfloor}^{coarse},

in two dimensions, etc.

References
----------

.. [Berger1984] M. J. Berger and J. Oliger, "Adaptive mesh refinement for hyperbolic
   partial differential equations", *Journal of Computational Physics* **53** (3):
   484-512. 1984.

.. [Berger1989] M. J. Berger and P. Colella, "Local adaptive mesh refinement for shock
   hydrodynamics", *Journal of Computational Physics* **82** (1): 64-84. 1989.