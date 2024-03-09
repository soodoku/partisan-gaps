eststo clear
logit unempup i.congenialcue, vce(robust)
	eststo: margins, dydx(congenialcue) post
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

logit unempup i.congenialcue $demoX, vce(robust) 
	eststo: margins, dydx(congenialcue) post
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"

logit deficitup i.congenialcue, vce(robust)
	eststo: margins, dydx(congenialcue) post
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

logit deficitup i.congenialcue $demoX, vce(robust)
	eststo:  margins, dydx(congenialcue) post
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"

#delimit;
esttab using $tabsavedir/yougov-reg-table-logitME-fragment.tex, 
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )
    collabels(, none)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.congenialcue)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(1.congenialcue "Congenial"
		)
	scalar(
		"demotab Demographic controls"
		"nobs Respondents"
		) 
	alignment(D{.}{.}{-1})
	substitute(\_ _)
	fragment booktabs replace        
	;
#delimit cr	
