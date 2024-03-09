reg unempup i.congenialcue $demoX, vce(hc3)

grstyle init
grstyle set plain, noextend

#delimit;
coefplot,
	keep(1.congenialcue)
	coeflabel(
		1.congenialcue="Congenial"
	)
	order(1.rep#5.survey 1.rep#3.survey 1.rep#1.survey)
	msize(vlarge)
	mcolor(gs5)
	mlwidth(vthin)
	mlcolor(navy)	
	ylabel(, noticks labsize(large))
	grid(none)
	yscale(lcolor(white))
	xline(0, lcolor(navy) lpattern(dash) lwidth(medium) )
	levels(99 95)
	ciopts(color(gs7 gs9) )
	graphregion(color(white) margin(0 2 0 0) )
	plotregion(lcolor(white) margin(0 0 0 0) )
	xtitle(
		"Estimated difference in probability of correct response"
		"that 'Unemployment has gone up'"
		"when cue is congenial", size(large)
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
graph export $figsavedir/coefplot-yougov-unemp.pdf, replace


reg deficitup i.congenialcue $demoX, vce(hc3)
#delimit;
coefplot,
	keep(1.congenialcue)
	coeflabel(
		1.congenialcue="Congenial"
	)
	order(1.rep#5.survey 1.rep#3.survey 1.rep#1.survey)
	msize(vlarge)
	mcolor(gs5)
	mlwidth(vthin)
	mlcolor(navy)	
	ylabel(, noticks labsize(large))
	grid(none)
	yscale(lcolor(white))
	xline(0, lcolor(navy) lpattern(dash) lwidth(medium) )
	levels(99 95)
	ciopts(color(gs7 gs9) )
	graphregion(color(white) margin(0 2 0 0) )
	plotregion(lcolor(white) margin(0 0 0 0) )
	xtitle(
		"Estimated difference in probability of correct response"
		"that 'Deficit has gone up'"
		"when cue is congenial", size(large)
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
graph export $figsavedir/coefplot-yougov-deficit.pdf, replace
