local rootdir D:/partisan-gaps // for my convenience to set project root dir, comment out to avoid conflict
cd `rootdir'
cd scripts/Stata
**** Basic prep of data
import delimited `rootdir'/data/turk/mturk-recoded.csv, clear
do ./mturk/preamble.do

* Reshape from wide to long to stack participant-item observations
foreach item of varlist $items {
	rename `item' item`item'
}
reshape long item, i(id) j(item_type, string)

drop if pid_str=="Independent"

eststo: qui reghdfe item i.rep##i.survey $demo, absorb(item_type) vce(cluster id)

mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 2] /* 1.rep */

// preserve
regsave
drop if var=="_cons"
drop if strpos(var, "0b.rep")
drop if var=="1.survey"
drop if var=="2.survey"
drop if var=="3.survey"
drop if var=="4.survey"
drop if var=="5b.survey"
drop if var=="1o.rep#5b.survey"
drop if strpos(var, "female")
drop if strpos(var, "educ")
drop if strpos(var, "hisla")
drop if var=="age"
drop if var=="asian"
drop if var=="black"
drop if var=="white"
drop if var=="others"

* Gen coef for plotting (add estimates back to baseline)
gen est = coef
label var est "Original reg estimate (before adding back to baseline)"
replace coef = `baseline' + coef if var!="1.rep"

* Construct CI
gen uci = coef + 1.96 * stderr
gen lci = coef - 1.96 * stderr
replace uci = 0 if var=="_cons"
replace lci = 0 if var=="_cons"


* Create plot order var by treat dummies and label values with sample size
gen porder = _n
replace porder = 0 if var=="_cons"
sort porder

label define xlab 1 "RW" 2 "14k" 3 "24k" 4 "FSR" 5 "IPS"
label values porder xlab
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(large) nogrid
local YRANGE 0.1(0.1).4
local BASELINE_XLIM = _N+.5
local CI_WIDTH medthick
local XLAB_SIZE large
local BAR_OPTS 		color(purple) fcolor(none) lwidth(medthick)
local BAR_OPTS_BASE color(gs5) fcolor(none) lwidth(medthick)

local graphsavedir ./figures
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#delimit;
	twoway 	
			(bar coef porder if porder==1, `BAR_OPTS_BASE') 
			(bar coef porder if porder==2, `BAR_OPTS') 
			(bar coef porder if porder==3, `BAR_OPTS') 
			(bar coef porder if porder==4, `BAR_OPTS') 
			(bar coef porder if porder==5, `BAR_OPTS'
				xlabel(,val labsize(`XLAB_SIZE') )
			) 
			(rcap uci lci porder if porder!=1, 
				color(black)
				lwidth(`CI_WIDTH')
				legend(off)
				ylabel(`YRANGE', `YLAB_OPTS' ) 
				xlabel(, notick)
				xscale(noextend lcolor(none))
				graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
				bgcolor(white)
				plotregion(margin(12 12 0 0))
			)		
			(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
				xlabel(1 2 3 4 5)
				recast(line) color(black) lpattern(dash)
			)
		;
	#delimit cr	
graph export $figsavedir/mturk-pgag-surveyarms.pdf, replace	
