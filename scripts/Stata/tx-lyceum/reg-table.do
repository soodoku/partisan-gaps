// do tx-lyceum/preamble
eststo clear

// =============================================================
// Table 4 - Unemp
// =============================================================
* Defining at question level
gen congenial = (dem == 1)
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

// aa
// *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// * Make the reg table for federal taxes

// global congguess fedtaxcongenial fedtaxuncongenial fedtaxcongenialguess fedtaxuncongenialguess


// eststo clear
// eststo: qui reg fedtax_correct $congguess, vce(hc3)
// 	local nobs: display %9.0fc `e(N)'
// 	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
// 	estadd local demotab "\multicolumn{1}{c}{.}"
// eststo: qui reg fedtax_correct $congguess $demoX, vce(hc3)
// 	local nobs: display %9.0fc `e(N)'
// 	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
// 	estadd local demotab "\multicolumn{1}{c}{Yes}"
// 	estadd local demo "Yes"
// eststo: qui reg fedtax_dk $congguess, vce(hc3)
// 	local nobs: display %9.0fc `e(N)'
// 	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
// 	estadd local demotab "\multicolumn{1}{c}{.}"
// eststo: reg fedtax_dk $congguess $demoX, vce(hc3)
// 	local nobs: display %9.0fc `e(N)'
// 	estadd local nobs "\multicolumn{1}{c}{`nobs'}"
// 	estadd local demotab "\multicolumn{1}{c}{Yes}"
// 	estadd local demo "Yes"
// 	test fedtaxcongenial = fedtaxcongenialguess
// 	test fedtaxuncongenial = fedtaxuncongenialguess

// #delimit;
// esttab,
// 	cell(
//       b (fmt(%9.3fc) star) 
//       se(par fmt(%9.3fc))
//       p (par([ ]) fmt(%9.3fc))
//     )  
//     collabels(, none)
// 	varwidth(30)
// 	modelwidth(8)	
// 	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
// 	keep($congguess _cons)
// 	obslast
// 	label
// 	nobase 	
// 	nomtitle
// 	coeflabel(fedtaxcongenial "Congenial"
// 			  fedtaxuncongenial "Uncongenial"
// 			  fedtaxcongenialguess "Congenial w/ guess"
// 		      fedtaxuncongenialguess "Uncongenial w/ guess"	
// 		      )
// 	scalar(
// 		"demo Demographic controls"
// 		"r2 R-square" 
// 		) 
// ;	


// esttab using $tabsavedir/texas-fedtax-reg-table-fragment.tex, 
// 	cell(
//       b (fmt(%9.3fc) star) 
//       se(par fmt(%9.3fc))
//       p (par([ ]) fmt(%9.3fc))
//     )  
//     collabels(, none)
// 	varwidth(20)
// 	modelwidth(8)	
// 	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
// 	keep($congguess _cons)
// 	obslast
// 	label
// 	nobase 	
// 	noobs
// 	nomtitle
// 	coeflabel(fedtaxcongenial "Congenial"
// 			  fedtaxuncongenial "Uncongenial"
// 			  fedtaxcongenialguess "Congenial w/ guessing"
// 		      fedtaxuncongenialguess "Uncongenial w/ guessing"	
// 		      )
// 	scalar(
// 		"r2 R$^2$" 
// 		"demotab Demographic controls"
// 		"nobs Respondents"
// 		) 
// 	alignment(D{.}{.}{-1})
// 	substitute(\_ _)
// 	fragment booktabs replace        
// 	;
// #delimit cr	
