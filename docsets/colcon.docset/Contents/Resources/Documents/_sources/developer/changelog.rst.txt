Changelog
=========

Most colcon repositories are hosted on GitHub and contain a single Python package.
The following describes the process used to provide a detailed changelog for each release.
The main goal is to keep the necessary effort minimal and reuse the information available in the GitHub tickets.

Milestone
---------

For each upcoming release a milestone is being created with the tentative version number as the title.
Every issue and pull request targeting that upcoming release should have that milestone set.
That allows to list all open / closed tickets for a specific milestone using the GitHub interface.

Release
-------

When making a release and tagging a new version the due date of the matching milestone should be edited to contain the date of the release.
Afterwards the milestone should be closed and a new milestone with the next tentative version number should be created.

Link
----

To make the changelog information easily accessible the package manifest should provide a link like this in the ``setup.cfg``:

.. code-block:: ini

    [metadata]
    project_urls =
        Changelog = https://github.com/colcon/<reponame>/milestones?direction=desc&sort=due_date&state=closed
