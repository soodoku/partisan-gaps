grstyle init
grstyle set plain, 

eststo clear
foreach item of varlist $items avg {
	foreach arm in $arms {
		qui: reg `item' ib1.pid if (pid_str!="Independent") & (question_type=="`arm'"), vce(hc3)
		est store `item'_`arm'		
	}

	// * For all arms together
	// qui: reg `item' ib1.pid if (pid_str!="Independent") 
	// est store `item'_all	
}


coefplot (*_RW) || (*_IPS) || (*_FSR) || (*_14k) || (*_24k), ///
	msymbol(s) ///
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
		birth_RW = "{bf:birth}" ///
		birth_IPS = "{bf:birth}" ///
		birth_FSR = "{bf:birth}" ///
		birth_14k = "{bf:birth}" ///
		birth_24k = "{bf:birth}" ///
		birth_all = "{bf:birth}" ///
		religion_RW = "{bf:religion}" ///                                                                                                   " ///
		religion_IPS = "{bf:religion}" ///
		religion_FSR = "{bf:religion}" ///
		religion_14k = "{bf:religion}" ///
		religion_24k = "{bf:religion}" ///
		religion_all = "{bf:religion}" ///
		illegal_RW = "{bf:illegal}" ///
		illegal_IPS = "{bf:illegal}" ///
		illegal_FSR = "{bf:illegal}" ///
		illegal_14k = "{bf:illegal}" ///
		illegal_24k = "{bf:illegal}" ///
		illegal_all = "{bf:illegal}" ///
		death_RW = "{bf:death}" ///
		death_IPS = "{bf:death}" ///
		death_FSR = "{bf:death}" ///
		death_14k = "{bf:death}" ///
		death_24k = "{bf:death}" ///
		death_all = "{bf:death}" ///
		increase_RW = "{bf:increase}" ///
		increase_IPS = "{bf:increase}" ///
		increase_FSR = "{bf:increase}" ///
		increase_14k = "{bf:increase}" ///
		increase_24k = "{bf:increase}" ///
		increase_all = "{bf:increase}" ///
		science_RW = "{bf:science}" ///
		science_IPS = "{bf:science}" ///
		science_FSR = "{bf:science}" ///
		science_14k = "{bf:science}" ///
		science_24k = "{bf:science}" ///
		science_all = "{bf:science}" ///
		fraud_RW = "{bf:fraud}" ///
		fraud_IPS = "{bf:fraud}" ///
		fraud_FSR = "{bf:fraud}" ///
		fraud_14k = "{bf:fraud}" ///
		fraud_24k = "{bf:fraud}" ///
		fraud_all = "{bf:fraud}" ///
		mmr_RW = "{bf:mmr}" ///
		mmr_IPS = "{bf:mmr}" ///
		mmr_FSR = "{bf:mmr}" ///
		mmr_14k = "{bf:mmr}" ///
		mmr_24k = "{bf:mmr}" ///
		mmr_all = "{bf:mmr}" ///
		deficit_RW = "{bf:deficit}" ///
		deficit_IPS = "{bf:deficit}" ///
		deficit_FSR = "{bf:deficit}" ///
		deficit_14k = "{bf:deficit}" ///
		deficit_24k = "{bf:deficit}" ///
		deficit_all = "{bf:deficit}" ///		
		avg_RW = "{bf:Average}" ///								
		avg_IPS = "{bf:Average}" ///								
		avg_FSR = "{bf:Average}" ///								
		avg_14k = "{bf:Average}" ///								
		avg_24k = "{bf:Average}" ///								
		avg_all = "{bf:Average}" ///								
		)

* Add column titles	
addplot 1: , title("{bf:RW}", size(med)) norescaling
addplot 2: , title("{bf:IPS}") norescaling
addplot 3: , title("{bf:FSR}") norescaling
addplot 4: , title("{bf:14k}") norescaling
addplot 5: , title("{bf:24k}") norescaling

* graph margin
gr_edit .style.editstyle margin(left) editcopy 
* plot margin
gr_edit .plotregion1.style.editstyle margin(left) editcopy
* Remove ylabel ticks
gr_edit .plotregion1.yaxis1[5].style.editstyle majorstyle(tickstyle(show_ticks(no))) editcopy
* Shift labels to left
gr_edit .plotregion1.move yaxis1[5] leftof 9 1

* reset margins back to zero to flush with new col of labels
gr_edit .style.editstyle margin(zero) editcopy 
gr_edit .plotregion1.style.editstyle margin(zero) editcopy


graph export ../../ms/figures/partisan-gap-by-item-arm.pdf, replace	


* sort(, descending) /// sort by coeff size (by first column) 
* 	transform(* = min(max(@,-.25),.5)) /// truncate CI, 1st num is lower bound, 2nd num is upper bound
