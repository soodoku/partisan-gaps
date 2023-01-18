grstyle init
grstyle set plain, 

preserve
replace question_type = "mc" if question_type!="24k"

eststo clear
foreach item of varlist $items avg {
	foreach arm in mc 24k {
		qui: reg `item' ib1.pid if (pid_str!="Independent") & (question_type=="`arm'"), vce(hc3)
		est store `item'_`arm'		
		* Store estimates for average of conditions for annotations later
		if "`item'"=="avg" {
			local beta_`arm' = round(_b[3.pid], 0.01)
			dis `beta_`arm''
		}
	}
}
restore
/* In order that should appear
IDA = IPS
CUD = RW
FSR = FSR
IMC = 14k
CCD = 24k
*/


coefplot (*_mc) || (*_24k), /// 
	msymbol(s) ///
	keep(3.pid) ///
	asequation /// "set equation to model name or string" make the rows the models
	swapnames /// "swap coefficient names and equation names"
	subtitle("") /// Remove subtitles for now
	byopts(row(1)) /// Force results to be in one row (1xn)
	xline(0, lcolor(gs10) lpattern(dash) lwidth(medium)) ///
	xlabel(-.3(.3).6) ///
	xscale(range(-.31 .61)) ///
	plotregion(margin(zero) ) ///	
	plotregion(lcolor(black) margin(zero) lwidth(medthin)) /// draw box around columns
	graphregion(margin(zero)) ///
	ytick(none) ///	remove horizontal grids
	yscale(noline alt)  /// swap labels to RHS
	eqrename( ///
		birth_mc = "{bf:Obama birthplace}" ///
		religion_mc = "{bf:Obama religion}" ///
		illegal_mc = "{bf:ACA illegal}" ///
		death_mc = "{bf:ACA death panels}" ///
		increase_mc = "{bf:GW causes}" ///
		science_mc = "{bf:GW scientists agree}" ///
		fraud_mc = "{bf:Voter fraud}" ///
		mmr_mc = "{bf:MMR vaccine}" ///
		deficit_mc = "{bf:Budget deficit}" ///
		avg_mc = "{bf:Average}" ///		
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
addplot 1: , title("{bf:Multiple Choices}" "{bf:(IDA, CUD, FSR, IMC)}", size(medsmall)) norescaling
addplot 2: , title("{bf:Confidence Coding Design}" "{bf:(CCD)}", size(medsmall)) norescaling

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

gr_edit .plotregion1.plotregion1[1].AddTextBox added_text editor `y_heigh_coord' `beta_mc'
gr_edit .plotregion1.plotregion1[1].added_text[1].style.editstyle `annote_style'
gr_edit .plotregion1.plotregion1[1].added_text[1].style.editstyle box_alignment(center) editcopy
gr_edit .plotregion1.plotregion1[1].added_text[1].text.Arrpush `beta_mc'

gr_edit .plotregion1.plotregion1[2].AddTextBox added_text editor `y_heigh_coord' `beta_24k'
gr_edit .plotregion1.plotregion1[2].added_text[1].style.editstyle `annote_style'
gr_edit .plotregion1.plotregion1[2].added_text[1].style.editstyle box_alignment(center) editcopy
gr_edit .plotregion1.plotregion1[2].added_text[1].text.Arrpush `beta_24k'


graph export "$figsavedir/partisan-gap-by-item-arm-mc-24k.pdf", replace	

