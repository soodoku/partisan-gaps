// *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Texas Lyceum results (Study 3)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**** Basic prep of data
use "D:/partisan-gaps/data/tx_lyceum/Texas Lyceum 2012 Data.dta", clear
do ./tx-lyceum/preamble.do
set more off

reg unempup i.unempcongenial i.unempuncongenial $demoX, vce(hc3)


#delimit;
coefplot,
	keep(1.unempcongenial 1.unempuncongenial)
	coeflabel(
		1.unempcongenial="Congenial"	
		1.unempuncongenial="Uncongenial"	
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
	graphregion(color(white) margin(0 2 0 0) )
	plotregion(lcolor(white) margin(0 0 0 0) )
	xtitle(
		"Estimated difference in probability of correct response"
		"by experiment condition", size()
	)
	// ========================================
	// Annotate if significant
	mlabposition(1)
	mlabcolor(gs4)
	mlabel(
		cond(@pval<.0001, "p = " + string(@pval,"%9.0e"),
			"p = " + subinstr(string(@pval,"%5.4f"), "0.", ".",1)
		)
	)
;
#delimit cr
graph export $figsavedir/coefplot-texas-unemp-congenial-uncongenial.pdf, replace


global congguess fedtaxcongenial fedtaxuncongenial fedtaxcongenialguess fedtaxuncongenialguess
reg fedtaxup i.($congguess) $demoX, vce(hc3)

#delimit;
coefplot,
	keep(1.fedtaxcongenial 1.fedtaxuncongenial 1.fedtaxcongenialguess 1.fedtaxuncongenialguess)
	coeflabel(
		1.fedtaxcongenial="Congenial"	
		1.fedtaxuncongenial="Uncongenial"	
		1.fedtaxcongenialguess="Congenial w/ guess"	
		1.fedtaxuncongenialguess="Uncongenial w/ guess"	
	)
	order(1.fedtaxcongenial 1.fedtaxuncongenial 1.fedtaxcongenialguess 1.fedtaxuncongenialguess)
	msize(vlarge)
	mcolor(gs5)
	mlwidth(vthin)
	mlcolor(navy)	
	ylabel(, noticks)
	grid(none)
	yscale(lcolor(white))
	xlabel(-.4(.2).4)
	xline(0, lcolor(navy) lpattern(dash) lwidth(medium) )
	levels(99 95)
	ciopts(color(gs7 gs9) )
	graphregion(color(white) margin(0 2 0 0) )
	plotregion(lcolor(white) margin(0 0 0 0) )
	xtitle(
		"Estimated difference in probability of correct response"
		"by experiment condition", size(large)
	)
	// ========================================
	// Annotate if significant
	mlabposition(1)
	mlabcolor(gs4)
	mlabsize(large)
	mlabel(
		cond(@pval<.0001, "p = " + string(@pval,"%9.0e"),
			"p = " + subinstr(string(@pval,"%5.4f"), "0.", ".",1)
		)
	)
;
#delimit cr
graph export $figsavedir/coefplot-texas-fedtaxup.pdf, replace



reg fedtaxdk i.($congguess) $demoX, vce(hc3)

#delimit;
coefplot,
	keep(1.fedtaxcongenial 1.fedtaxuncongenial 1.fedtaxcongenialguess 1.fedtaxuncongenialguess)
	coeflabel(
		1.fedtaxcongenial="Congenial"	
		1.fedtaxuncongenial="Uncongenial"	
		1.fedtaxcongenialguess="Congenial w/ guess"	
		1.fedtaxuncongenialguess="Uncongenial w/ guess"	
	)
	order(1.fedtaxcongenial 1.fedtaxuncongenial 1.fedtaxcongenialguess 1.fedtaxuncongenialguess)
	msize(vlarge)
	mcolor(gs5)
	mlwidth(vthin)
	mlcolor(navy)	
	ylabel(, noticks)
	grid(none)
	yscale(lcolor(white))
	xlabel(-.4(.2).4)
	xline(0, lcolor(navy) lpattern(dash) lwidth(medium) )
	levels(99 95)
	ciopts(color(gs7 gs9) )
	graphregion(color(white) margin(0 2 0 0) )
	plotregion(lcolor(white) margin(0 0 0 0) )
	xtitle(
		"Estimated difference in probability of correct response"
		"by experiment condition", size(large)
	)
	// ========================================
	// Annotate if significant
	mlabposition(1)
	mlabcolor(gs4)
	mlabsize(large)
	mlabel(
		cond(@pval<.0001, "p = " + string(@pval,"%9.0e"),
			"p = " + subinstr(string(@pval,"%5.4f"), "0.", ".",1)
		)
	)
;
#delimit cr
graph export $figsavedir/coefplot-texas-fedtaxdk.pdf, replace

