#!/usr/bin/env python
# Obtained from https://github.com/vim-syntastic/syntastic project.

from __future__ import print_function
from sys import argv, exit, stdin


if len(argv) != 2:
    exit(1)

try:
    compile(stdin.read(), argv[1], 'exec', 0, 1)
except SyntaxError as err:
    print('%s:%s:%s: %s' % (err.filename, err.lineno, err.offset, err.msg))
