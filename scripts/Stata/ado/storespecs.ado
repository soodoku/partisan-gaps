version 13.1

cap program drop storespecs

program storespecs
syntax varlist(min=1 numeric), [SPEC_name(string) BInary DEDUPlicate] file(string)
	///////////////////////////////////////////////////////////////////////////////
	// Syntax: 
	// -------
	// 		storespecs varlist, spec_name(groups) file(filename)
	// MWE:
	// ----
	// 		sysuse auto.dta
	//		reg price weight length
	//		storespecs weight, spec_name(length) file(_file)
	//		reg price weight length mpg
	//		storespecs weight, spec_name(length mpg) file(_file)
	//
	// BS example:
	// -----------
	//		sysuse auto.dta
	// 		forval i = 1/5 {
	// 			bsample		
	//			reg price weight length
	//			storespecs weight, file(_file)
	//		}
	//
	// Remarks:
	// --------
	//		. If file does not exist, a new one will be created. BUT if file already
	//			exists, then it will be appended even if new addition is a duplicate
	//			of existing data. To deduplicate, use the 'deduplicate' option.
	//		
	//		. Deduplicate option ignores spec_id, and will re-generate an arbitrary
	//			running ID after dropping duplicates by specification groups:
	//				storespecs weight, spec_name(length mpg) dedup file(_file)
	//////////////////////////////////////////////////////////////////////////////	
	local n_varlist: word count `varlist'

	if `n_varlist'==1 {
		local var `varlist'
		local multivar 0
	}
	else if `n_varlist'>1 {
		local multivar 1
	}

	if "`binary'"!="" { /* if yes, add 1. prefix to correctly retrieve results */
		local estprefix = "1."
	}
	else {
		local estprefix ""
	}

	tempfile temp
	save "`temp'", replace

	cap use "`file'.dta", clear

	if _rc!=0 { /* File not found, Init empty dataset */
		clear
		gen int spec_id=.
		if `n_varlist'==1 {
			gen double beta=.
			gen double se=.
			gen double u95=.
			gen double l95=.
			gen double u90=.
			gen double l90=.			
		}
		else if `n_varlist'>1 { /* if more than 1 var, use var name as suffix */
			foreach var in `varlist' {
				gen double beta_`var'=.
				gen double se_`var'=.
				gen double u95_`var'=.
				gen double l95_`var'=.
				gen double u90_`var'=.
				gen double l90_`var'=.				
			}
		}		
	}

	local n = _N+1 
	set obs `n'    
	replace spec_id = `n' if _n==`n'

	if `n_varlist' == 1 { /* `var' macro already defined above */
		* retreive estimates
		replace beta=_b[`estprefix'`var'] if spec_id==`n'
		replace se=_se[`estprefix'`var']  if spec_id==`n'

		* compute bounds
		replace u95=beta+invt(e(df_r),0.975)*se if spec_id==`n'
		replace l95=beta-invt(e(df_r),0.975)*se if spec_id==`n'
		replace u90=beta+invt(e(df_r),0.95)*se  if spec_id==`n'
		replace l90=beta-invt(e(df_r),0.95)*se  if spec_id==`n'		
	}
	else if `n_varlist'> 1 { /* if more than 1 var, use var name as suffix */
		foreach var in `varlist' {
			* retreive estimates
			replace beta_`var'=_b[`estprefix'`var'] if spec_id==`n'
			replace se_`var'=_se[`estprefix'`var']  if spec_id==`n'

			* compute bounds
			replace u95_`var'=beta_`var'+invt(e(df_r),0.975)*se_`var' if spec_id==`n'
			replace l95_`var'=beta_`var'-invt(e(df_r),0.975)*se_`var' if spec_id==`n'
			replace u90_`var'=beta_`var'+invt(e(df_r),0.95)*se_`var'  if spec_id==`n'
			replace l90_`var'=beta_`var'-invt(e(df_r),0.95)*se_`var'  if spec_id==`n'		
		}
	}

	foreach group in `spec_name' {
		cap gen byte `group' = 1 if spec_id==`n'
		if _rc!=0 { /* error will only happen after the first time `group' is generated, every other time is error */
			replace `group' = 1 if spec_id==`n'
		}
	}

	if "`deduplicate'"!="" { /* remove duplicates. `spec_name' macro is actually a list of var to check duplicates for */
		duplicates drop `spec_name', force
		replace spec_id = _n
	}

	save "`file.dta'", replace
	use `temp', clear
end
