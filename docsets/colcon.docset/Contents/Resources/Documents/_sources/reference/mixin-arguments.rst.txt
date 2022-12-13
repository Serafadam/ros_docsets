Mixin arguments
===============

Mixins can be used by several verbs to contribute command line arguments
defined in external files.

The following arguments are provided by the ``colcon-mixin`` package:

.. _mixin-args_mixin-files_arg:

\\--mixin-files [FILE [FILE ...]]
  Read additional mixin files and make the mixin names specified in them
  available in the ``--mixin`` argument.

.. _mixin-args_mixin_arg:

\\--mixin [mixin1 [mixin2 ...]]
  The names of mixins to be used.
  The list of mixin names and their command line arguments depends on which
  ones are available.
  To enumerate the available verb specific mixins and their command line
  arguments invoke ``colcon mixin show <verb>``.

  An example mixin provided in the `colcon-mixin-repository
  <https://github.com/colcon/colcon-mixin-repository/>`_ repository:

  * **debug**:

    - ``cmake-args``: ``['-DCMAKE_BUILD_TYPE=Debug']``

When multiple mixins are used they are interpreted in order with later mixin
values replacing or extending previous values.
In case of lists the items are being concatenated.
In all other cases the latter value replaces the former value.

.. warning::

    At the moment the logic concatenating lists has no semantic knowledge of
    the data.
    Therefore the joined list might not have the desired semantic meaning.
    E.g. for the following two lists:

    * ``cmake-args``: ``['-DCMAKE_C_FLAGS=-fPIC']``
    * ``cmake-args``: ``['-DCMAKE_C_FLAGS=-g']``

    the joined list will be just a concatenation:

    * ``cmake-args``: ``['-DCMAKE_C_FLAGS=-fPIC', '-DCMAKE_C_FLAGS=-g']``

    But passing these arguments to CMake would result in the latter value of
    ``CMAKE_C_FLAGS`` overwriting the former even though the user likely wanted
    both compiler options to be used.
