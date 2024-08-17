set more off
import delimited $rootdir/data/turk/mturk-recoded.csv, clear
do ./mturk/preamble.do

* Drop CCD (confidence coding/24k)
drop if survey == 2

* Reshape from wide to long to stack participant-item observations
foreach item of varlist $items {
	rename `item' item`item'
}
reshape long item, i(id) j(item_type, string)

drop if pid_str=="Independent"


local spec1 i.rep
local spec2 i.survey
local spec3 i.rep##i.survey
local spec4 `spec1' $demo
local spec5 `spec2' $demo
local spec6 `spec3' $demo

reghdfe item `spec6', absorb(item_type) vce(cluster id)

grstyle init
grstyle set plain, noextend


#delimit;
coefplot,
	keep(1.rep#*.survey)
	coeflabel(
		1.rep#5.survey="Congenial x Condition 2"
		1.rep#3.survey="Congenial x Condition 3"		
		1.rep#1.survey="Congenial x Condition 4"	
	)
	order(1.rep#5.survey 1.rep#3.survey 1.rep#1.survey)
	msize(vlarge)
	mcolor(gs5)
	mlwidth(vthin)
	mlcolor(navy)	
	ylabel(, noticks)
	grid(none)
	yscale(lcolor(white))
	xline(0, lcolor(navy) lpattern(dash) lwidth(medium) )
	levels(99 95)
	ciopts(color(gs7 gs9) )
	graphregion(color(white) margin(0 0 0 0) )
	plotregion(lcolor(white) margin(0 0 0 0) )
	xtitle(
		"Estimated difference in probability of correct response"
		"by experiment condition"
	)
	// ========================================
	// Annotate if significant
	mlabposition(1)
	mlabcolor(gs4)
	mlabel(
		cond(@pval<.0001, "p < .0001 ",
			"p = " + subinstr(string(@pval,"%5.4f"), "0.", ".",1)
		)
	)
;
#delimit cr
graph export $figsavedir/coefplot-mturk.pdf, replace
