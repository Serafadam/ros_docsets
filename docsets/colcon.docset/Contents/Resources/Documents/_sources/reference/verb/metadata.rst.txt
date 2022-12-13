``metadata`` - Manage metadata
==============================

The ``metadata`` verb offers multiple subverbs to manage the
registration, introspection and update of metadata repositories.

metadata ``add``
----------------

Add the URL of a metadata repository.
Afterwards, the metadata information needs to be fetched at least once by
invoking ``colcon metadata update <name>``.

name
  The name to identify the to-be-added repository.

url
  The URL pointing to a yaml file containing an index enumerating ``.meta``
  files.

metadata ``list``
-----------------

Enumerate the name and URL of the registered metadata repositories as well as
their metadata files.

[name]
  An optional name to only enumerate the metadata files of a specific
  repository.

metadata ``remove``
-------------------

Remove the URL of a metadata repository and all its metadata files.

name
  The name to identify the to-be-removed repository.

metadata ``update``
-------------------

Fetch the metadata files from a specific repository.
The output indicates which metadata files have been added, updated, are
unchanged or are obsolete.
Obsolete metadata files are not deleted but renamed (changing the ``.meta``
extension to ``.obsolete``).

[name]
  An optional name to only update the metadata files of a specific repository.
