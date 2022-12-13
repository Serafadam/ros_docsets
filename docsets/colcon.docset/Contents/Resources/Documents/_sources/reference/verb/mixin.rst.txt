``mixin`` - Manage mixins
=========================

The ``mixin`` verb offers multiple subverbs to manage the
registration, introspection and update of mixin repositories.

mixin ``add``
----------------

Add the URL of a mixin repository.
Afterwards the mixin information needs to be fetched at least once by invoking
``colcon mixin update <name>``.

name
  The name to identify the to-be-added repository.

url
  The URL pointing to a yaml file containing an index enumerating ``.mixin``
  files.

mixin ``list``
-----------------

Enumerate the name and URL of the registered mixin repositories as well as
their mixin files.

[name]
  An optional name to only enumerate the mixin files of a specific repository.

mixin ``remove``
-------------------

Remove the URL of a mixin repository and all its mixin files.

name
  The name to identify the to-be-removed repository.

mixin ``update``
-------------------

Fetch the mixin files from a specific repository.
The output indicates which mixin files have been added, updated, are
unchanged or are obsolete.
Obsolete mixin files are not deleted but renamed (changing the ``.mixin``
extension to ``.obsolete``).

[name]
  An optional name to only update the mixin files of a specific repository.
