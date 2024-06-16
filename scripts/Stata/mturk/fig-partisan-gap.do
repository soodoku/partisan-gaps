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

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* MTurk results (Study 1)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**** Basic prep of data
import delimited `rootdir'/data/turk/mturk-recoded.csv
do ./mturk/preamble.do

grstyle init
grstyle set plain, 

eststo clear
foreach item of varlist $items avg {
	foreach arm in $arms {
		qui: reg `item' ib1.pid if (pid_str!="Independent") & (question_type=="`arm'"), vce(hc3)
		est store `item'_`arm'		
		* Store estimates for average of conditions for annotations later
		if "`item'"=="avg" {
			local beta_`arm' = round(_b[3.pid], 0.01)
			dis `beta_`arm''
		}
	}
}

/* In order that should appear
IDA = IPS
CUD = RW
FSR = FSR
IMC = 14k
CCD = 24k
*/

local AVG_MARKER_OPTS offset(0) mcolor(navy) mlcolor(black) mlwidth(vvvthin)
// coefplot (*_IPS) || (*_RW) || (*_FSR) || (*_14k) || (*_24k), ///
coefplot (*_IPS, offset(0)) (avg_IPS, `AVG_MARKER_OPTS') ///
	|| (*_RW, offset(0)) (avg_RW, `AVG_MARKER_OPTS') ///
	|| (*_FSR, offset(0)) (avg_FSR, `AVG_MARKER_OPTS') ///
	|| (*_14k, offset(0)) (avg_14k, `AVG_MARKER_OPTS'), /// 
	msymbol(s) ///
	mcolor(gs9) ///
	mlcolor(gs7) ///
	mlwidth(vvvthin) ///
	ciopts( color(gs10) ) ///
	keep(3.pid) ///
	asequation /// "set equation to model name or string" make the rows the models
	swapnames /// "swap coefficient names and equation names"
	subtitle("") /// Remove subtitles for now
	byopts(row(1)) /// Force results to be in one row (1xn)
	xline(0, lcolor(gs10) lpattern(dash) lwidth(medium)) ///
	xlabel(-.3(.3).6) ///
	xscale(range(-.2 .53)) ///
	plotregion(margin(zero) ) ///	
	plotregion(lcolor(black) margin(zero) lwidth(medthin)) /// draw box around columns
	graphregion(margin(zero)) ///
	ytick(none) ///	remove horizontal grids
	yscale(noline alt)  /// swap labels to RHS
	eqrename( ///
		birth_RW = "{bf:Obama birthplace}" ///
		birth_IPS = "{bf:Obama birthplace}" ///
		birth_FSR = "{bf:Obama birthplace}" ///
		birth_14k = "{bf:Obama birthplace}" ///
		religion_RW = "{bf:Obama religion}" ///                                                                                                   " ///
		religion_IPS = "{bf:Obama religion}" ///
		religion_FSR = "{bf:Obama religion}" ///
		religion_14k = "{bf:Obama religion}" ///
		illegal_RW = "{bf:ACA illegal}" ///
		illegal_IPS = "{bf:ACA illegal}" ///
		illegal_FSR = "{bf:ACA illegal}" ///
		illegal_14k = "{bf:ACA illegal}" ///
		death_RW = "{bf:ACA death panels}" ///
		death_IPS = "{bf:ACA death panels}" ///
		death_FSR = "{bf:ACA death panels}" ///
		death_14k = "{bf:ACA death panels}" ///
		increase_RW = "{bf:GW causes}" ///
		increase_IPS = "{bf:GW causes}" ///
		increase_FSR = "{bf:GW causes}" ///
		increase_14k = "{bf:GW causes}" ///
		science_RW = "{bf:GW scientists agree}" ///
		science_IPS = "{bf:GW scientists agree}" ///
		science_FSR = "{bf:GW scientists agree}" ///
		science_14k = "{bf:GW scientists agree}" ///
		fraud_RW = "{bf:Voter fraud}" ///
		fraud_IPS = "{bf:Voter fraud}" ///
		fraud_FSR = "{bf:Voter fraud}" ///
		fraud_14k = "{bf:Voter fraud}" ///
		mmr_RW = "{bf:MMR vaccine}" ///
		mmr_IPS = "{bf:MMR vaccine}" ///
		mmr_FSR = "{bf:MMR vaccine}" ///
		mmr_14k = "{bf:MMR vaccine}" ///
		deficit_RW = "{bf:Budget deficit}" ///
		deficit_IPS = "{bf:Budget deficit}" ///
		deficit_FSR = "{bf:Budget deficit}" ///
		deficit_14k = "{bf:Budget deficit}" ///
		avg_RW = "{bf:Average}" ///								
		avg_IPS = "{bf:Average}" ///								
		avg_FSR = "{bf:Average}" ///								
		avg_14k = "{bf:Average}" ///								
		) ///


* Add column titles	
addplot 1: , title("{bf:Condition 1}", size(medium)) norescaling
addplot 2: , title("{bf:Condition 2}", size(medium)) norescaling
addplot 3: , title("{bf:Condition 3}", size(medium)) norescaling
addplot 4: , title("{bf:Condition 4}", size(medium)) norescaling

* graph margin
gr_edit .style.editstyle margin(left) editcopy 
* plot margin
gr_edit .plotregion1.style.editstyle margin(left) editcopy
* Remove ylabel ticks
gr_edit .plotregion1.yaxis1[4].style.editstyle majorstyle(tickstyle(show_ticks(no))) editcopy
* Shift labels to left
gr_edit .plotregion1.move yaxis1[4] leftof 9 1

* reset margins back to zero to flush with new col of labels
gr_edit .style.editstyle margin(zero) editcopy 
gr_edit .plotregion1.style.editstyle margin(zero) editcopy

* Add annotes
local y_heigh_coord = 9.748674339250291
local annote_style angle(default) size(small) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy

gr_edit .plotregion1.plotregion1[1].AddTextBox added_text editor `y_heigh_coord' `beta_IPS'
gr_edit .plotregion1.plotregion1[1].added_text[1].style.editstyle `annote_style'
gr_edit .plotregion1.plotregion1[1].added_text[1].style.editstyle box_alignment(center) editcopy
gr_edit .plotregion1.plotregion1[1].added_text[1].text.Arrpush `beta_IPS'

gr_edit .plotregion1.plotregion1[2].AddTextBox added_text editor `y_heigh_coord' `beta_RW'
gr_edit .plotregion1.plotregion1[2].added_text[1].style.editstyle `annote_style'
gr_edit .plotregion1.plotregion1[2].added_text[1].style.editstyle box_alignment(center) editcopy
gr_edit .plotregion1.plotregion1[2].added_text[1].text.Arrpush `beta_RW'

gr_edit .plotregion1.plotregion1[3].AddTextBox added_text editor `y_heigh_coord' `beta_FSR'
gr_edit .plotregion1.plotregion1[3].added_text[1].style.editstyle `annote_style'
gr_edit .plotregion1.plotregion1[3].added_text[1].style.editstyle box_alignment(center) editcopy
gr_edit .plotregion1.plotregion1[3].added_text[1].text.Arrpush `beta_FSR'

gr_edit .plotregion1.plotregion1[4].AddTextBox added_text editor `y_heigh_coord' `beta_14k'
gr_edit .plotregion1.plotregion1[4].added_text[1].style.editstyle `annote_style'
gr_edit .plotregion1.plotregion1[4].added_text[1].style.editstyle box_alignment(center) editcopy
gr_edit .plotregion1.plotregion1[4].added_text[1].text.Arrpush `beta_14k'

gr_edit .legend.draw_view.setstyle, style(no)

graph export "$figsavedir/partisan-gap-by-item-arm.pdf", replace	
graph export "$figsavedir/partisan-gap-by-item-arm.png", replace	


* sort(, descending) /// sort by coeff size (by first column) 
* 	transform(* = min(max(@,-.25),.5)) /// truncate CI, 1st num is lower bound, 2nd num is upper bound
