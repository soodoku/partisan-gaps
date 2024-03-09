use "D:/partisan-gaps/data/tx_lyceum/Texas Lyceum 2012 Data.dta", clear
do ./tx-lyceum/preamble.do
set more off

eststo clear
logit unempup i.unempcongenial i.unempuncongenial, vce(robust)
	eststo: margins, dydx(*) post
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

logit unempup i.unempcongenial i.unempuncongenial $demoX, vce(robust)
	eststo: margins, dydx(*) post
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
	keep(1.unempcongenial 1.unempuncongenial)
	obslast
	label
	nobase 	
	nomtitle
	coeflabel(1.unempcongenial "Congenial"
			  1.unempuncongenial "Uncongenial"
			  1.rep "Republican"
		      1.unempcongenial#1.rep "Congenial x Republican"	
		      1.unempuncongenial#1.rep "Uncongenial x Republican"		
		      )
	scalar(
		"demo Demographic controls"
		) 
;	

esttab using $tabsavedir/texas-unemp-reg-table-logitME-fragment.tex, 
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )  
    collabels(, none)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.unempcongenial 1.unempuncongenial)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(1.unempcongenial "Congenial"
			  1.unempuncongenial "Uncongenial"
			  1.rep "Republican"
		      1.unempcongenial#1.rep "Congenial x Republican"	
		      1.unempuncongenial#1.rep "Uncongenial x Republican"		
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


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Make the reg table for federal taxes

global congguess fedtaxcongenial fedtaxuncongenial fedtaxcongenialguess fedtaxuncongenialguess

eststo clear
logit fedtaxup $congguess, vce(robust)
	eststo: margins, dydx(*) post
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"
logit fedtaxup $congguess $demoX, vce(robust)
	eststo: margins, dydx(*) post
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"
	estadd local demo "Yes"
logit fedtaxdk $congguess, vce(robust)
	eststo: margins, dydx(*) post
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"
logit fedtaxdk $congguess $demoX, vce(robust)
	eststo: margins, dydx(*) post
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
	keep($congguess)
	obslast
	label
	nobase 	
	nomtitle
	coeflabel(fedtaxcongenial "Congenial"
			  fedtaxuncongenial "Uncongenial"
			  fedtaxcongenialguess "Congenial w/ guess"
		      fedtaxuncongenialguess "Uncongenial w/ guess"	
		      )
	scalar(
		"demo Demographic controls"
		) 
;	


esttab using $tabsavedir/texas-fedtax-reg-table-logitME-fragment.tex, 
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )  
    collabels(, none)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep($congguess)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(fedtaxcongenial "Congenial"
			  fedtaxuncongenial "Uncongenial"
			  fedtaxcongenialguess "Congenial w/ guessing"
		      fedtaxuncongenialguess "Uncongenial w/ guessing"	
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
