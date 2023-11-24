.. _devRules:

On Developing and Contributing Code to Gkeyll Ecosystem
=======================================================

The Gkeyll Project is getting complex and difficult to manage. We have
a lot of projects within the group, with multiple institutions. Also,
the newly funded NSF CSSI project places additional burden on
management, as the goal of that project are to not only add AMR,
magnetosphere-specific code and a "Science Gateway", but also prep the
code for use as a user-centric resource. Hence, in this document we
list ideas for better project management and end-user engagement.

The goal here is not to introduce burdensome requirements. We want to
keep the project dynamic and fun, as it is at present. We do not want
a very formalized development process as I think it is not helpful for
a project like ours. In general, we believe we should accept all
contributions in an open and transparent way. However, seems some
structure is required so the project does not fall into chaos.

The proposals we have at present are as follows. Any ideas, comments
and concerns should be directed to the core Gkeyll Dev Team.

- Commits to the main branch shall only be made via a PR. No direct
  commits to the main branch will be permitted.
- You shall seek out feedback on your PR from others in the team to
  ensure some oversight on your contribution.
- You shall not accept your own PR. **Doing this will result in a
  commit-ban** for a period of time, depending on the severity.
- Before you submit your PR you shall ensure that the code builds and
  all unit tests pass. You shall make clean; make -j; and make
  check.
- The person who accepts the PR shall wait till at least one of the
  Mac or Linux build/test actions complete before accepting the
  PR. That person ideally should build the code and make check, but
  this is not a requirement.
