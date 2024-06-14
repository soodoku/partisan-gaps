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

eststo clear
forvalues i = 1/6 {
eststo: qui reghdfe item `spec`i'', absorb(item_type) vce(cluster id)
	estadd local items 9
	estadd local Nrespondents = e(N_clust1)
	local nobs: display %9.0fc `e(N)'
	estadd local itemFE "\multicolumn{1}{c}{Yes}"
	estadd local nobs "`nobs'"
	if `i' > 3 {
		estadd local demo "\multicolumn{1}{c}{Yes}"
	}
	else {
		estadd local demo "\multicolumn{1}{c}{.}"	
	}
}


#delimit;
esttab,
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )  
    collabels(, none)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.rep *.survey _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(1.rep "Congenial"
			  5.survey "Condition 2"
			  3.survey "Condition 3"
			  1.survey "Condition 4"
			  // 2.survey "CCD"
		      1.rep#5.survey "Congenial $\times$ (Cond. 2)"
		      1.rep#3.survey "Congenial $\times$ (Cond. 3)"		
		      1.rep#1.survey "Congenial $\times$ (Cond. 4)"
		      // 1.rep#2.survey "Congenial $\times$ CCD"
		      // 1.rep#4.survey "Congenial $\times$ IPS"
		)
	// order(1.rep 5.survey 3.survey 1.survey 2.survey 1.rep#5.survey 1.rep#3.survey 1.rep#1.survey 1.rep#2.survey)
	order(1.rep 5.survey 3.survey 1.survey 1.rep#5.survey 1.rep#3.survey 1.rep#1.survey)
	scalar(
		"r2 R$^2$" 
		"itemFE Survey item FE"
		"demo Demographic controls"
		"items Items"
		"Nrespondents Respondents"
		"nobs Respondent-items"
		) 
	title("Dep. var. is 1(response is congenial)")
;	


esttab using $tabsavedir/mturk-reg-table-fragment.tex, 
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )  
    collabels(, none)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.rep *.survey _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle 
	coeflabel(1.rep "Congenial"
			  5.survey "Condition 2"
			  3.survey "Condition 3"
			  1.survey "Condition 4"
			  // 2.survey "CCD"
		      1.rep#5.survey "Congenial $\times$ (Cond. 2)"
		      1.rep#3.survey "Congenial $\times$ (Cond. 3)"		
		      1.rep#1.survey "Congenial $\times$ (Cond. 4)"
		      // 1.rep#2.survey "Congenial $\times$ CCD"
		      // 1.rep#4.survey "Congenial $\times$ IPS"
		)
	order(1.rep 5.survey 3.survey 1.survey 1.rep#5.survey 1.rep#3.survey 1.rep#1.survey)
	scalar(
		"r2 R$^2$"
		"itemFE Survey item FE"
		"demo Demographic controls"
		"items Items"
		"Nrespondents Respondents"
		"nobs Respondent-items"
		) 
	alignment(D{.}{.}{-1})
	substitute(\_ _)
	fragment booktabs replace        
	;
#delimit cr	


grstyle init
grstyle set plain, nogrid noextend horizontal
// Test plot
* IPS = IDA
* RW = CUD
* FSR = FSR
* 14k = IMD
* 24k = CCD
margins rep#survey, post

#delimit;
coefplot,
	keep(1.rep#*)
	recast(bar)
	vertical
	color(gs7) fcolor(none) lwidth(thick)
	ylabel(0(.2).6, labsize(large) nogrid )
	yscale(r(0 .65))
	ciopts(recast(rcap))
	coeflabel(
		1.rep#4.survey = "IDA"
		1.rep#5.survey = "CUD"
		1.rep#3.survey = "FSR"
		1.rep#1.survey = "IMD"
		// 1.rep#2.survey = "24k"
	)
	order(
		1.rep#4.survey
		1.rep#5.survey
		1.rep#3.survey
		1.rep#1.survey
	)
	graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
	xlabel(,val noticks labsize(medlarge))
	plotregion(margin(10 10 0 0))
	ytitle("Predicted proportion of correct responses" "when congenial", size(large))
	name(congenial)
;
graph export $figsavedir/mturk-ida-cud-fsr-imc-congenial.pdf, replace;


#delimit;
coefplot,
	keep(0.rep#*)
	recast(bar)
	vertical
	color(gs7) fcolor(none) lwidth(thick)
	ylabel(0(.2).6, angle(horizontal) labsize(large) nogrid )
	yscale(r(0 .65))
	ciopts(recast(rcap))
	coeflabel(
		0.rep#4.survey = "IDA"
		0.rep#5.survey = "CUD"
		0.rep#3.survey = "FSR"
		0.rep#1.survey = "IMD"
		// 1.rep#2.survey = "24k"
	)
	order(
		0.rep#4.survey
		0.rep#5.survey
		0.rep#3.survey
		0.rep#1.survey
	)
	graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0)) 
	xlabel(,val noticks labsize(medlarge))
	plotregion(margin(10 10 0 0))
	ytitle("Predicted proportion of correct responses" "when not* congenial", size(large))
	name(uncongenial)
;
graph export $figsavedir/mturk-ida-cud-fsr-imc-uncongenial.pdf, replace;



coef
