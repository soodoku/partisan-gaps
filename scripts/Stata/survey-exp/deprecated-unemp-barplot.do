eststo: qui reg unempup i.rep##i.repcue, vce(hc3)

mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 9] /* _cons */
local repcoef = coefmat[1,2]  /* 2.rep */

preserve
regsave
drop if coef==0

gen effect = `baseline' + coef if var!="_cons"
replace effect = `baseline' if var=="_cons"
replace effect = effect + `repcoef' if var=="2.rep#1.repcue"
* Construct CI
gen uci = effect + 1.96 * stderr
gen lci = effect - 1.96 * stderr
replace uci = 0 if var=="_cons"
replace lci = 0 if var=="_cons"

gen porder = 0 if var=="_cons"
replace porder = 1 if var=="1.cue"
replace porder = 2 if var=="2.rep"
replace porder = 3 if var=="2.rep#1.cue"
sort porder

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
label define xlab 0 `""Dem. w/" "Dem. cue""' 1 `""Dem. w/" "Rep. cue""' 2 `""Rep. w/" "Dem. cue""' 3 `""Rep. w/" "Rep. cue""' 
label values porder xlab

set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(large) nogrid 
local YRANGE 0.(0.2).8
local BASELINE_XLIM = _N+.5
local CI_WIDTH medthick
local XLAB_SIZE large
local BAR_OPTS 	 	 lwidth(thick)
local BAR_OPTS_BASE fcolor(none) lwidth(thick)

local graphsavedir ./figures
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#delimit;
twoway 	
		(bar effect porder if porder==0, color(navy)   `BAR_OPTS_BASE') 
		(bar effect porder if porder==1, color(navy)   fcolor(gs10) `BAR_OPTS') 
		(bar effect porder if porder==2, color(maroon) fcolor(gs10) `BAR_OPTS') 
		(bar effect porder if porder==3, color(maroon) fcolor(none) `BAR_OPTS'
			xlabel(,val labsize(`XLAB_SIZE') )
			xtitle("")
		) 
		(rcap uci lci porder if porder!=0, 
			color(black)
			lwidth(`CI_WIDTH')
			legend(off)
			ylabel(`YRANGE', `YLAB_OPTS' ) 
			yscale(r(0 .9))
			xlabel(, notick)
			xscale(noextend lcolor(none))
			graphregion(color(white) lc(white) lw(medium) margin(0 0 3 0)) 
			bgcolor(white)
			plotregion(margin(12 12 0 0))
		)		
	;
#delimit cr	
graph export $figsavedir/yougov-unemp.pdf, replace	

restore
