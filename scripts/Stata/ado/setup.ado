cap program drop setup
program define setup
	args ssc_packages

	if "`ssc_packages'"!="" {
		dis "Installing ssc packages, please wait..."
		local i = 1
		// dis "`ssc_packages'"

		foreach pkg in `ssc_packages' {
			capture which `pkg'
			if _rc==111 { /* pkg not currently found */
				cap ssc install `pkg', replace

				if _rc==601 { /* can't find pkg in ssc */
					noisily _dots `i' 1
					local error_pkg `error_pkg' `pkg'
				}
				else { /* successful ssc install */
					noisily _dots `i' 0
				}
			}
			else { /* pkg already installed */
				noisily _dots `i' -1
			}
		local ++i
		}

		if "`error_pkg'"!="" {
			dis ""
			noisily dis "These packages failed to install: `error_pkg'"			
		}
	}
	else {
		noisily dis "No requirements stated..."
	}
end

// txt2macro stata-requirements.txt
// local requirements `r(mymacro)'
// setup "`requirements'"
