set more off
import delimited $rootdir/data/turk/mturk-recoded.csv, clear
do ./mturk/preamble.do

* Drop CCD (confidence coding/24k)
drop if survey == 2

* Reshape from wide to long to stack participant-item observations
foreach item of varlist $items {
	rename `item' item`item'
}
reshape long item, i(id) j(item_type, string)

drop if pid_str=="Independent"

gen nonwhite = 1 - white
local spec3 i.rep##i.survey##nonwhite
local spec6 `spec3' $demo

eststo clear
foreach i in 3 6 {
eststo: reghdfe item `spec`i'', absorb(item_type) vce(cluster id)
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
esttab using $tabsavedir/mturk-reg-table-by-white-nonwhite-fragment.tex, 
	cell(
      b (fmt(%9.3fc) star) 
      se(par fmt(%9.3fc))
      p (par([ ]) fmt(%9.3fc))
    )  
    collabels(, none)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.rep *.survey *nonwhite* _cons)
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
			  1.nonwhite "Non-White"
		      1.rep#5.survey "Congenial $\times$ Cond. 2"
		      1.rep#3.survey "Congenial $\times$ Cond. 3"		
		      1.rep#1.survey "Congenial $\times$ Cond. 4"
		      1.rep#1.nonwhite "Congenial $\times$ Non-White"
		      5.survey#1.nonwhite "Cond. 2 $\times$ Non-White"
		      3.survey#1.nonwhite "Cond. 3 $\times$ Non-White"
		      1.survey#1.nonwhite "Cond. 4 $\times$ Non-White"
		      1.rep#5.survey#1.nonwhite "(Congenial $\times$ Cond. 2) $\times$ Non-White"
		      1.rep#3.survey#1.nonwhite "(Congenial $\times$ Cond. 3) $\times$ Non-White"
		      1.rep#1.survey#1.nonwhite "(Congenial $\times$ Cond. 4) $\times$ Non-White"
		)
	order(
		1.rep 5.survey 3.survey 1.survey 1.nonwhite
		1.rep#5.survey 1.rep#3.survey 1.rep#1.survey 1.rep#1.nonwhite
		5.survey#1.nonwhite 3.survey#1.nonwhite 1.survey#1.nonwhite
		1.rep#5.survey#1.nonwhite 1.rep#3.survey#1.nonwhite 1.rep#1.survey#1.nonwhite
	)
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
