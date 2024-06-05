.. _processDesignCodeCondensed:

Gkeyll Design and Code Review Process: Condensed Version
========================================================

To be followed by anyone making modifications to code in either of the ``/apps`` or
``/zero`` directories in ``gkylzero``, or modifications to any part of the Lua/G2 layer
with the exception of regression and unit tests.

Note that an :ref:`extended form of this document <processDesignCode>` also exists.
Note, moreover, that when selecting appropriate design and code reviewers, you should
choose from
:ref:`these lists of designated Gkeyll personnel <processDesignCodeReviewers>` (i.e.
the Gkeyll domain experts and members of the core Gkeyll architecture team).

The process
-----------

#. Begin by creating a private prototyping branch in which to play around and try out an
   implementation of your design. Name it ``<featurename>-prototyping``, to make it clear
   to reviewers and other developers that there is no expectation that this branch will
   ever be merged into ``main`` [*]_ .

#. Kick off the design review process by creating a new GitHub Issue, providing explicit
   code fragments (preferably examples of both unit tests and regression tests, plus
   sample documentation pages) to illustrate how you expect new users to interact with
   your code. Link the ``<featurename>-prototyping`` branch from Step 1 to the Issue.
   Request a review from (at least) one domain expert and one member of the core Gkeyll
   architecture team. Do not proceed to Step 3 until your final design has been approved
   by both reviewers.

#. Create a new ``<featurename>-production`` branch in which you intend to rewrite a
   production-quality version of the prototype functionality you first wrote in
   ``<featurename>-prototyping``, in accordance with the approved design from Step 2.
   Link the ``<featurename>-production`` branch to the GitHub Issue outlining the
   proposed design as well.

#. If your design necessitates invasive changes to major parts of the Gkeyll
   architecture, do not modify any App code directly. Instead, create a new version of
   the App (or of the particular part of the App being modified) which includes your
   changes, confirm that all ``/unit`` and ``/regression`` tests run with pointers to
   the old App version replaced by pointers to the new App version. Only once this has
   been done to the satisfaction of the reviewers should the Gkeyll code be globally
   changed to point to the new App, at which point the old App code may be safely
   deleted.

#. If the design changes at any point during the implementation process, you must return
   to Step 2 (updating the old GitHub Issue as needed) and re-request a design review.
   The new design must be re-approved before proceeding with implementation.

#. Once the implementation, in accordance with the approved design, has been completed,
   open a Pull Request to merge the ``<featurename>-production`` branch into ``main``.
   (Of course your code should compile, using ``make unit regression``, and all tests
   should pass, using ``make check``). Provide full details not only of the code changes
   you have made, but also of the test coverage that you have added in order to validate
   these changes. As in Step 2, request a review from (at least) one domain expert and
   one member of the core Gkeyll architecture team - preferably the same reviewers who
   approved the original design.

.. [*] Although these instructions are written with regards to code changes that are
   eventually planned to be merged into ``main``, they apply equally to planned changes
   to *any* long-lived branch with write protections enabled.