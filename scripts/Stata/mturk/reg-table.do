
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
	b(%9.3fc)
	se(%9.3fc)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.rep *.survey _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(1.rep "Republican=1"
		      1.rep#1.survey "Republican=1 $\times$ 14k"		
		      1.rep#2.survey "Republican=1 $\times$ 24k"
		      1.rep#3.survey "Republican=1 $\times$ FSR"
		      1.rep#4.survey "Republican=1 $\times$ IPS"
		)
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
	b(%9.3fc)
	se(%9.3fc)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.rep *.survey _cons)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(1.rep "Republican=1"
		      1.rep#1.survey "Republican=1 $\times$ 14k"		
		      1.rep#2.survey "Republican=1 $\times$ 24k"
		      1.rep#3.survey "Republican=1 $\times$ FSR"
		      1.rep#4.survey "Republican=1 $\times$ IPS"
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
