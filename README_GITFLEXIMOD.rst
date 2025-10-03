Obtaining submodules and associated scripting infrastructure
=====================================================================

Some CESM CMIP7 tools are in external repositories, and git-fleximod is used to include them
in this checkout. These tools maybe quite complicated and require other submodules for them
to work. YOU DON'T NEED TO UPDATE SUBMODULES UNLESS YOU NEED TO WORK WITH TOOLS THAT USE THEM.

To obtain the submodules you need to do the following:

#. Clone the repository. ::

      git clone https://github.com/NCAR/CMIP7_inputdata_processing.git my_cmip7_sandbox

   This will create a directory ``my_cmip7_sandbox/`` in your current working directory.

#. Run **./bin/git-fleximod update**. ::

      cd my_cmip7_sandbox
      ./bin/git-fleximod update
      ./bin/git-fleximod --help  # for a user's guide

   **git-fleximod** is a package manager that will
   populate the my_cmip7_sandbox directory with the relevant versions of each of the
   tools and submodules needed to use them.
   Additional documentation for git-fleximod appears here:
   https://github.com/ESMCI/git-fleximod?tab=readme-ov-file#git-fleximod


More details on git-fleximod
----------------------------

The file **.gitmodules** in your top-level my_cmip7_sandbox directory tells
**git-fleximod** which tag/branch of each submodule
should be brought in to generate your sandbox.

NOTE: If you manually modify a submodule without updating .gitmodules,
e.g. switch to a different tag, then rerunning git-fleximod will warn you of
local changes you need to resolve.
git-fleximod will not change a modified submodule back to what is specified in
.gitmodules without the --force option.
See below documentation `Customizing your my_cmip7_sandbox`_ for more details.

**You need to rerun git-fleximod whenever .gitmodules has
changed** (unless you have already manually updated the relevant
submodule(s) to have the correct branch/tag checked out).

Customizing your my_cmip7_sandbox
=================================

There are several use cases to consider when you want to customize or modify your my_cmip7_sandbox sandbox.

Pointing to a different version of a submodule
----------------------------------------------

Each entry in **.gitmodules** has the following form (we use CIME as an
example below)::

  [submodule "cime"]
  path = code/land-use/ctsm5.4_for_mksurfdat/cime
  url = https://github.com/ESMCI/cime
  fxtag = cime6.1.246
  fxrequired = ToplevelRequired
  fxDONOTUSEurl = https://github.com/ESMCI/cime

Each entry specifies either a tag or a hash. To point to a new tag or hash:

#. Modify the relevant entry/entries in **.gitmodules** (e.g., changing
   ``cime6.1.246`` to ``cime6.1.247`` above)

#. Checkout the new submodule(s)::

     ./bin/git-fleximod update <submodule>

Keep in mind that changing individual submodules may not work with the other
tools if there is a version dependency between tools and submodules.
For example, the ctsm tool mksurfdata_esmf has dependencies with both CIME and
ccs_config, so changing the versions of any one of them may not work if they
are incompatible with each other.

Committing your change to .gitmodules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After making this change, it's a good idea to commit the change in your
local my_cmip7_sandbox git repository. You can either push the change
directly to the NCAR fork main branch, or create a branch on your own
fork in order to create a PR to the NCAR fork.

