
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

global races asian black others
local spec3 i.rep##i.survey##i.($races)
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
esttab using $tabsavedir/mturk-reg-table-by-race-fragment.tex,
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      // p (par([ ]) fmt(%9.3fc))
    )  
    collabels(, none)
	varwidth(50)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.rep *.survey *black* *others* *asian* _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(1.rep "Congenial"
			  5.survey "CUD"
			  3.survey "FSR"
			  1.survey "IMC"
			  1.black "Black"
			  1.asian "Asian"
			  1.others "Others"
		      1.rep#5.survey "Congenial $\times$ CUD"
		      1.rep#3.survey "Congenial $\times$ FSR"		
		      1.rep#1.survey "Congenial $\times$ IMC"
		      1.rep#1.asian "Congenial $\times$ Asian"
		      1.rep#1.black "Congenial $\times$ Black"
		      1.rep#1.others "Congenial $\times$ Others"
		      5.survey#1.asian "CUD $\times$ Asian"
		      3.survey#1.asian "FSR $\times$ Asian"
		      1.survey#1.asian "IMC $\times$ Asian"
		      5.survey#1.black "CUD $\times$ Black"
		      3.survey#1.black "FSR $\times$ Black"
		      1.survey#1.black "IMC $\times$ Black"		      
		      5.survey#1.others "CUD $\times$ Others"
		      3.survey#1.others "FSR $\times$ Others"
		      1.survey#1.others "IMC $\times$ Others"		
		      1.rep#5.survey#1.asian "(Congenial $\times$ CUD) $\times$ Asian"
		      1.rep#3.survey#1.asian "(Congenial $\times$ FSR) $\times$ Asian"
		      1.rep#1.survey#1.asian "(Congenial $\times$ IMC) $\times$ Asian"
		      1.rep#5.survey#1.black "(Congenial $\times$ CUD) $\times$ Black"
		      1.rep#3.survey#1.black "(Congenial $\times$ FSR) $\times$ Black"
		      1.rep#1.survey#1.black "(Congenial $\times$ IMC) $\times$ Black"
			  1.rep#5.survey#1.others "(Congenial $\times$ CUD) $\times$ Others"
		      1.rep#3.survey#1.others "(Congenial $\times$ FSR) $\times$ Others"
		      1.rep#1.survey#1.others "(Congenial $\times$ IMC) $\times$ Others"
	)
	order(
		1.rep 5.survey 3.survey 1.survey 1.asian 1.black 1.others
		1.rep#5.survey 1.rep#3.survey 1.rep#1.survey
		1.rep#1.asian 1.rep#1.black 1.rep#1.others
		5.survey#1.asian 5.survey#1.black 5.survey#1.others
		3.survey#1.asian 3.survey#1.black 3.survey#1.others
		1.survey#1.asian 1.survey#1.black 1.survey#1.others
		1.rep#5.survey#1.asian 1.rep#5.survey#1.black 1.rep#5.survey#1.others
		1.rep#3.survey#1.asian 1.rep#3.survey#1.black 1.rep#3.survey#1.others
		1.rep#1.survey#1.asian 1.rep#1.survey#1.black 1.rep#1.survey#1.others
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
