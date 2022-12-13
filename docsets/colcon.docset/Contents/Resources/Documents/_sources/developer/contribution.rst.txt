Contributions
=============

There are already many great contribution guidelines available online.
Therefore only a few important bullets are enumerated here.
Please read for example the Open Source Guide `How to contribute <https://opensource.guide/how-to-contribute/>`_ for more detailed information which was created and is curated by GitHub.

Bug reports
-----------

* Make sure you are using the latest version.
* Search the project’s issue tracker and/or the internet for similar reports.
* Perform basic troubleshooting steps:

  * Try to reproduce the problem "from scratch".
  * If you are deviating from any instructions try to following the instructions and see if the problem persists.
  * If it seems to work for others ask yourself what is different in your case.

* Consider to provide a pull request if possible.
* And as a last step report a bug you can’t solve yourself:

  * Describe the expected as well as the actual behavior.
  * Give enough context (e.g. platform, versions, environment).
  * Provide easily reproducible steps and/or a `SSCCE <http://sscce.org/>`_.

Pull requests
-------------

* Keep each pull request focused on one aspect, create separate ones for separate aspects.
* For bug fixes make sure to reproduce the problem before and after applying the patch ensure that the problem has been addressed.
* For larger patches consider to create a feature request ticket to discuss the proposal ahead of time.
* Ensure that new code is covered by tests to prevent regressions in the future.
* Make sure that the code changes pass the existing tests including the linters.
* And as a last step create a pull request.

Documentation
-------------

Since documentation is stored in a git repository any changes are made through pull requests and therefore the above bullets for pull requests apply.

The documentation follows the one-sentence-per-line style to minimize the diff (preventing reflow in a paragraph on changes).

New packages / extensions
-------------------------

Using Python entry points it is easy to contribute extensions in separate packages.
To ease discoverability and ensure long term maintenance if individual maintainers move on it is encouraged to host the code in a repository under the `colcon` organization unit on GitHub.
Please open a ticket to either ask for the creation of a repository which you will have `admin` level access to or for moving an existing repository to this organization unit.

Use keyword in package metadata
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When creating a package containing ``colcon`` extensions please consider declaring a keyword to help discovering extensions through e.g. PyPI.
When using a ``setup.cfg`` file for the metadata of the package it is as simple as including these lines:

.. code-block:: ini

    [metadata]
    keywords = colcon
