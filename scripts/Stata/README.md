#### Overall organisation of Stata files
* `partisan-gaps.do` is the Master `do` file. This file will set up all dependencies, call the `do` file(s) for preparing and cleaning the data, and call the `do` files running the analyses. 

* Current setup is such that running `partisan-gaps.do` alone will reproduce all tables and figures.

* The [`log file`](partisan-gaps-log.txt) will document the log for `partisan-gaps.do`.

To `make` the Stata output, do
```console
make all
```

Two key lines of code may reqire changing:

* the [`local rootdir D:/partisan-gaps`](https://github.com/soodoku/partisan-gaps/blob/6087c4bcb5feac94057bdbe6dd5f6fdffd0249f2/scripts/Stata/partisan-gaps.do#L11) lie in the [`./partisan-gaps.do`](./partisan-gaps.do) for the local `root directory` of this repository
* the [`STATA_PATH="C:\Program Files (x86)\Stata13\StataMP-64"`](https://github.com/soodoku/partisan-gaps/blob/6087c4bcb5feac94057bdbe6dd5f6fdffd0249f2/scripts/Stata/Makefile#L3) line in the [`./Makefile`](./Makefile) for the local path to the `Stata` executable
