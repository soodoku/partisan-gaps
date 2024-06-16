
* -----------------------------------------------------------------------------
* Program Setup
* -----------------------------------------------------------------------------
cls 					// Clear results window
clear all               // Start with a clean slate
set more off            // Disable partitioned output
macro drop _all         // Clear all macros to avoid namespace conflicts
set linesize 120        // Line size limit to make output more readable, affects logs

local rootdir D:/partisan-gaps // for my convenience to set project root dir, comment out to avoid conflict
cd `rootdir'

cd scripts/Stata

cap log close
log using partisan-gaps-log.txt, replace text

version 13              // Still on version 13 :(

global figsavedir `rootdir'/figs
global tabsavedir `rootdir'/tabs
adopath ++ ./ado 		// Add path to ados

*** Setup dependencies
txt2macro stata-requirements.txt
setup "`r(mymacro)'"
* -----------------------------------------------------------------------------
tictoc tic

import delimited `rootdir'/data/turk/mturk-recoded.csv
do ./mturk/preamble.do


* Drop CCD (confidence coding/24k)
drop if survey == 2

* Reshape from wide to long to stack participant-item observations
foreach item of varlist $items {
	rename `item' item`item'
}
reshape long item, i(id) j(item_type, string)

drop if pid_str=="Independent"


local spec3 i.rep##i.survey##female
local spec6 `spec3' $demo

eststo clear
foreach i in 3 6 {
eststo: reghdfe item `spec`i'', absorb(item_type) vce(cluster id)
	estadd local items 9
	estadd local Nrespondents = e(N_clust1)
	local nobs: display %9.0fc `e(N)'
	estadd local itemFE "\multicolumn{1}{c}{Yes}"
	estadd local nobs "`nobs'"
	if `i' > 3 {
		estadd local demo "\multicolumn{1}{c}{Yes}"
	}
	else {
		estadd local demo "\multicolumn{1}{c}{.}"	
	}
}


#delimit;
esttab using $tabsavedir/mturk-reg-table-by-gender-fragment.tex, 
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )  
    collabels(, none)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.rep *.survey *female* _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(1.rep "Congenial"
			  5.survey "Condition 2"
			  3.survey "Condition 3"
			  1.survey "Condition 4"
			  // 2.survey "CCD"
			  1.female "Female"
		      1.rep#5.survey "Congenial $\times$ Cond. 2"
		      1.rep#3.survey "Congenial $\times$ Cond. 3"		
		      1.rep#1.survey "Congenial $\times$ Cond. 4"
		      1.rep#1.female "Congenial $\times$ Female"
		      5.survey#1.female "Cond. 2 $\times$ Female"
		      3.survey#1.female "Cond. 3 $\times$ Female"
		      1.survey#1.female "Cond. 4 $\times$ Female"
		      1.rep#5.survey#1.female "(Congenial $\times$ Cond. 2) $\times$ Female"
		      1.rep#3.survey#1.female "(Congenial $\times$ Cond. 3) $\times$ Female"
		      1.rep#1.survey#1.female "(Congenial $\times$ Cond. 4) $\times$ Female"
		)
	order(
		1.rep 5.survey 3.survey 1.survey 1.female
		1.rep#5.survey 1.rep#3.survey 1.rep#1.survey 1.rep#1.female
		5.survey#1.female 3.survey#1.female 1.survey#1.female
		1.rep#5.survey#1.female 1.rep#3.survey#1.female 1.rep#1.survey#1.female
	)
	scalar(
		"r2 R$^2$"
		"itemFE Survey item FE"
		"demo Demographic controls"
		"items Items"
		"Nrespondents Respondents"
		"nobs Respondent-items"
		) 
	alignment(D{.}{.}{-1})
	substitute(\_ _)
	fragment booktabs replace        
	;
#delimit cr	
