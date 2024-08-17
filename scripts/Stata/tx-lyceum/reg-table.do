use "$rootdir/data/tx_lyceum/Texas Lyceum 2012 Data.dta", clear
do ./tx-lyceum/preamble.do

// =============================================================
// Table 4 - Unemp
// =============================================================
* Defining at question level
gen congenial = (dem == 1)

/* Defining unempup = dep. var. for Q45 (Unemployment)
Since the 2010 midterm elections...
Q45a = ..., has the unemployment rate gone up, gone down, or remained the same?  Or couldn’t you say?
Q45b = ... when Republicans regained control of the U.S. Congress, has the unemployment rate gone up, gone down, or remained the same?  Or couldn’t you say?
Q45C = ... when the Democrats retained control of the Senate, has the unemployment rate gone up, gone down, or remained the same?  Or couldn’t you say?
*/
gen Neutralcue = (q45arm==1)
gen Rcue = (q45arm==2)
gen Dcue = (q45arm==3)

// su unemp_correct if dem & Neutralcue
// * .36
// su unemp_correct if rep & Neutralcue
// * .20
// * Baseline Gap = .16
// su unemp_correct if dem & Dcue
// * .42
// su unemp_correct if rep & Dcue
// * .14
// * inflate gap = .28
// su unemp_correct if dem & Rcue
// * .28
// su unemp_correct if rep & Rcue
// * .19
// * inflate gap v2 = .09

eststo: reg unemp_correct i.congenial##(i.Neutralcue Dcue), vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"

eststo: reg unemp_correct i.congenial##(i.Neutralcue Dcue) $demoX, vce(hc3)
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
		1.Neutralcue
		1.Dcue
		1.congenial#1.Neutralcue
		1.congenial#1.Dcue
		_cons
	)
	obslast
	label
	nobase 	
	nomtitle
	coeflabel(
		1.congenial "Congenial"
		1.Neutralcue "Neutral cue"
		1.Dcue "Democratic cue"
		1.congenial#1.Neutralcue "Congenial x Neutral cue"
		1.congenial#1.Dcue "Congenial x Democratic cue"
	)
	scalar(
		"demo Demographic controls"
		"r2 R-square" 
	) 
;	

esttab using $tabsavedir/texas-unemp-reg-table-fragment.tex, 
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
		1.Neutralcue
		1.Dcue
		1.congenial#1.Neutralcue
		1.congenial#1.Dcue
		_cons
	)	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(
		1.congenial "Congenial"
		1.Neutralcue "Neutral cue"
		1.Dcue "Democratic cue"
		1.congenial#1.Neutralcue "Congenial x Neutral cue"
		1.congenial#1.Dcue "Congenial x Democratic cue"
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

// =============================================================
// Table 5 - Fed tax
// =============================================================
* Defining at question level
drop congenial Dcue Rcue Neutralcue

/* Defining fedtaxup = dep. var. for Q46 (Fed taxes)
Since the 2010 midterm elections...
Q46a = Since January 2009, have federal taxes increased, decreased, or remained the same.
Q46b = Since Barack Obama took office, have federal taxes increased, decreased, or remained the same.
Q46C = Based on what you have heard, since Barack Obama took office, have federal taxes increased, decreased, or remained the same.
*/
gen congenial = (dem == 1)
gen Neutralcue = (q46arm == 1)
gen Dcue = (q46arm == 2)
gen Dcue_guess = (q46arm == 3)

su fedtax_correct if dem & Neutralcue
* .40
su fedtax_correct if rep & Neutralcue
* .30
* Baseline Gap = .10
su fedtax_correct if dem & Dcue
* .46
su fedtax_correct if rep & Dcue
* .25
* inflate gap = .21
su fedtax_correct if dem & Dcue_guess
* .41
su fedtax_correct if rep & Dcue_guess
* .37
* inflate gap v2 = .04

eststo clear
eststo: reg fedtax_correct i.congenial##i.(Dcue Dcue_guess), vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{.}"
	test 1.congenial#1.Dcue = 1.congenial#1.Dcue_guess
eststo: reg fedtax_correct i.congenial##(Dcue Dcue_guess) $demoX, vce(hc3)
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
	estadd local demotab "\multicolumn{1}{c}{Yes}"
	estadd local demo "Yes"
	test 1.congenial#1.Dcue = 1.congenial#1.Dcue_guess

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
		1.Dcue_guess
		1.congenial#1.Dcue
		1.congenial#1.Dcue_guess
		_cons		
	)
	obslast
	label
	nobase 	
	nomtitle
	coeflabel(
		1.congenial "Congenial"
		1.Dcue "Democratic cue"
		1.Dcue_guess "Democratic cue w/ guess cue"
		1.congenial#1.Dcue "Congenial x Democratic cue"
		1.congenial#1.Dcue_guess "Congenial x Democratic cue w/ guess cue"		
	)
	scalar(
		"demo Demographic controls"
		"r2 R-square" 
	) 
;	

esttab using $tabsavedir/texas-fedtax-reg-table-fragment.tex, 
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
		1.Dcue_guess
		1.congenial#1.Dcue
		1.congenial#1.Dcue_guess
		_cons		
	)	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(
		1.congenial "Congenial"
		1.Dcue "Democratic cue"
		1.Dcue_guess "Democratic cue w/ guess cue"
		1.congenial#1.Dcue "Congenial x Democratic cue"
		1.congenial#1.Dcue_guess "Congenial x Democratic cue w/ guess cue"		
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
