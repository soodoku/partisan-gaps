set more off
import delimited $rootdir/data/turk/mturk-recoded.csv, clear
do ./mturk/preamble.do

* Reshape from wide to long to stack participant-item observations
foreach item of varlist $items {
	rename `item' item`item'
}
reshape long item, i(id) j(item_type, string)

drop if pid_str=="Independent"

gen ccd = (survey==2)  /* 2.survey = 24k */
label var ccd "=1 if 24k condition (confidence scoring condition)"
/*
================================================
* Confidence coding vs all four other conditions
================================================
*/ 
eststo clear
* Regressions for each of nine survey questions
foreach item_type in $items {
	eststo: reg item i.rep##i.ccd if item_type=="`item_type'", vce(cluster id)
		estadd local itemFE "\multicolumn{1}{c}{No}"
		estadd local items 1
		estadd local Nrespondents = "\multicolumn{1}{c}{`e(N_clust)'}"
		local nobs: display %9.0fc `e(N)'
		estadd local nobs "\multicolumn{1}{c}{`nobs'}"
}
* Regression for the pooled survey questions
eststo: reghdfe item i.rep##i.ccd, absorb(item_type) vce(cluster id)
	estadd local itemFE "\multicolumn{1}{c}{Yes}"
	estadd local items 9
	estadd local Nrespondents = "\multicolumn{1}{c}{`e(N_clust)'}"
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"

* Store LaTeX fragment
#delimit;
esttab using $tabsavedir/confidence-scoring-study1-fragment.tex, 
	keep(1.rep 1.ccd 1.rep#1.ccd _cons)
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )  
    collabels(, none)
	varwidth(15)
	modelwidth(6)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	obslast
	label
	nobase 	
	noobs
	nomtitle	
	coeflabel(
		1.rep "Congenial"
		1.ccd "Relative scoring (RL)"
		1.rep#1.ccd "Congenial $\times$ RL"
		_cons "Constant"
		)	
	scalar(
		"r2 R$^2$" 
		"itemFE Survey item FE"
		"items Items"
		"Nrespondents Respondents"
		"nobs Respondent-items"
		) 	
	alignment(D{.}{.}{-1})
	substitute(\_ _)
	fragment booktabs replace        
	;
#delimit cr	


/*
========================================================
* Confidence coding vs each of the four other conditions
========================================================
*/
foreach ix_survey in 1 3 4 5 {
	* Name the subgroups for file naming later
	if `ix_survey'==1 {
		local subname = "imc-14k"
	}
	else if  `ix_survey'==3 {
		local subname = "fsr-fsr"
	}
	else if  `ix_survey'==4 {
		local subname = "ida-ips"
	}	
	else if  `ix_survey'==5 {
		local subname = "cud-rw"
	}	
	preserve
	drop if (survey!=2) & (survey!=`ix_survey')
	
	* Regressions for each of nine survey questions
	eststo clear
	foreach item_type in $items {
		eststo: reg item i.rep##i.ccd if item_type=="`item_type'", vce(cluster id)
			estadd local itemFE "\multicolumn{1}{c}{No}"
			estadd local items 1
			estadd local Nrespondents = "\multicolumn{1}{c}{`e(N_clust)'}"
			local nobs: display %9.0fc `e(N)'
			estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	}
	* Regression for the pooled survey questions
	eststo: reghdfe item i.rep##i.ccd, absorb(item_type) vce(cluster id)
		estadd local itemFE "\multicolumn{1}{c}{Yes}"
		estadd local items 9
		estadd local Nrespondents = "\multicolumn{1}{c}{`e(N_clust)'}"
		local nobs: display %9.0fc `e(N)'
		estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	restore

	* Store LaTeX fragment
	#delimit;
	esttab using $tabsavedir/confidence-scoring-study1-ccd-`subname'-fragment.tex, 
		keep(1.rep 1.ccd 1.rep#1.ccd _cons)
		cell(
	      b (fmt(%9.3fc) star) 
	      se(par fmt(%9.3fc))
	      p (par([ ]) fmt(%9.3fc))
	    )  
	    collabels(, none)
		varwidth(15)
		modelwidth(6)	
		star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
		obslast
		label
		nobase 	
		noobs
		nomtitle	
		coeflabel(
			1.rep "Congenial"
			1.ccd "Relative scoring (RL)"
			1.rep#1.ccd "Congenial $\times$ RL"
			_cons "Constant"
			)	
		scalar(
			"r2 R$^2$" 
			"itemFE Survey item FE"
			"items Items"
			"Nrespondents Respondents"
			"nobs Respondent-items"
			) 	
		alignment(D{.}{.}{-1})
		substitute(\_ _)
		fragment booktabs replace        
		;
	#delimit cr	
}
