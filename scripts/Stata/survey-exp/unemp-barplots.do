qui reg unempup i.congenialcue, vce(hc3)

mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 3] /* _cons */
local repcoef = coefmat[1,2]  /* 1.congenialcue */

preserve
regsave
drop if coef==0

gen effect = `baseline' + coef if var!="_cons"
replace effect = `baseline' if var=="_cons"

* Construct CI
gen uci = effect + 1.96 * stderr
gen lci = effect - 1.96 * stderr
replace uci = 0 if var=="_cons"
replace lci = 0 if var=="_cons"

gen porder = 0 if var=="_cons"
replace porder = 1 if var=="1.congenialcue"
sort porder

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
label define xlab 0 Uncongenial 1 Congenial
label values porder xlab

set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(large) nogrid 
local YRANGE 0.(0.2).8
local BASELINE_XLIM = _N+.5
local CI_WIDTH medthick
local XLAB_SIZE large
local BAR_OPTS 	 	color(gs7) fcolor(none) lwidth(thick)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#delimit;
twoway 	
		(bar effect porder if porder==0, `BAR_OPTS') 
		(bar effect porder if porder==1, `BAR_OPTS'
			xlabel(,val labsize(`XLAB_SIZE') )
			xtitle("")
		) 
		(rcap uci lci porder if porder!=0, 
			color(black)
			lwidth(`CI_WIDTH')
			legend(off)
			ylabel(`YRANGE', `YLAB_OPTS' ) 
			yscale(r(0 .82))
			xlabel(0 1,val labsize(`XLAB_SIZE') noticks)
			xscale(noextend lcolor(none))
			graphregion(color(white) lc(white) lw(medium) margin(0 0 3 0)) 
			bgcolor(white)
			plotregion(margin(30 30 0 0))
		)		
	;
#delimit cr	

graph export $figsavedir/yougov-unemp-congenialcue.pdf, replace	
restore


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Congenial cue interacted with partisanship
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
qui reg unempup i.congenialcue##i.rep, vce(hc3)

mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 9] /* _cons */
local congcoef = coefmat[1,2]  /* 1.congenialcue */
local repcoef = coefmat[1,4]  /* 1.rep */

preserve
regsave
drop if coef==0

gen effect = `baseline' + coef if var!="_cons"
replace effect = `baseline' if var=="_cons"
replace effect = effect + `congcoef' + `repcoef' if var=="1.congenialcue#1.rep"

* Construct CI
gen uci = effect + 1.96 * stderr
gen lci = effect - 1.96 * stderr
replace uci = 0 if var=="_cons"
replace lci = 0 if var=="_cons"

gen porder = 0 if var=="_cons"
replace porder = 1 if var=="1.congenialcue"
replace porder = 2 if var=="1.rep"
replace porder = 3 if var=="1.congenialcue#1.rep"
sort porder

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
label define xlab 0 `""Dem. w/" "uncongenial" """' 1 `""Dem. w/" "congenial" """' 2 `""Rep. w/" "uncongenial" """' 3 `""Rep. w/" "congenial" """' 
label values porder xlab

set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(large) nogrid 
local YRANGE 0.(0.1).5
local BASELINE_XLIM = _N+.5
local CI_WIDTH medthick
local XLAB_SIZE large
local BAR_OPTS 	 	 fcolor(none) lwidth(thick)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#delimit;
twoway 	
		(bar effect porder if porder==0, color(navy)   `BAR_OPTS') 
		(bar effect porder if porder==1, color(navy)   `BAR_OPTS') 
		(bar effect porder if porder==2, color(maroon) `BAR_OPTS') 
		(bar effect porder if porder==3, color(maroon) `BAR_OPTS'
			xlabel(,val labsize(`XLAB_SIZE') )
			xtitle("")
		) 
		(rcap uci lci porder if porder!=0, 
			color(black)
			lwidth(`CI_WIDTH')
			legend(off)
			ylabel(`YRANGE', `YLAB_OPTS' ) 
			yscale(r(0 .51))
			xlabel(, notick)
			xscale(noextend lcolor(none))
			graphregion(color(white) lc(white) lw(medium) margin(0 0 10 0)) 
			bgcolor(white)
			plotregion(margin(12 12 0 0))
		)		
	;
#delimit cr	
graph export $figsavedir/yougov-unemp-congenialcue-partisan.pdf, replace	

restore
