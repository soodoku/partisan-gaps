#### Overall organisation of Stata files
* `partisan-gaps.do` is the Master `do` file. This file will set up all dependencies, call the `do` file(s) for preparing and cleaning the data, and call the `do` files running the analyses. 

* Current setup is such that running `partisan-gaps.do` alone will reproduce all tables and figures.

* The [`log file`](partisan-gaps-log.txt) will document the log for `partisan-gaps.do`.

To `make` the Stata output, do
```console
make all
```
