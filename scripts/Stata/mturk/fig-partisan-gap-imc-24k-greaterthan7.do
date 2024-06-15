grstyle init
grstyle set plain, 

eststo clear
foreach item of varlist $items avg {
	foreach arm in 14k 24k {
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
IDA = 14k
CUD = RW
FSR = FSR
IMC = 14k
CCD = 24k
*/

local AVG_MARKER_OPTS offset(0) mcolor(navy) mlcolor(black) mlwidth(vvvthin)
coefplot ///
	(*_14k) (avg_14k, `AVG_MARKER_OPTS') ///
	|| (*_24k) (avg_24k, `AVG_MARKER_OPTS'), /// 
	msymbol(s) ///
	mcolor(gs8) ///
	mlcolor(gs6) ///
	mlwidth(vvvthin) ///
	ciopts( color(gs9) ) ///	
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
		birth_14k = "{bf:Obama birthplace}" ///
		religion_14k = "{bf:Obama religion}" ///
		illegal_14k = "{bf:ACA illegal}" ///
		death_14k = "{bf:ACA death panels}" ///
		increase_14k = "{bf:GW causes}" ///
		science_14k = "{bf:GW scientists agree}" ///
		fraud_14k = "{bf:Voter fraud}" ///
		mmr_14k = "{bf:MMR vaccine}" ///
		deficit_14k = "{bf:Budget deficit}" ///
		avg_14k = "{bf:Average}" ///		
		birth_24k = "{bf:Obama birthplace}" ///
		religion_24k = "{bf:Obama religion}" ///
		illegal_24k = "{bf:ACA illegal}" ///
		death_24k = "{bf:ACA death panels}" ///
		increase_24k = "{bf:GW causes}" ///
		science_24k = "{bf:GW scientists agree}" ///
		fraud_24k = "{bf:Voter fraud}" ///
		mmr_24k = "{bf:MMR vaccine}" ///
		deficit_24k = "{bf:Budget deficit}" ///
		avg_24k = "{bf:Average}" ///								
		)


* Add column titles	
addplot 1: , title("{bf:Condition 4}" "{bf:(DK + NSP + GD + NNI)}", size(medsmall)) norescaling
addplot 2: , title(" " "{bf:Confidence Coding Design (CCD)}", size(medsmall)) norescaling

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


* Add annotes
local y_heigh_coord = 9.748674339250291
local annote_style angle(default) size(small) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy

gr_edit .plotregion1.plotregion1[1].AddTextBox added_text editor `y_heigh_coord' `beta_14k'
gr_edit .plotregion1.plotregion1[1].added_text[1].style.editstyle `annote_style'
gr_edit .plotregion1.plotregion1[1].added_text[1].style.editstyle box_alignment(center) editcopy
gr_edit .plotregion1.plotregion1[1].added_text[1].text.Arrpush `beta_14k'

gr_edit .plotregion1.plotregion1[2].AddTextBox added_text editor `y_heigh_coord' `beta_24k'
gr_edit .plotregion1.plotregion1[2].added_text[1].style.editstyle `annote_style'
gr_edit .plotregion1.plotregion1[2].added_text[1].style.editstyle box_alignment(center) editcopy
gr_edit .plotregion1.plotregion1[2].added_text[1].text.Arrpush `beta_24k'

gr_edit .legend.draw_view.setstyle, style(no)

graph export "$figsavedir/partisan-gap-by-item-arm-14k-24k-greaterthan7.pdf", replace	

