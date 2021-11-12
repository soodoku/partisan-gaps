cd D:/partisan_gaps // for my convenience to set project root dir, comment out to avoid conflict


cd scripts/Stata
* -----------------------------------------------------------------------------
* Program Setup
* -----------------------------------------------------------------------------
cap log close
log using logs/log.txt, replace text

cls 					// Clear results window
version 13              // Still on version 13 :(
clear all               // Start with a clean slate
set more off            // Disable partitioned output
macro drop _all         // Clear all macros to avoid namespace conflicts
set linesize 120        // Line size limit to make output more readable, affects logs
// local figsavedir ./out/figures	// Savepath for figures
// local tabsavedir ./out/tables 	// Savepath for tables
// sysdir set PERSONAL analysis/utilities // Add path to my ados
* -----------------------------------------------------------------------------

import delimited D:/partisan_gaps/data/mturk-recoded.csv

*------------------------------------------------------------------------------
do preamble.do

drop if (question_type!="14k") & (question_type!="RW")
gen tarm = (question_type=="14k") 

center age, standardize inplace

eststo: reg gender i.tarm, vce(hc3) 
eststo: reg age i.tarm, vce(hc3) 

tabulate educ, gen(d_educ)
forvalues i = 1/5 {
	eststo: reg d_educ`i' i.tarm, vce(hc3)
}

eststo: reg hisla i.tarm, vce(hc3) 

tab race, gen(d_race)
replace d_race6 = strmatch(race_str, "White*")
forvalues i = 1/6 {
	eststo: reg d_race`i' i.tarm, vce(hc3)
}


grstyle init
grstyle set plain, noextend

#delimit; 
coefplot *,
	mcolor(black)
	keep(1.tarm)
	asequation /// "set equation to model name or string" make the rows the models
	swapnames /// "swap coefficient names and equation names"
	xline(0, lcolor(gs10) lpattern(dash) lwidth(medium)) ///
	yscale(noline alt)

;


a 
coefplot (e_*), ///

	asequation /// "set equation to model name or string" make the rows the models
	swapnames /// "swap coefficient names and equation names"


a
do fig-avg-partisan-gap.do

a

a
do fig-partisan-gap.do

log close
