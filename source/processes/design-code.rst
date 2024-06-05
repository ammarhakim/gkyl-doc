.. _processDesignCode

Gkeyll Design and Code Review Process
=====================================

We intend for Gkeyll to be, and to remain, a robust, stable and maintainable code that
provides a scalable and reliable foundation for open-ended scientific research and
algorithmic development, long into the future. 

To this end, we must ensure that our code quality, as well as the quality of our overall
software architecture, is of a consistently high standard. We have developed the
following processes in the interests of preserving the overall integrity of our codebase:
if you choose *not* to follow these processes, then we make no guarantee that your code
will be merged, or even reviewed, and repeated violations will be penalized. See the
final section of this document.

We make an important distinction in what follows between *design* reviews (which
typically come at the beginning of the implementation process, though depending upon the
complexity of the change they may also continue to occur throughout it), and *code*
reviews (which typically come at the end of the implementation process, during the final
preparation stages for code being merged into ``main`` [*]_ ):

* *Code reviews* concern the details of how an individual feature or change has been
  implemented, whether the algorithms implemented are correct, whether the test cases
  included are appropriate and sufficient, whether the code is clean, consistent,
  maintainable and comprehensible.

* *Design reviews* concern the architectural details of how that feature or change
  interacts with the rest of the codebase, whether the design of user-facing APIs is
  coherent and consistent with the design decisions made in other parts of the code,
  whether the algorithms involved are robust, whether there are functionality overlaps
  that may necessitate future refactoring, whether there are obvious architectural, and
  convention clashes that need to be resolved.

One of the most important general principles that one must always bear in mind when
developing for Gkeyll is: **any code that's worth writing is worth writing (at least)
twice**.

Do I really need a design review?
---------------------------------

**Yes**. The general rule that we enforce is that any change which involves modifying
existing code in either of the ``/apps`` or ``/zero`` directories in ``gkylzero``, or
modifying any part of the Lua/G2 layer with the exception of regression and unit tests,
requires a design review (unless this change is obviously trivial, such as fixing
punctuation in a comment). For some changes, the requirement for a formal design review
may be waived, but in such cases the change must nevertheless still be discussed with
a member of the core Gkeyll architecture team beforehand, in order to ascertain that a
review is indeed unnecessary. If no such review or discussion has occurred, then any
changes that you subsequently make will not be merged into ``main``.

Modifying existing code in ``/unit``, ``/regression``, ``/kernels``, etc. will *not*
require design review, unless these changes are especially invasive or disruptive -
exercise judgment!

Always prototype first!
-----------------------

No one writes perfect code on the first try, and any non-trivial software design will
inevitably evolve as the code actually gets written: things that seemed elegant and
natural in the initial design may turn out to be ugly and confusing in your actual
implementation; you may discover that things you had previously assumed would be easy
(or at least possible) are, in fact, complicated (or indeed impossible); your initial
design may have assumed that data could be passed around in a manner that actually
violates certain App boundaries or other existing code restrictions; and so your overall
code architecture or underlying algorithm may need to be modified.

For this reason, it is almost always a mistake to expect to create a perfect and
fully-formed software design ex nihilo. Instead, we strongly suggest that you begin by
creating a private prototyping branch in which to play around and try out an
implementation of your design, and to allow your ideas to evolve naturally as you write
the code, **without any expectation that this branch will be merged into** ``main``. We
recommend that you name this branch using the convention ``<featurename>-prototyping``
to avoid potential confusion, and to make it clear to reviewers, as well as to other
developers, that this branch will not be merged.

Once you have arrived at a design that you are happy with, and that design has gone
through the formal design review process (and has been approved for implementation),
then you can create a new ``<featurename>-production`` branch in which you rewrite a
production-quality version of the prototype functionality which you first implemented
in ``<featurename>-prototyping``, which may then later go through the formal code review
process to be merged into ``main``.

The design review process
-------------------------

Once you have gone through the prototyping stages and you are satisfied with the
resulting code design, the first step in the design review process is to open a GitHub
Issue describing, in full detail, the feature or change that you propose to make. The
Gkeyll team follows an *input file-driven development culture*. Concretely, what this
means is that within the GitHub Issue that you open, **you must provide example code
fragments**, either in the form of example unit tests (for the case of smaller, more
piecemeal changes), or example regression tests (for the case of larger, more holistic
design changes and features), with a strong preference for both. This will enable
reviewers to understand how you expect users to interact with your code, to critique the
design of any user-facing APIs that you create, and to determine how your change will
interact with the rest of the Gkeyll codebase. Sample documentation fragments are also
highly encouraged (and will save time in the documentation process further down the
line).

If you have a prototype implementation of your proposed change or feature in a private
branch (which is strongly preferred - see the previous section), then you should link
that branch to the GitHub Issue. When the branch holding the production-quality version
of your code is created (assuming that the design is approved), that branch should also
be linked to the GitHub Issue. **Any design proposals you make that have not gone through
the aforementioned prototyping stage will be subject to a much higher degree of
scrutiny**, and may well be rejected outright. In general, **any code that has not been
written at least twice will be viewed with great suspicion**.

In order to proceed with the production implementation of your proposed change or
feature, your design review must be approved by (at least) two members of the Gkeyll
team. One should be a domain expert in the specific scientific or algorithmic area(s)
that your change concerns: gyrokinetics, relativity, DG algorithms, etc., who can
consequently provide comments on the soundness of the user-facing API, the proposed
algorithmic framework, and the proposed implementation strategy. The other should be a
member of the core Gkeyll architecture team, who can provide comments regarding the
architectural consonance of the proposed change or feature with the remainder of the
Gkeyll code. In cases where the reviewing member of the core Gkeyll architecture team
also happens to be a domain expert in the relevant area, the opinion of an alternative
domain expert should be sought instead (i.e. that person cannot “double up” by
reviewing both aspects of the design). If you proceed with the implementation of a
design that has not been explicitly approved by both a domain expert and a member of
the core Gkeyll architecture team, then your code will not be merged into ``main``.

What if my design changes?
--------------------------

You may well discover that your design ideas evolve yet further as you continue onward
with the production implementation of your code, such that the design that you end up
implementing differs - to a greater or lesser extent - from the design that was
previously reviewed and agreed upon by the team. This is perfectly okay, and indeed is
a natural part of the software development process. However, once your new design begins
to stabilize, **you must request an additional design review**, using the same process
described above (updating the old GitHub Issue as needed), and your new design must
again be approved by both a domain expert and a member of the core Gkeyll architecture
team before you proceed.

If the design of the production implementation of your proposed feature or change
differs markedly from the design that was previously agreed upon in the design review
process, and you did not request (and receive approval from) any intermediate design
reviews along the way, then your code will not be merged into ``main``, and you must
start the process again.

The code review process
-----------------------

Gkeyll already has a reasonably well-established code review process, and we intend to
make only minimal modifications to it. Once the production implementation of your
proposed feature or change is complete (and its final design approved, as required),
then you may open a Pull Request to merge the ``<featurename>-production`` branch into
``main``. Your Pull Request should describe the code changes that you have made, **and
the test coverage that you have added in order to validate these changes**. [*]_

As with design reviews, every Pull Request must have (at least) two reviewers: one
designated domain expert, plus one designated member of the core Gkeyll architecture
team, and preferably these reviewers should be the same as the reviewers who performed
the initial design review. Both reviewers need to have approved the Pull Request before
it will be merged, and the final decision to merge will rest with the designated member
of the core Gkeyll architecture team for that Pull Request.

Particular attention will be paid by both reviewers to the quality of *tests* (both unit
and regression) in the Pull Request. Specifically, they will be attempting to determine:

* The extent to which the design of the tests matches the original design proposal for
  the feature or change in question;

* The total level of test coverage for the feature or change that has been implemented;

* The extent to which obvious, and preferably also non-obvious, corner cases are
  covered and handled correctly by the test suite.

The designated member of the core Gkeyll architecture team will, in addition, attempt
to ascertain the overall level of robustness, coherence and maintainability of the
code, with respect to the rest of the Gkeyll codebase.

This really shouldn't need to be said, but at the very least your code should compile
(you should run ``make unit regression`` to verify this), and all tests should pass
(which you should verify by running ``make check``). We have unit and regression tests
for a reason. Run them. There is no faster way to tank your push karma (see the final
section) than by trying to merge in code that breaks builds and/or breaks tests. All
code should also be "Valgrind-clean", in the sense of being verifiably free of memory
errors. Compile using the strictest values of the ``fsanitize`` compiler flag (e.g.
``-fsanitize=address``, ``-fsanitize=bounds-strict``, etc.) to confirm that no invalid
memory is being accessed, and always run Valgrind.

Perform your civic duty!
------------------------

With both design and code reviews, any member of the Gkeyll team who is called upon as
a reviewer should aim to provide at least some initial comments and feedback on the
request (of course they do not need to settle on any final decision regarding approval)
within a day or two of receiving the request, depending upon the size and complexity
of the review required. 

Sometimes, for complex or controversial changes, reviews may take a longer time to
complete. This is absolutely fine, as long as there is always active discussion and
improvement. But design and code review requests that sit stagnant for several days with
no (further) comment or discussion do not benefit anyone, and merely limit the ability
of the team to move quickly, fix bugs, and develop new functionality. In some cases,
impatient developers awaiting non-forthcoming reviews may be tempted to bypass parts of
the review process entirely, to push forward with unreviewed designs, or to “hack
around” unreviewed code as a consequence. This is extremely dangerous, and compromises
overall software quality. We are all busy with lots of other things, and of course
everyone would prefer to work on their own stuff rather than reviewing someone else's
software design or code. But you should consider it an honor for your expertise to be
valued and called upon in this way; do not be the person who slows everyone else down!

Don't sweat the small stuff
---------------------------

At this point, the Gkeyll codebase has a number of well-established style conventions,
which we are now in the process of codifying and enforcing more formally. Since all
developers have their own style of writing code, the conventions in Gkeyll have emerged
through a long and tedious process of conflict and eventual compromise, from which (as
with all compromises) no individual emerges entirely satisfied. Any good developer
views their code as a form of artistic expression, and will therefore find any attempt
to integrate into an existing style convention somewhat uncomfortable; this is
unfortunate, but also inevitable.

Such passion is good. But you should channel that passion for your craft into caring
deeply about the **design** of your code. This is what ultimately matters, and is where
the true opportunities for creativity lie, rather than the syntactic **style** of your
code (which is, after all, a matter of “mere technique”). No one wants to waste
precious developer time arguing about where to place braces or whether to capitalize
variable names. Adhere to the stylistic conventions of the Gkeyll group, however alien
they may feel at first, so that we can focus all of our collective energy into producing
beautifully-*designed* code of which we can rightly feel proud. In short, **don't sweat
the small stuff**.

Re-architecting functionality: don't modify, rewrite
----------------------------------------------------

There are occasions when it may become necessary to make invasive changes to core parts
of the Gkeyll architecture, such as time-stepping functionality or boundary condition
handling, in either of the ``/apps`` or ``/zero`` directories of ``gkylzero``, or
equivalent parts of the Lua/G2 layer (or both). **It is essential that such changes are
handled in an extremely cautious, conservative and controlled manner, in strict
accordance with the following guidelines**. The general principle to follow here is
**don't modify: rewrite**.

For instance, if the changes that you intend to make are going to modify in a
fundamental way most or all aspects of an App, then you should not make those changes
to the App code directly. Rather, you should aim to rewrite the App code entirely, with
the new version of the App including all of your planned modifications. Then, once that
new code has been stabilized, you should run the full suite of ``/unit`` and
``/regression`` tests **with pointers to the old App replaced by pointers to the new
App**. These test results should be used to demonstrate, conclusively, that the
functionality of the new version of the App code is a **strict superset** of the
functionality of the old version of the App code. This must be done **in addition** to
the running of any new tests that might be necessary to demonstrate that the new version
of the App code indeed correctly encompasses all of the new functionality that you
intended to implement. Only once this has been demonstrated to the satisfaction of the
reviewers should pointers to the old App be replaced by pointers to the new App
globally within the Gkeyll code. Once this process is complete, then the old App code
may be safely deleted. Throughout this process, **backwards compatibility of the new App
with the old App is of paramount importance**.

On the other hand, if the changes that you intend to make are modifying only a few
aspects of a particular App (e.g. the time-stepper), then it may not be necessary to
rewrite the App code in its entirety. However, once again, in this case the old
time-stepper code should not be touched, but rather rewritten, with appropriate function
pointers passed to allow one to switch seamlessly between the old time-stepper and the
new one. As in the above, the complete ``/unit`` and ``/regression`` test suite should
be used to demonstrate that the capabilities of the new time-stepper remain a strict
superset of the capabilities of the old time-stepper, and only then should the code be
globally modified to point to the new time-stepper rather than the old. Finally, the
old time-stepper code may either be deleted or retained, as appropriate. 

As always, if you fail to adhere to these guidelines, and especially if you choose to
make direct and invasive modifications to core Gkeyll functionality without following
this general *“rewrite and switch”* process, then your Pull Request(s) will be closed
automatically, without further review.

Non-compliance
--------------

As discussed, failure to adhere to the processes described in this document will result
in your code not being merged into ``main``, your designs being rejected, and/or your
code being rewritten. Repeated flouting of these processes will result in your overall
level of *push karma* (a publicly-visible indication of your level of compliance with
these processes) being decremented. Gkeyll developers with lower push karma have a
higher barrier to clear when making design proposals or merging code into ``main``, and
their design proposals and Pull Requests will be subject to higher levels of scrutiny.

Persistently ignoring these requirements will also lead to loss of write access to the
Gkeyll repositories, for escalating periods of time.

.. [*] Although these instructions are mostly written from the perspective of code
   changes that are eventually planned to be merged into ``main``, there may, on
   occasion, be especially long-lived critical branches in the Gkeyll codebase to which
   we will also choose to apply write protections; these same instructions will also
   apply for any changes that are eventually planned to be merged into such protected
   branches, too.

.. [*] This is absolutely crucial. In the absence of appropriate tests, all Pull
   Requests will be automatically rejected.