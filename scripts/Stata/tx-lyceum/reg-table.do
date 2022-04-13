eststo clear
eststo: qui reg unempup i.unempcongenial i.unempuncongenial, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"
eststo: qui reg unempup i.(unempcongenial unempuncongenial)##i.rep, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"
eststo: qui reg unempup i.(unempcongenial unempuncongenial)##i.rep $demoX, vce(hc3)
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
	keep(1.unempcongenial 1.unempuncongenial 1.rep 1.unempcongenial#1.rep 1.unempuncongenial#1.rep _cons)
	obslast
	label
	nobase 	
	nomtitle
	coeflabel(1.unempcongenial "Congenial cue"
			  1.unempuncongenial "Uncongenial cue"
			  1.rep "Republican"
		      1.unempcongenial#1.rep "Congenial cue x Republican"	
		      1.unempuncongenial#1.rep "Uncongenial cue x Republican"		
		      )
	scalar(
		"demo Demographic controls"
		"r2 R-square" 
		) 
	// title("Dep. var. is 1(response is congenial)")
;	

esttab using $tabsavedir/texas-unemp-reg-table-fragment.tex, 
	b(%9.3fc)
	se(%9.3fc)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.unempcongenial 1.unempuncongenial 1.rep 1.unempcongenial#1.rep 1.unempuncongenial#1.rep _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(1.unempcongenial "Congenial cue"
			  1.unempuncongenial "Uncongenial cue"
			  1.rep "Republican"
		      1.unempcongenial#1.rep "Congenial cue x Republican"	
		      1.unempuncongenial#1.rep "Uncongenial cue x Republican"		
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



*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Make the reg table for federal taxes

global congguess fedtaxcongenial fedtaxuncongenial fedtaxcongenialguess fedtaxuncongenialguess

eststo clear
eststo: qui reg fedtaxup $congguess, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"
eststo: qui reg fedtaxup $congguess $demoX, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"
	estadd local demo "Yes"
eststo: qui reg fedtaxdk $congguess, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"
eststo: qui reg fedtaxdk $congguess $demoX, vce(hc3)
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
	keep($congguess _cons)
	obslast
	label
	nobase 	
	nomtitle
	coeflabel(fedtaxcongenial "Congenial cue"
			  fedtaxuncongenial "Uncongenial cue"
			  fedtaxcongenialguess "Congenial cue w/ guess"
		      fedtaxuncongenialguess "Uncongenial cue w/ guess"	
		      )
	scalar(
		"demo Demographic controls"
		"r2 R-square" 
		) 
;	


esttab using $tabsavedir/texas-fedtax-reg-table-fragment.tex, 
	b(%9.3fc)
	se(%9.3fc)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep($congguess _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(fedtaxcongenial "Congenial cue"
			  fedtaxuncongenial "Uncongenial cue"
			  fedtaxcongenialguess "Congenial w/ guessing cue"
		      fedtaxuncongenialguess "Uncongenial w/ guessing cue"	
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
