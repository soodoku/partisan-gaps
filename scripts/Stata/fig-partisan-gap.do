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
		birth_RW = "{bf:Obama birthplace}" ///
		birth_IPS = "{bf:Obama birthplace}" ///
		birth_FSR = "{bf:Obama birthplace}" ///
		birth_14k = "{bf:Obama birthplace}" ///
		birth_24k = "{bf:Obama birthplace}" ///
		birth_all = "{bf:Obama birthplace}" ///
		religion_RW = "{bf:Obama religion}" ///                                                                                                   " ///
		religion_IPS = "{bf:Obama religion}" ///
		religion_FSR = "{bf:Obama religion}" ///
		religion_14k = "{bf:Obama religion}" ///
		religion_24k = "{bf:Obama religion}" ///
		religion_all = "{bf:Obama religion}" ///
		illegal_RW = "{bf:ACA illegal}" ///
		illegal_IPS = "{bf:ACA illegal}" ///
		illegal_FSR = "{bf:ACA illegal}" ///
		illegal_14k = "{bf:ACA illegal}" ///
		illegal_24k = "{bf:ACA illegal}" ///
		illegal_all = "{bf:ACA illegal}" ///
		death_RW = "{bf:ACA death panels}" ///
		death_IPS = "{bf:ACA death panels}" ///
		death_FSR = "{bf:ACA death panels}" ///
		death_14k = "{bf:ACA death panels}" ///
		death_24k = "{bf:ACA death panels}" ///
		death_all = "{bf:ACA death panels}" ///
		increase_RW = "{bf:GW causes}" ///
		increase_IPS = "{bf:GW causes}" ///
		increase_FSR = "{bf:GW causes}" ///
		increase_14k = "{bf:GW causes}" ///
		increase_24k = "{bf:GW causes}" ///
		increase_all = "{bf:GW causes}" ///
		science_RW = "{bf:GW scientists agree}" ///
		science_IPS = "{bf:GW scientists agree}" ///
		science_FSR = "{bf:GW scientists agree}" ///
		science_14k = "{bf:GW scientists agree}" ///
		science_24k = "{bf:GW scientists agree}" ///
		science_all = "{bf:GW scientists agree}" ///
		fraud_RW = "{bf:Voter fraud}" ///
		fraud_IPS = "{bf:Voter fraud}" ///
		fraud_FSR = "{bf:Voter fraud}" ///
		fraud_14k = "{bf:Voter fraud}" ///
		fraud_24k = "{bf:Voter fraud}" ///
		fraud_all = "{bf:Voter fraud}" ///
		mmr_RW = "{bf:MMR vaccine}" ///
		mmr_IPS = "{bf:MMR vaccine}" ///
		mmr_FSR = "{bf:MMR vaccine}" ///
		mmr_14k = "{bf:MMR vaccine}" ///
		mmr_24k = "{bf:MMR vaccine}" ///
		mmr_all = "{bf:MMR vaccine}" ///
		deficit_RW = "{bf:Budget deficit}" ///
		deficit_IPS = "{bf:Budget deficit}" ///
		deficit_FSR = "{bf:Budget deficit}" ///
		deficit_14k = "{bf:Budget deficit}" ///
		deficit_24k = "{bf:Budget deficit}" ///
		deficit_all = "{bf:Budget deficit}" ///		
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


graph export ../../figs/partisan-gap-by-item-arm.pdf, replace	


* sort(, descending) /// sort by coeff size (by first column) 
* 	transform(* = min(max(@,-.25),.5)) /// truncate CI, 1st num is lower bound, 2nd num is upper bound
