local rootdir D:/partisan-gaps // for my convenience to set project root dir, comment out to avoid conflict
cd `rootdir'
cd scripts/Stata
import delimited `rootdir'/data/turk/mturk-recoded.csv, clear
do ./mturk/preamble.do

* Reshape from wide to long to stack participant-item observations
foreach item of varlist $items {
	rename `item' item`item'
}
reshape long item, i(id) j(item_type, string)

drop if pid_str=="Independent"

gen ccd = (survey==2)  /* 2.survey = 24k */


/*==============================================
* Confidence coding vs all four other conditions
==============================================*/ 
foreach item_type in $items {
	qui reg item i.rep##i.ccd if item_type=="`item_type'", vce(cluster id)

	mat coefmat = e(b)
	mat list coefmat
	local baseline = coefmat[1, 2] /* 1.congenial */

	preserve
	regsave
	drop if var=="_cons"
	drop if var=="1.ccd"
	drop if strpos(var, "0b")  // Drop base variables

	* Gen coef for plotting (add estimates back to baseline)
	gen est = coef
	label var est "Original reg estimate (before adding back to baseline)"
	replace coef = `baseline' + coef if var!="1.rep"

	* Construct CI
	gen uci = coef + 1.96 * stderr
	gen lci = coef - 1.96 * stderr
	replace uci = 0 if var=="_cons"
	replace lci = 0 if var=="_cons"

	gen porder = _n
	label define xlab 1 "MC" 2 "CS"
	label values porder xlab
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	* Graph settings
	set scheme s2mono
	local YLAB_OPTS angle(horizontal) labsize(vlarge) nogrid
	local YRANGE 0(0.1).5
	local BASELINE_XLIM = _N+.5
	local CI_WIDTH thick
	local XLAB_SIZE vlarge
	local BAR_OPTS 	 	 color(gs7) fcolor(none) lwidth(vthick)
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#delimit;
		twoway 	
				(bar coef porder if porder==1, `BAR_OPTS') 
				(bar coef porder if porder==2, `BAR_OPTS'
					xlabel(,val labsize(`XLAB_SIZE') )
				) 
				(rcap uci lci porder if porder!=1, 
					color(gs5)
					msize(huge)  // size of rcap
					lwidth(`CI_WIDTH') 
					legend(off)
					ylabel(`YRANGE', `YLAB_OPTS' ) 
					xlabel(, notick)
					yscale(r(-.05 .53))
					xscale(noextend lcolor(none))
					graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
					bgcolor(white)
					plotregion(margin(30 30 0 0))
				)		
				(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
					xlabel(1 2)
					recast(line) color(black) lpattern(dash)
					name(`item_type')
				)
			;
		#delimit cr		
		graph export $figsavedir/confidence_score_`item_type'_study1.pdf, replace	
	restore
}

/*================================
* Confidence coding vs IPS/IDA = 4
================================*/ 
graph drop _all
foreach item_type in $items {
	preserve
	drop if (survey!=2) & (survey!=4)

	qui reg item i.rep##i.ccd if item_type=="`item_type'", vce(cluster id)

	mat coefmat = e(b)
	mat list coefmat
	local baseline = coefmat[1, 2] /* 1.congenial */

	regsave
	drop if var=="_cons"
	drop if var=="1.ccd"
	drop if strpos(var, "0b")  // Drop base variables

	* Gen coef for plotting (add estimates back to baseline)
	gen est = coef
	label var est "Original reg estimate (before adding back to baseline)"
	replace coef = `baseline' + coef if var!="1.rep"

	* Construct CI
	gen uci = coef + 1.96 * stderr
	gen lci = coef - 1.96 * stderr
	replace uci = 0 if var=="_cons"
	replace lci = 0 if var=="_cons"

	gen porder = _n
	label define xlab 1 "MC" 2 "CS"
	label values porder xlab
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	* Graph settings
	set scheme s2mono
	local YLAB_OPTS angle(horizontal) labsize(vlarge) nogrid
	local YRANGE 0(0.1).5
	local BASELINE_XLIM = _N+.5
	local CI_WIDTH thick
	local XLAB_SIZE vlarge
	local BAR_OPTS 	 	 color(gs7) fcolor(none) lwidth(vthick)
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#delimit;
		twoway 	
				(bar coef porder if porder==1, `BAR_OPTS') 
				(bar coef porder if porder==2, `BAR_OPTS'
					xlabel(,val labsize(`XLAB_SIZE') )
				) 
				(rcap uci lci porder if porder!=1, 
					color(gs5)
					msize(huge)  // size of rcap
					lwidth(`CI_WIDTH') 
					legend(off)
					ylabel(`YRANGE', `YLAB_OPTS' ) 
					xlabel(, notick)
					yscale(r(-.05 .53))
					xscale(noextend lcolor(none))
					graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
					bgcolor(white)
					plotregion(margin(30 30 0 0))
				)		
				(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
					xlabel(1 2)
					recast(line) color(black) lpattern(dash)
					name(`item_type')
				)
			;
		#delimit cr		
		graph export $figsavedir/confidence_score_ccd_ida_ips_`item_type'_study1.pdf, replace	
	restore
}



/*===============================
* Confidence coding vs RW/CUD = 5
================================*/ 
graph drop _all
foreach item_type in $items {
	preserve
	drop if (survey!=2) & (survey!=5)
	
	qui reg item i.rep##i.ccd if item_type=="`item_type'", vce(cluster id)

	mat coefmat = e(b)
	mat list coefmat
	local baseline = coefmat[1, 2] /* 1.congenial */

	regsave
	drop if var=="_cons"
	drop if var=="1.ccd"
	drop if strpos(var, "0b")  // Drop base variables

	* Gen coef for plotting (add estimates back to baseline)
	gen est = coef
	label var est "Original reg estimate (before adding back to baseline)"
	replace coef = `baseline' + coef if var!="1.rep"

	* Construct CI
	gen uci = coef + 1.96 * stderr
	gen lci = coef - 1.96 * stderr
	replace uci = 0 if var=="_cons"
	replace lci = 0 if var=="_cons"

	gen porder = _n
	label define xlab 1 "MC" 2 "CS"
	label values porder xlab
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	* Graph settings
	set scheme s2mono
	local YLAB_OPTS angle(horizontal) labsize(vlarge) nogrid
	local YRANGE 0(0.1).5
	local BASELINE_XLIM = _N+.5
	local CI_WIDTH thick
	local XLAB_SIZE vlarge
	local BAR_OPTS 	 	 color(gs7) fcolor(none) lwidth(vthick)
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#delimit;
		twoway 	
				(bar coef porder if porder==1, `BAR_OPTS') 
				(bar coef porder if porder==2, `BAR_OPTS'
					xlabel(,val labsize(`XLAB_SIZE') )
				) 
				(rcap uci lci porder if porder!=1, 
					color(gs5)
					msize(huge)  // size of rcap
					lwidth(`CI_WIDTH') 
					legend(off)
					ylabel(`YRANGE', `YLAB_OPTS' ) 
					xlabel(, notick)
					yscale(r(-.05 .53))
					xscale(noextend lcolor(none))
					graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
					bgcolor(white)
					plotregion(margin(30 30 0 0))
				)		
				(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
					xlabel(1 2)
					recast(line) color(black) lpattern(dash)
					name(`item_type')
				)
			;
		#delimit cr		
		graph export $figsavedir/confidence_score_ccd_cud_rw_`item_type'_study1.pdf, replace	
	restore
}

/*================================
* Confidence coding vs FSR/FSR = 3
=================================*/ 
graph drop _all
foreach item_type in $items {
	preserve
	drop if (survey!=2) & (survey!=3)
	
	qui reg item i.rep##i.ccd if item_type=="`item_type'", vce(cluster id)

	mat coefmat = e(b)
	mat list coefmat
	local baseline = coefmat[1, 2] /* 1.congenial */

	regsave
	drop if var=="_cons"
	drop if var=="1.ccd"
	drop if strpos(var, "0b")  // Drop base variables

	* Gen coef for plotting (add estimates back to baseline)
	gen est = coef
	label var est "Original reg estimate (before adding back to baseline)"
	replace coef = `baseline' + coef if var!="1.rep"

	* Construct CI
	gen uci = coef + 1.96 * stderr
	gen lci = coef - 1.96 * stderr
	replace uci = 0 if var=="_cons"
	replace lci = 0 if var=="_cons"

	gen porder = _n
	label define xlab 1 "MC" 2 "CS"
	label values porder xlab
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	* Graph settings
	set scheme s2mono
	local YLAB_OPTS angle(horizontal) labsize(vlarge) nogrid
	local YRANGE 0(0.1).5
	local BASELINE_XLIM = _N+.5
	local CI_WIDTH thick
	local XLAB_SIZE vlarge
	local BAR_OPTS 	 	 color(gs7) fcolor(none) lwidth(vthick)
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#delimit;
		twoway 	
				(bar coef porder if porder==1, `BAR_OPTS') 
				(bar coef porder if porder==2, `BAR_OPTS'
					xlabel(,val labsize(`XLAB_SIZE') )
				) 
				(rcap uci lci porder if porder!=1, 
					color(gs5)
					msize(huge)  // size of rcap
					lwidth(`CI_WIDTH') 
					legend(off)
					ylabel(`YRANGE', `YLAB_OPTS' ) 
					xlabel(, notick)
					yscale(r(-.05 .53))
					xscale(noextend lcolor(none))
					graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
					bgcolor(white)
					plotregion(margin(30 30 0 0))
				)		
				(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
					xlabel(1 2)
					recast(line) color(black) lpattern(dash)
					name(`item_type')
				)
			;
		#delimit cr		
		graph export $figsavedir/confidence_score_ccd_fsr_fsr_`item_type'_study1.pdf, replace	
	restore
}

/*================================
* Confidence coding vs 14k/IMC = 1
=================================*/ 
graph drop _all
foreach item_type in $items {
	preserve
	drop if (survey!=2) & (survey!=1)
	
	qui reg item i.rep##i.ccd if item_type=="`item_type'", vce(cluster id)

	mat coefmat = e(b)
	mat list coefmat
	local baseline = coefmat[1, 2] /* 1.congenial */

	regsave
	drop if var=="_cons"
	drop if var=="1.ccd"
	drop if strpos(var, "0b")  // Drop base variables

	* Gen coef for plotting (add estimates back to baseline)
	gen est = coef
	label var est "Original reg estimate (before adding back to baseline)"
	replace coef = `baseline' + coef if var!="1.rep"

	* Construct CI
	gen uci = coef + 1.96 * stderr
	gen lci = coef - 1.96 * stderr
	replace uci = 0 if var=="_cons"
	replace lci = 0 if var=="_cons"

	gen porder = _n
	label define xlab 1 "MC" 2 "CS"
	label values porder xlab
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	* Graph settings
	set scheme s2mono
	local YLAB_OPTS angle(horizontal) labsize(vlarge) nogrid
	local YRANGE 0(0.1).5
	local BASELINE_XLIM = _N+.5
	local CI_WIDTH thick
	local XLAB_SIZE vlarge
	local BAR_OPTS 	 	 color(gs7) fcolor(none) lwidth(vthick)
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#delimit;
		twoway 	
				(bar coef porder if porder==1, `BAR_OPTS') 
				(bar coef porder if porder==2, `BAR_OPTS'
					xlabel(,val labsize(`XLAB_SIZE') )
				) 
				(rcap uci lci porder if porder!=1, 
					color(gs5)
					msize(huge)  // size of rcap
					lwidth(`CI_WIDTH') 
					legend(off)
					ylabel(`YRANGE', `YLAB_OPTS' ) 
					xlabel(, notick)
					yscale(r(-.05 .53))
					xscale(noextend lcolor(none))
					graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
					bgcolor(white)
					plotregion(margin(30 30 0 0))
				)		
				(scatteri `baseline' .5 `baseline' `BASELINE_XLIM', 
					xlabel(1 2)
					recast(line) color(black) lpattern(dash)
					name(`item_type')
				)
			;
		#delimit cr		
		graph export $figsavedir/confidence_score_ccd_imc_14k_`item_type'_study1.pdf, replace	
	restore
}
