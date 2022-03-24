eststo clear
eststo: qui reg unempup i.rep##i.cue, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	* Republican + Republican x (Rep cue) = 0 
	qui lincom 2.rep + 2.rep#1.cue
	mat L = (r(estimate), r(se),r(estimate)/r(se) , 2*ttail(r(df),abs(r(estimate)/r(se) )))	
	local lincompval = L[1,4]
	estadd local lincompval = round(`lincompval',.001)

eststo: qui reg unempup i.rep##i.cue $demoX, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"
	estadd local demo "Yes"
	* Republican + Republican x (Rep cue) = 0 
	qui lincom 2.rep + 2.rep#1.cue
	mat L = (r(estimate), r(se),r(estimate)/r(se) , 2*ttail(r(df),abs(r(estimate)/r(se) )))	
	local lincompval = L[1,4]
	estadd local lincompval = round(`lincompval',.001)

eststo: qui reg deficitup i.rep##i.cue , vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	* Republican + Republican x (Rep cue) = 0 
	qui lincom 2.rep + 2.rep#1.cue
	mat L = (r(estimate), r(se),r(estimate)/r(se) , 2*ttail(r(df),abs(r(estimate)/r(se) )))	
	local lincompval = L[1,4]
	estadd local lincompval = round(`lincompval',.001)

eststo: qui reg deficitup i.rep##i.cue $demoX, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"
	estadd local demo "Yes"
	* Republican + Republican x (Rep cue) = 0 
	qui lincom 2.rep + 2.rep#1.cue
	mat L = (r(estimate), r(se),r(estimate)/r(se) , 2*ttail(r(df),abs(r(estimate)/r(se) )))	
	local lincompval = L[1,4]
	estadd local lincompval = round(`lincompval',.001)

#delimit;
esttab,
	b(%9.3fc)
	se(%9.3fc)
	varwidth(30)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(2.rep 1.cue 2.rep#1.cue _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(2.rep "Republican"
			  1.cue "Rep cue"
		      2.rep#1.cue "Republican x (Rep cue)"		
		)
	scalar(
		"lincompval P-val: Rep. + Rep. x (Rep cue) = 0"
		"demo Demographic controls"
		"r2 R-square" 
		"nobs Respondent-items"
		) 
	// title("Dep. var. is 1(response is congenial)")
;	

esttab using $tabsavedir/yougov-reg-table-fragment.tex, 
	b(%9.3fc)
	se(%9.3fc)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(2.rep 1.cue 2.rep#1.cue _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(2.rep "Republican"
			  1.cue "Rep. cue"
		      2.rep#1.cue "Republican x (Rep. cue)"		
		)
	scalar(
		"r2 R$^2$" 
		"lincompval P-val: Rep. + Rep. x (Rep cue) = 0"
		"demotab Demographic controls"
		"nobs Respondent-items"
		) 
	alignment(D{.}{.}{-1})
	substitute(\_ _)
	fragment booktabs replace        
	;
#delimit cr	
