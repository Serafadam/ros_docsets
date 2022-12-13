``edit`` - Edit File
====================

The ``edit`` search and edit a file inside a package using command line.
It is provided by the ``colcon-ed`` package.

When a correct package name and file name is provided, it will open that
file with an editor. 

.. code-block:: bash

    $ colcon edit <package_name> <file_name>

.. note::

    To enable auto-complete, check out the 
    :doc:`installation guide <../../user/installation>`.

Hidden files and ``.pyc`` files are ignored. 
If multiple files under the same name are present, they will all be listed 
and you can type in the index number to select which file to edit.

By default, ``vim`` is the editor that will be used, but you can also use 
other editors by specifying ``$EDITOR`` environment variable to the ones
preferred. 
For example, to use **Visual Studio Code**, simply run

.. code-block:: bash

    $ export EDITOR=code


Command line arguments
----------------------

These common arguments can be used:

* :doc:`discovery <../discovery-arguments>` arguments
* :doc:`mixin <../mixin-arguments>` arguments

The following specific positional arguments are used:

.. _edit-verb_package-name_arg:

PKG_NAME
  Explicit package name to specify which package the file is in.

.. _edit-verb_file-name_arg:

FILE_NAME
  File name to specify which file to edit.
