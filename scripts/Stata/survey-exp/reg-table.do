eststo clear
eststo: qui reg unempup i.congenialcue, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

eststo: qui reg unempup i.congenialcue##i.rep, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

eststo: qui reg unempup i.congenialcue##i.rep $demoX, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"
	estadd local demo "Yes"

eststo: qui reg deficitup i.congenialcue, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

eststo: qui reg deficitup i.congenialcue##i.rep, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

eststo: qui reg deficitup i.congenialcue##i.rep $demoX, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"
	estadd local demo "Yes"	

#delimit;
esttab,
	b(%9.3fc)
	se(%9.3fc)
	varwidth(30)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.congenialcue 1.rep 1.congenialcue#1.rep _cons)
	obslast
	label
	nobase 	
	nomtitle
	coeflabel(1.congenialcue "Congenial cue"
			  1.rep "Republican"
		      1.congenialcue#1.rep "Congenial cue x Republican"		
		)
	scalar(
		"demo Demographic controls"
		"r2 R-square" 
		) 
	// title("Dep. var. is 1(response is congenial)")
;	

esttab using $tabsavedir/yougov-reg-table-fragment.tex, 
	b(%9.3fc)
	se(%9.3fc)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.congenialcue 1.rep 1.congenialcue#1.rep _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(1.congenialcue "Congenial cue"
			  1.rep "Republican"
		      1.congenialcue#1.rep "Congenial cue $\times$ Republican"		
		      _cons "Constant"	
		)
	scalar(
		"r2 R$^2$" 
		"demotab Demographic controls"
		"nobs Respondent-items"
		) 
	alignment(D{.}{.}{-1})
	substitute(\_ _)
	fragment booktabs replace        
	;
#delimit cr	
