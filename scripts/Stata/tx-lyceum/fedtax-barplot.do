use "D:/partisan-gaps/data/tx_lyceum/Texas Lyceum 2012 Data.dta", clear
do ./tx-lyceum/preamble.do

global congguess fedtaxcongenial fedtaxuncongenial fedtaxcongenialguess fedtaxuncongenialguess
reg fedtaxup i.($congguess), vce(hc3)

/*
	coeflabel(
		fedtaxcongenial "Congenial"
		fedtaxuncongenial "Uncongenial"
		fedtaxcongenialguess "Congenial w/ guess"
		fedtaxuncongenialguess "Uncongenial w/ guess"	
	)
*/		     
mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 9] /* _cons */
local congenialcoef = coefmat[1,2]  /* 1.fedtaxcongenial */
local uncongenialcoef = coefmat[1,4]  /* 1.fedtaxuncongenial */
local congenialguesscoef = coefmat[1,6]  /* 1.fedtaxcongenialguess */
local uncongenialguesscoef = coefmat[1,8]  /* 1.fedtaxuncongenialguess */

// preserve
regsave
drop if coef==0

gen effect = `baseline' + coef if var!="_cons"
replace effect = `baseline' if var=="_cons"

* Construct CI
gen uci = effect + 1.96 * stderr
gen lci = effect - 1.96 * stderr
// replace uci = 0 if var=="_cons"
// replace lci = 0 if var=="_cons"

gen porder = 0 if var=="_cons"
replace porder = 1 if var=="1.fedtaxcongenial"
replace porder = 2 if var=="1.fedtaxuncongenial"
replace porder = 3 if var=="1.fedtaxcongenialguess"
replace porder = 4 if var=="1.fedtaxuncongenialguess"
sort porder


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
label define xlab 0 `""Neutral" """' 1 `""Congenial" """' 2 `""Uncongenial" """' 3 `""Congenial (w/ guess)" """'  
label values porder xlab

set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(medlarge) nogrid 
local YRANGE 0.(0.2).6
local BASELINE_XLIM = _N+.5
local CI_WIDTH medthick
local XLAB_SIZE medsmall
local BAR_OPTS 	 	color(gs7) fcolor(none) lwidth(thick)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#delimit;
twoway 	
		(bar effect porder if porder==0, `BAR_OPTS') 
		(bar effect porder if porder==1, `BAR_OPTS') 
		(bar effect porder if porder==2, `BAR_OPTS') 
		(bar effect porder if porder==3, `BAR_OPTS') 
		(bar effect porder if porder==4, `BAR_OPTS'
			xlabel(,val labsize(`XLAB_SIZE') )
			xtitle("")
		) 
		(rcap uci lci porder, 
			color(black)
			lwidth(`CI_WIDTH')
			legend(off)
			ylabel(`YRANGE', `YLAB_OPTS' ) 
			yscale(r(0 .63))
			xlabel(
				0 "Neutral" 
				1 "Congenial" 
				2 "Uncongenial" 
				3 "Congenial w/ guess" 
				4 "Uncongenial w/ guess", angle(25) labsize(`XLAB_SIZE') notick )
			xscale(noextend lcolor(none))
			graphregion(color(white) lc(white) lw(medium) margin(0 0 3 0)) 
			bgcolor(white)
			plotregion(margin(10 10 0 0))
			ytitle("Predicted proportion of correct" "responses by condition", size(medlarge))
		)		
	;
#delimit cr	
graph export $figsavedir/texas-fedtax-answerup-congenialcue.pdf, replace	
