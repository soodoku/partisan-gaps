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
global close_relscore (response_type=="closed" | response_type=="relscore_c_10")


eststo clear
foreach arm in Closed RL {
	foreach q_item in `q_items' {
		reg responses i.congenial if survey_str=="`arm'" & q_item == "`q_item'" & `close_relscore', cluster(respondent) 
		est store `q_item'_`arm'
		local beta_`q_item'_`arm' = round(_b[1.congenial], 0.01)	
	}
}

grstyle init
grstyle set plain

coefplot (*_Closed) || (*_RL), /// 
	msymbol(s) ///
	keep(1.congenial) ///
	asequation /// "set equation to model name or string" make the rows the models
	swapnames /// "swap coefficient names and equation names"
	subtitle("") /// Remove subtitles for now
	byopts(row(1)) /// Force results to be in one row (1xn)
	xline(0, lcolor(gs10) lpattern(dash) lwidth(medium)) ///
	xlabel(-.1(.1).2, format(%2.1f)) ///
	xscale(range(-.12 .22)) ///
	plotregion(lcolor(black) margin(zero) lwidth(medthin)) /// draw box around columns
	graphregion(color(white) margin(zero)) ///
	ytick(none) ///	remove horizontal grids
	yscale(noline alt)  /// swap labels to RHS
	eqrename( ///
		aca_Closed = "{bf:Affordable Care Act}" ///
		aca_RL = "{bf:Affordable Care Act}" ///
		aca2_Closed = "{bf:Affordable Care Act 2}" ///
		aca2_RL = "{bf:Affordable Care Act 2}" ///		
		gg_Closed = "{bf:Greenhouse Gases}" ///
		gg_RL = "{bf:Greenhouse Gases}" ///	
		dt_Closed = "{bf:Donald Trump}" ///
		dt_RL = "{bf:Donald Trump}" ///					
		) ///
	mlabel format(%4.3f) mlabposition(12)

* Add column titles	
addplot 1: , title("{bf:Multiple Choice}", size(medsmall)) norescaling
addplot 2: , title("{bf:Relative Scoring (RS)}", size(medsmall)) norescaling

* graph margin
gr_edit .style.editstyle margin(left) editcopy 
* plot margin
gr_edit .plotregion1.style.editstyle margin(left) editcopy
* Remove ylabel ticks
gr_edit .plotregion1.yaxis1[2].style.editstyle majorstyle(tickstyle(show_ticks(no))) editcopy
* Shift labels to left
gr_edit .plotregion1.move yaxis1[2] leftof 9 1

* reset margins back to zero to flush with new col of labels
gr_edit .style.editstyle margin(zero) editcopy 
gr_edit .plotregion1.style.editstyle margin(zero) editcopy

graph export $figsavedir/mturkhk-partisan-gap-by-item-arm.pdf, replace	
