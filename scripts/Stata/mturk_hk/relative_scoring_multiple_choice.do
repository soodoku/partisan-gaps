local rootdir D:/partisan-gaps // for my convenience to set project root dir, comment out to avoid conflict
cd `rootdir'
cd scripts/Stata
**** Basic prep of data
import delimited `rootdir'/data/mturk_hk/mturk_hk_relative_scoring_MC.csv, clear

global tabsavedir `rootdir'/tabs

rename responses responses_str
gen responses = (responses_str=="1")
replace responses = . if responses_str=="NA"

rename congenial congenial_str
gen congenial = (congenial_str=="1")
replace congenial = . if congenial_str=="NA"

rename survey survey_str
encode survey_str, gen(survey)

local q_items aca aca2 gg dt
local close_relscore (response_type=="closed" | response_type=="relscore_c_10")
eststo clear
foreach q_item in `q_items' {
	eststo: reg responses i.congenial##i.survey if q_item == "`q_item'" & `close_relscore', cluster(respondent) 
		estadd local itemFE "\multicolumn{1}{c}{No}"
		estadd local items 1
		estadd local Nrespondents = "\multicolumn{1}{c}{`e(N_clust)'}"
		local nobs: display %9.0fc `e(N)'
		estadd local nobs "\multicolumn{1}{c}{`nobs'}"
}
eststo: reg responses congenial##survey if `close_relscore', cluster(respondent) 
	estadd local itemFE "\multicolumn{1}{c}{Yes}"
	estadd local items 4
	estadd local Nrespondents = "\multicolumn{1}{c}{`e(N_clust)'}"
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"

#delimit;
esttab,
	b(%9.3fc)
	se(%9.3fc)
	varwidth(30)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.congenial 2.survey 1.congenial#2.survey)
	obslast
	label
	nobase 	
	noobs
	nomtitle	
	coeflabel(
		1.congenial "Congenial"
		2.survey "Relative Scoring (RS)"
		1.congenial#2.survey "Congenial $\times$ RS"
		)	
	scalar(
		"r2 R$^2$" 
		"itemFE Survey item FE"
		"items Items"
		"Nrespondents Respondents"
		"nobs Respondent-items"
		) 
	title("Dep. var. is 1(response is correct)")	
;

esttab using $tabsavedir/mturk-hk-reg-table-fragment.tex, 
	b(%9.3fc)
	se(%9.3fc)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.congenial 2.survey 1.congenial#2.survey)
	obslast
	label
	nobase 	
	noobs
	nomtitle	
	coeflabel(
		1.congenial "Congenial"
		2.survey "Relative Scoring (RS)"
		1.congenial#2.survey "Congenial $\times$ RS"
		)	
	scalar(
		"r2 R$^2$" 
		"itemFE Survey item FE"
		"items Items"
		"Nrespondents Respondents"
		"nobs Respondent-items"
		) 
	alignment(D{.}{.}{-1})
	substitute(\_ _)
	fragment booktabs replace        
;

graph drop _all

* Barplot for ACA
qui reg responses i.congenial##i.survey if q_item == "aca" & `close_relscore', cluster(respondent) 

mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 2] /* 1.rep */
dis `baseline'

preserve
regsave
drop if var=="_cons"
drop if var=="2.survey"
drop if strpos(var, "0b")  // Drop base variables
drop if strpos(var, "1b.survey") // Drop base variables

* Gen coef for plotting (add estimates back to baseline)
gen est = coef
label var est "Original reg estimate (before adding back to baseline)"
replace coef = `baseline' + coef if var!="1.congenial"

* Construct CI
gen uci = coef + 1.96 * stderr
gen lci = coef - 1.96 * stderr
replace uci = 0 if var=="_cons"
replace lci = 0 if var=="_cons"

gen porder = _n
label define xlab 1 "Multiple choice" 2 "Relative Scoring"
label values porder xlab

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(large) nogrid
local YRANGE 0(0.1).3
local BASELINE_XLIM = _N+.5
local CI_WIDTH medium
local XLAB_SIZE large
local BAR_OPTS 		color(gs10) fcolor(none) lwidth(medthick) 
local BAR_OPTS_BASE color(gs10) fcolor(none) lwidth(medthick)

local graphsavedir ./figures
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#delimit;
	twoway 	
			(bar coef porder if porder==1, `BAR_OPTS_BASE') 
			(bar coef porder if porder==2, `BAR_OPTS'
				xlabel(,val labsize(`XLAB_SIZE') )
			) 
			(rcap uci lci porder if porder!=1, 
				color(gs5)
				lwidth(`CI_WIDTH') 
				legend(off)
				ylabel(`YRANGE', `YLAB_OPTS' ) 
				xlabel(, notick)
				yscale(r(0 .31))
				xscale(noextend lcolor(none))
				graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
				bgcolor(white)
				plotregion(margin(12 12 0 0))
			)		
			(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
				xlabel(1 2)
				recast(line) color(black) lpattern(dash)
				name(aca)
			)
		;
	#delimit cr	
restore

* Barplot for ACA2
qui reg responses i.congenial##i.survey if q_item == "aca2" & `close_relscore', cluster(respondent) 

mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 2] /* 1.rep */
dis `baseline'

preserve
regsave
drop if var=="_cons"
drop if var=="2.survey"
drop if strpos(var, "0b")  // Drop base variables
drop if strpos(var, "1b.survey") // Drop base variables

* Gen coef for plotting (add estimates back to baseline)
gen est = coef
label var est "Original reg estimate (before adding back to baseline)"
replace coef = `baseline' + coef if var!="1.congenial"

* Construct CI
gen uci = coef + 1.96 * stderr
gen lci = coef - 1.96 * stderr
replace uci = 0 if var=="_cons"
replace lci = 0 if var=="_cons"

gen porder = _n
label define xlab 1 "Multiple choice" 2 "Relative Scoring"
label values porder xlab

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(large) nogrid
local YRANGE 0(0.1).3
local BASELINE_XLIM = _N+.5
local CI_WIDTH medium
local XLAB_SIZE large
local BAR_OPTS 		color(gs10) fcolor(none) lwidth(medthick) 
local BAR_OPTS_BASE color(gs10) fcolor(none) lwidth(medthick)

local graphsavedir ./figures
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#delimit;
	twoway 	
			(bar coef porder if porder==1, `BAR_OPTS_BASE') 
			(bar coef porder if porder==2, `BAR_OPTS'
				xlabel(,val labsize(`XLAB_SIZE') )
			) 
			(rcap uci lci porder if porder!=1, 
				color(gs5)
				lwidth(`CI_WIDTH') 
				legend(off)
				ylabel(`YRANGE', `YLAB_OPTS' ) 
				xlabel(, notick)
				yscale(r(0 .31))
				xscale(noextend lcolor(none))
				graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
				bgcolor(white)
				plotregion(margin(12 12 0 0))
			)		
			(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
				xlabel(1 2)
				recast(line) color(black) lpattern(dash)
				name(aca2)
			)
		;
	#delimit cr		
restore	


* Barplot for gg
qui reg responses i.congenial##i.survey if q_item == "gg" & `close_relscore', cluster(respondent) 

mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 2] /* 1.rep */
dis `baseline'

preserve
regsave
drop if var=="_cons"
drop if var=="2.survey"
drop if strpos(var, "0b")  // Drop base variables
drop if strpos(var, "1b.survey") // Drop base variables

* Gen coef for plotting (add estimates back to baseline)
gen est = coef
label var est "Original reg estimate (before adding back to baseline)"
replace coef = `baseline' + coef if var!="1.congenial"

* Construct CI
gen uci = coef + 1.96 * stderr
gen lci = coef - 1.96 * stderr
replace uci = 0 if var=="_cons"
replace lci = 0 if var=="_cons"

gen porder = _n
label define xlab 1 "Multiple choice" 2 "Relative Scoring"
label values porder xlab

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(large) nogrid
local YRANGE 0(0.1).3
local BASELINE_XLIM = _N+.5
local CI_WIDTH medium
local XLAB_SIZE large
local BAR_OPTS 		color(gs10) fcolor(none) lwidth(medthick) 
local BAR_OPTS_BASE color(gs10) fcolor(none) lwidth(medthick)

local graphsavedir ./figures
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#delimit;
	twoway 	
			(bar coef porder if porder==1, `BAR_OPTS_BASE') 
			(bar coef porder if porder==2, `BAR_OPTS'
				xlabel(,val labsize(`XLAB_SIZE') )
			) 
			(rcap uci lci porder if porder!=1, 
				color(gs5)
				lwidth(`CI_WIDTH') 
				legend(off)
				ylabel(`YRANGE', `YLAB_OPTS' ) 
				xlabel(, notick)
				yscale(r(0 .31))
				xscale(noextend lcolor(none))
				graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
				bgcolor(white)
				plotregion(margin(12 12 0 0))
			)		
			(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
				xlabel(1 2)
				recast(line) color(black) lpattern(dash)
				name(gg)
			)
		;
	#delimit cr		
restore	


* Barplot for dt
qui reg responses i.congenial##i.survey if q_item == "dt" & `close_relscore', cluster(respondent) 

mat coefmat = e(b)
mat list coefmat
local baseline = coefmat[1, 2] /* 1.rep */
dis `baseline'

preserve
regsave
drop if var=="_cons"
drop if var=="2.survey"
drop if strpos(var, "0b")  // Drop base variables
drop if strpos(var, "1b.survey") // Drop base variables

* Gen coef for plotting (add estimates back to baseline)
gen est = coef
label var est "Original reg estimate (before adding back to baseline)"
replace coef = `baseline' + coef if var!="1.congenial"

* Construct CI
gen uci = coef + 1.96 * stderr
gen lci = coef - 1.96 * stderr
replace uci = 0 if var=="_cons"
replace lci = 0 if var=="_cons"

gen porder = _n
label define xlab 1 "Multiple choice" 2 "Relative Scoring"
label values porder xlab

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Graph settings
set scheme s2mono
local YLAB_OPTS angle(horizontal) labsize(large) nogrid
local YRANGE 0(0.1).3
local BASELINE_XLIM = _N+.5
local CI_WIDTH medium
local XLAB_SIZE large
local BAR_OPTS 		color(gs10) fcolor(none) lwidth(medthick) 
local BAR_OPTS_BASE color(gs10) fcolor(none) lwidth(medthick)

local graphsavedir ./figures
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#delimit;
	twoway 	
			(bar coef porder if porder==1, `BAR_OPTS_BASE') 
			(bar coef porder if porder==2, `BAR_OPTS'
				xlabel(,val labsize(`XLAB_SIZE') )
			) 
			(rcap uci lci porder if porder!=1, 
				color(gs5)
				lwidth(`CI_WIDTH') 
				legend(off)
				ylabel(`YRANGE', `YLAB_OPTS' ) 
				xlabel(, notick)
				yscale(r(0 .31))
				xscale(noextend lcolor(none))
				graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
				bgcolor(white)
				plotregion(margin(12 12 0 0))
			)		
			(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
				xlabel(1 2)
				recast(line) color(black) lpattern(dash)
				name(dt)
			)
		;
	#delimit cr		
restore	
