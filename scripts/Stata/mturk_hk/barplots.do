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

**** Basic prep of data
import delimited ../../data/mturk_hk/mturk_hk_relative_scoring_MC.csv, clear

rename responses responses_str
gen responses = (responses_str=="1")
replace responses = . if responses_str=="NA"

rename congenial congenial_str
gen congenial = (congenial_str=="1")
replace congenial = . if congenial_str=="NA"

rename survey survey_str
encode survey_str, gen(survey)

local q_items aca aca2 gg dt
local close_relscore (response_type=="closed" | response_type=="relscore_c_10")

grstyle init
grstyle set plain, nogrid noextend horizontal

graph drop _all
foreach q_item in `q_items' {
	reg responses i.congenial##i.survey if q_item == "`q_item'" & `close_relscore', cluster(respondent) 

	margins survey#congenial, post
	#delimit;
	coefplot,
		keep(*1.congenial*)
		recast(bar)
		vertical
		color(gs7) fcolor(none) lwidth(thick)
		ciopts(recast(rcap))
		xlabel(1 "MC" 2 "CCD",val noticks)
		xscale( lc(none))
		graphregion(color(white) lc(white) lw(medium) margin(0 0 0 2)) 
		plotregion(margin(30 30 0 0))
		name(`q_item')
	;
	#delimit cr
	graph export $figsavedir/relative_score_`q_item'.pdf, replace	
}


// * Barplot for all
// qui reghdfe responses congenial##survey if `close_relscore', absorb(q_item) cluster(respondent) 

// mat coefmat = e(b)
// mat list coefmat
// local baseline = coefmat[1, 2] /* 1.rep */

// preserve
// regsave
// drop if var=="_cons"
// drop if var=="2.survey"
// drop if strpos(var, "0b")  // Drop base variables
// drop if strpos(var, "1b.survey") // Drop base variables

// * Gen coef for plotting (add estimates back to baseline)
// gen est = coef
// label var est "Original reg estimate (before adding back to baseline)"
// replace coef = `baseline' + coef if var!="1.congenial"

// * Construct CI
// gen uci = coef + 1.96 * stderr
// gen lci = coef - 1.96 * stderr
// replace uci = 0 if var=="_cons"
// replace lci = 0 if var=="_cons"

// gen porder = _n
// label define xlab 1 "MC" 2 "RS"
// label values porder xlab

// *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// * Graph settings
// set scheme s2mono
// local YLAB_OPTS angle(horizontal) labsize(large) nogrid
// local YRANGE 0(0.05).2
// local BASELINE_XLIM = _N+.5
// local CI_WIDTH medthick
// local XLAB_SIZE large
// local BAR_OPTS 	 	 color(gs7) fcolor(none) lwidth(thick)
// *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// #delimit;
// 	twoway 	
// 			(bar coef porder if porder==1, `BAR_OPTS') 
// 			(bar coef porder if porder==2, `BAR_OPTS'
// 				xlabel(,val labsize(`XLAB_SIZE') )
// 			) 
// 			(rcap uci lci porder if porder!=1, 
// 				color(gs5)
// 				lwidth(`CI_WIDTH') 
// 				legend(off)
// 				ylabel(`YRANGE', `YLAB_OPTS' ) 
// 				xlabel(, notick)
// 				yscale(r(0 .21))
// 				xscale(noextend lcolor(none))
// 				graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
// 				bgcolor(white)
// 				plotregion(margin(30 30 0 0))
// 			)		
// 			(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
// 				xlabel(1 2)
// 				recast(line) color(black) lpattern(dash)
// 				name(all)
// 			)
// 		;
// 	#delimit cr		
// restore	
// graph export $figsavedir/relative_score.pdf, replace	
