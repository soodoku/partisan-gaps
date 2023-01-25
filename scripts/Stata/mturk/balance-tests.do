center age interest_1 vote_1 pid_strength_1, standardize inplace
qui tabulate educ, gen(d_educ)
local listofxvar female age hisla d_educ2 d_educ5 d_educ1 d_educ4 asian black white interest_1 vote_1 pid_strength_1

local conditions RW FSR 14k 24k
foreach condition in `conditions' {
	preserve
	* Retain only IPS (as base condition) and one of the other four (conditions)
	qui drop if (question_type!="`condition'") & (question_type!="IPS")
	gen tarm = (question_type=="`condition'") 	

	* Prep filepath to save to
	local filepath "../../data/turk/storespecs-baltest-`condition'-ips"
	cap erase `filepath'.dta

	* Do balance test for each xvar and save to filepath
	eststo clear 
	local i = 1
	foreach xvar of varlist `listofxvar' {  
		_dots `i++' 0
		qui reg tarm `xvar', vce(hc3) 
		qui storespecs `xvar', spec(`xvar') file(`filepath')
	}
	restore // to full data before dropping three conditions
}

