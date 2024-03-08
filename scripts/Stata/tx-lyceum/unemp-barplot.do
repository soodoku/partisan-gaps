use "D:/partisan-gaps/data/tx_lyceum/Texas Lyceum 2012 Data.dta", clear
do ./tx-lyceum/preamble.do


qui reg unempup i.unempcongenial i.unempuncongenial, vce(hc3)

mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 5] /* _cons */
local congcoef = coefmat[1,2]  /* 1.unempcongenial */
local uncongcoef = coefmat[1,4]  /* 1.unempuncongenial */

preserve
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
replace porder = 1 if var=="1.unempuncongenial"
replace porder = 2 if var=="1.unempcongenial"
sort porder


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
label define xlab 0 `""Neutral" """' 1 `""Uncongenial" """' 2 `""Congenial" """' 
label values porder xlab

set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(large) nogrid 
local YRANGE 0.(0.2).6
local BASELINE_XLIM = _N+.5
local CI_WIDTH medthick
local XLAB_SIZE large
local BAR_OPTS 	 	color(gs7) fcolor(none) lwidth(thick)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#delimit;
twoway 	
		(bar effect porder if porder==0, `BAR_OPTS') 
		(bar effect porder if porder==1, `BAR_OPTS') 
		(bar effect porder if porder==2, `BAR_OPTS'
			xlabel(,val labsize(`XLAB_SIZE') )
			xtitle("")
		) 
		(rcap uci lci porder, 
			color(black)
			lwidth(`CI_WIDTH')
			legend(off)
			ylabel(`YRANGE', `YLAB_OPTS' ) 
			yscale(r(0 .63))
			xlabel(0 1 2,val labsize(`XLAB_SIZE') noticks)
			xscale(noextend lcolor(none))
			graphregion(color(white) lc(white) lw(medium) margin(0 0 3 0)) 
			bgcolor(white)
			plotregion(margin(25 25 0 0))
		)		
	;
#delimit cr	
graph export $figsavedir/texas-unemp-congenialcue.pdf, replace	
restore
