version 13

cap program drop tictoc
program define tictoc
	args switch ix offbeep

	if !inlist("`switch'", "tic", "toc", "on", "off") {
		noisily dis in red "Please choose 'on' or 'off' as parameter"
		exit 42
	}

	if "`ix'"=="" {
		local ix 42
	}

	if `ix' > 100 {
		noisily dis in red "Please choose an integer, 1 through 100"
		exit
	}

	if ("`switch'"=="tic") | ("`switch'"=="on") {
		timer clear `ix'
		timer on `ix'
		noisily dis as result "{hline}"
		noisily dis as text "----------- Time log -----------"
		noisily dis in green "Start time: $S_DATE $S_TIME"
		noisily dis as result "{hline}"
	}
	else if ("`switch'"=="toc") | ("`switch'"=="off") {
		timer off `ix'
		qui timer list `ix'
		cap { 
			local seconds = `r(t`ix')'
			local minutes = `seconds'/60
			local hours = `minutes'/60		
		}
		if _rc!=0 {
			noisily dis in red "Turn on timeit first. "
			exit 42
		}

		noisily dis as result "{hline}"
		noisily dis as text "----------- Time log -----------"

		local current_time = clock("$S_DATE $S_TIME", "DMY hms" )/1000 
		local current_unix_time = `current_time' - clock("1 Jan 1970", "DMY" )/1000 
		local start_unix_time = `current_unix_time' - `seconds'
		local start_time =  `start_unix_time'*1000 + mdyhms(1,1,1970,0,0,0)
		noisily dis "Start time:", _continue
		noisily dis %tcdd_Mon_CCYY_HH:MM:SS `start_time'
		noisily dis in green "End time: $S_DATE $S_TIME"

		foreach time in seconds minutes hours {
			noisily dis as text "Elapsed `time':", _continue
			if "`time'"=="hours" {
				noisily dis as result %9.0g round(``time'',.01)				
			}
			else {
				noisily dis as result %9.0g round(``time'')								
			}
		}
		noisily dis as result "{hline}"
	}

	if ("`switch'"=="toc") |  ("`switch'"=="off"){ 
		if "`offbeep'"=="" beep
	}
end

// tictoc tic
// sleep 3000
// tictoc toc
