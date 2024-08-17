import delimited $rootdir/data/survey_exp/selex.csv, clear
do ./survey-exp/preamble.do
drop if ind==1

eststo clear
eststo: reg unemp_correct i.congenial##i.Dcue, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

eststo: reg unemp_correct i.congenial##i.Dcue $demoX, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"
	estadd local demo "Yes"	

eststo: reg deficit_correct i.congenial##i.Dcue, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

eststo: reg deficit_correct i.congenial##i.Dcue $demoX, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"
	estadd local demo "Yes"	

#delimit;
esttab,
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )
    collabels(, none)
	varwidth(30)
	modelwidth(8)
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(
		1.congenial
		1.Dcue
		1.congenial#1.Dcue
		_cons
	)
	obslast
	label
	nobase 	
	nomtitle
	coeflabel(
		1.congenial "Congenial"
		1.Dcue "Democratic cue"
		1.congenial#1.Dcue "Congenial x Democratic cue"		
	)
	scalar(
		"demo Demographic controls"
		"r2 R-square" 
		) 
	// title("Dep. var. is 1(response is congenial)")
;	

esttab using $tabsavedir/yougov-reg-table-fragment.tex, 
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )  
    collabels(, none)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(
		1.congenial
		1.Dcue
		1.congenial#1.Dcue
		_cons
	)
	obslast
	label
	nobase
	noobs
	nomtitle
	coeflabel(
		1.congenial "Congenial"
		1.Dcue "Democratic cue"
		1.congenial#1.Dcue "Congenial $\times$ Democratic cue"
		_cons "Constant"
	)
	scalar(
		"r2 R$^2$"
		"demotab Demographic controls"
		"nobs Respondents"
		)
	alignment(D{.}{.}{-1})
	substitute(\_ _)
	fragment booktabs replace
	;
#delimit cr	
