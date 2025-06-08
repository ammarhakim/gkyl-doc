.. _suggestedTemplates:

Suggested templates for issues and pull requests to Gkeyll
=======================================================================================

When creating an issue or pull request, we suggest using the following templates to ensure that the issue is addressed in a timely manner.
Templates are a great way to standardize the review process and ensure compliance with project guidelines. Also, they make sure that
developers are rigorous in their testing and do not forget checks.

.. contents:: Table of Contents
   :depth: 2
   :local:

Issues
-----------------------

Bug report
~~~~~~~~~~~~~~~~~~~

.. code-block:: markdown

  # Bug Report

  _Italicized text may be removed for final submission_

  ## Summary:

  _A brief description of the issue._

  ## Steps to Reproduce:

  _Provide a clear, step-by-step guide to reproduce the issue._

  1. _Step 1._
  2. _Step 2._

  ## Expected Behavior:

  _Describe what you expected to happen._

  ## Actual Behavior:

  _Describe what happened, including error messages or incorrect output._

  ## Environment:

  _Provide details of the environment where the issue occurred_

  - System / Cluster Name: 
  - Branch name: 
  - GPU or CPU build: 
  - Operating System:
  - Loaded modules:
  - Code version: (e.g. commit hash):

  ## Additional Context:

  _Any other details or comments that might help us diagnose the issue._

  _Did the issue occur after a recent update or change?_

  _Are there specific parameters or inputs that seem to trigger the bug?_

  _Screenshots, logs, or output files (if applicable)_

  ## Suggested Fix (Optional):

  _If you have an idea for a fix, describe it here._



Design review
~~~~~~~~~~~~~~~~~~~

.. code-block:: markdown 

  # Design Review

  _Italicized text may be removed for final submission_

  ## Overview

  Description: _Provide a brief overview of the feature or change. Explain its purpose, scope, and intended outcome._

  Motivation: _Why is this feature or change needed? What problem does it solve, or what improvement does it bring to Gkeyll?_

  Impact: _Outline the expected impact on the codebase, including affected areas (e.g., /apps, /zero, Lua/G2 layer). Specify if there will be breaking changes or dependencies on other components._

  ## Proposed Design

  Key Design Elements: _Describe the key aspects of your proposed design. Use concise language to outline the algorithms, user-facing APIs, and architectural choices._

  Interaction with Existing Code: _Explain how this change will integrate with the current codebase. Highlight any architectural or convention clashes and areas that might require future refactoring._

  Prototyping Efforts (if applicable): _Provide a link to your prototyping branch. Briefly summarize your findings from prototyping, including any adjustments made to the design._

  Sample Code:
  ``` 
  Include example input file fragments, unit tests, regression tests, or mock APIs to will help reviewers understand how the proposed feature will be used and tested.
  ```

  ## Design Review Checklist _(x (yes), blank (no))_

  Approval Criteria: 

  - [ ] Is the design coherent and consistent with Gkeyll's existing architecture?
  - [ ] Does the design align with user-facing API standards?
  - [ ] Do functionalities overlap with existing features?
  - [ ] Are the algorithms robust and appropriate for the intended purpose?

  ## Additional Notes

  Future Considerations: _Are there any anticipated challenges or areas of concern in implementing this design?_

  Feedback Integration Plan: _Outline how you will address feedback received during the design review process._

  ## Links

  Prototyping Branch: _Link to prototyping branch_

  Relevant Documentation: _Links to LaTeX files or working notes_

  Additional Resources: 

Feature request
~~~~~~~~~~~~~~~~~~~

.. code-block:: markdown

  # Feature Request

  _Italicized text may be removed for final submission_

  ## Summary

  Overview: _What problem does this feature address? Clearly describe the problem or limitation that this feature would solve._

  Proposed solution: _Outline the proposed solution and how it addresses the problem._

  ## Feature Details

  Key functionality: _Describe the specific functionality of the feature._

  Scope: _Indicate the scope of the feature (e.g., minor enhancement, major overhaul, etc.)._
  User Stories/Use Cases:

  Example: _Provide examples of how the end-user would use this feature._

  ```
  Example code snips can improve clarity to the reviewer
  ```

  ## Benifits

  _Explain the benefits of implementing this feature._

  _How does it improve the user experience, efficiency, or codebase?_

  ## Considerations

  _Describe any known challenges, risks, or dependencies that might impact development._

  _List any alternative solutions and why they were not chosen._

  ## Additional Information

  _Include any relevant diagrams, mockups, screenshots, or resources (if applicable)._

  ## Checklist _(x (yes), blank (no))_

  - [ ] This feature has not already been implemented or requested.
  - [ ] I have reviewed related issues and discussions to avoid duplication.

Pull requests
--------------------

Bug fix
~~~~~~~~~~~~~~~~~~~

.. code-block:: markdown

  # Bug fix

  _Italicized text may be removed for final submission_

  ## Summary

  Description: _Describe the bug in a sentence or two. What was the root cause?_

  Issue link: _A link to the issue._

  ## Solution

  _Explain how the bug was fixed. Highlight the changes made to the code and why they address the issue._

  Impacted files: _List the components, files, or modules impacted by the fix._

  Automated testing: _Please explain how the feature was tested. If no automated tests are included (e.g. unit, regression), explain why._

  ## Community Standards

  - [ ] Documentation has been updated.
  - [ ] My code follows the project's coding guidelines.
  - [ ] Changes to `/zero` should have a unit test.

  ## Testing: _(x (yes), blank (no))_

  - [ ] I added a regression test to test this feature.
  - [ ] I added this feature to an existing regression test.
  - [ ] I added a unit test for this feature.
  - [ ] Ran `make check` and unit tests all pass.
  - [ ] I ran the code through Valgrind, and it is clean.
  - [ ] I ran a few regression tests to ensure no apparent errors.
  - [ ] Tested and works on CPU.
  - [ ] Tested and works on multi-CPU.
  - [ ] Tested and works on GPU.
  - [ ] Tested and works on multi-GPU.

  ## Additional Notes

  _Include any additional context, related PRs, or future considerations related to this bug fix._


Feature addition
~~~~~~~~~~~~~~~~~~~

.. code-block:: markdown

  # Feature

  _Italicized text may be removed for final submission_

  ## Summary

  Purpose: _Explain the feature and why it is being added._

  Issue link: _Link to the related issue or feature request_

  ## Implementation Details

  Key changes: _List the key changes made to the codebase to implement the feature._

  _Describe any new components, classes, or modules introduced._

  Dependencies: _If any, mention any new configuration changes, libraries, or dependencies added._

  Automated testing: _Please explain how the feature was tested. If no automated tests are included (e.g. unit, regression), explain why._

  ## Example Use

  _Provide some example code of how a user may utilize this new feature in an input file._

  ```
  example code
  ```

  ## Community Standards

  - [ ] Documentation has been updated.
  - [ ] My code follows the project's coding guidelines.
  - [ ] Changes to `/zero` should have a unit test.

  ## Testing: _(x (yes), blank (no))_

  - [ ] I added a regression test to test this feature.
  - [ ] I added this feature to an existing regression test.
  - [ ] I added a unit test to test this feature.
  - [ ] Ran `make check` and unit tests all pass.
  - [ ] I ran the code through Valgrind, and it is clean.
  - [ ] I ran a few regression tests to ensure no apparent errors.
  - [ ] Tested and works on CPU.
  - [ ] Tested and works on multi-CPU.
  - [ ] Tested and works on GPU.
  - [ ] Tested and works on multi-GPU.

  ## Additional Notes

  _Include any additional context, caveats, or future improvements related to the feature._

Documentation changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: markdown
  
  # Documentation Changes

  _Italicized text may be removed for final submission_

  # Purpose

  _What does this update address?_

  _Briefly describe the reason for the documentation update (new information, improve clarity, fix errors, update deprecated content, etc.)._

  # Affected Areas

  _Which part of the documentation is being updated?_

  _List the files, sections, or components of the documentation that are affected by this update (e.g., API reference, installation guide, tutorial, etc.)._

  # Changes Made

  _List and describe the specific changes made to the documentation._

  # Reason for Change

  _Explain why these changes were necessary or how they improved the documentation._

  # Additional Notes

  _Include relevant information that might help reviewers, such as why certain phrasing was used or how the changes relate to new functionality or bug fixes._

  # Checklist _(x (yes), blank (no))_
  - [ ] I have reviewed the documentation for accuracy.
  - [ ] All technical terms and code examples have been double-checked.
  - [ ] The update aligns with the overall style and tone of the documentation.
  - [ ] The updated documentation builds correctly (if applicable).
