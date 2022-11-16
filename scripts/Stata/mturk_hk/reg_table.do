import delimited D:\partisan-gaps\data\mturk_hk\mturk_hk_MC_LIKERT.csv, clear

rename question questions_str
encode questions_str, gen(questions)

* Define likert == 1 if likert, 0 if multiple choice
rename condition condition_str
label define conditionLabel 0 "mc" 1 "scale"
encode condition_str, gen(likert) label(conditionLabel)

drop if independent ==1


* Item-level effect of LIKERT/Scale/CCD on proportion of correct response
global items aca aca2 gg dt 
eststo clear
foreach item in $items {
	qui eststo: reg correct i.republican##i.likert if questions_str=="`item'", cluster(respondent) 
		estadd local itemFE "\multicolumn{1}{c}{No}"
		estadd local items 1
		estadd local Nrespondents = "\multicolumn{1}{c}{`e(N_clust)'}"
		local nobs: display %9.0fc `e(N)'
		estadd local nobs "\multicolumn{1}{c}{`nobs'}"
}
* Average (over the four items) effect of LIKERT/Scale/CCD on proportion of correct response
qui eststo: reghdfe correct i.republican##i.likert, cluster(respondent) absorb(questions)
	estadd local itemFE "\multicolumn{1}{c}{Yes}"
	estadd local items 4
	estadd local Nrespondents = "\multicolumn{1}{c}{`e(N_clust)'}"
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "\multicolumn{1}{c}{`nobs'}"

#delimit;
esttab,
	b(%9.3fc)
	se(%9.3fc)
	varwidth(30)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.republican 1.likert 1.republican#1.likert)
	obslast
	label
	nobase 	
	noobs
	nomtitle	
	coeflabel(
		1.republican "Republican=1"
		1.likert "CCD"
		1.republican#1.likert "Republican=1 $\times$ CCD"
		)	
	scalar(
		"r2 R$^2$" 
		"itemFE Survey item FE"
		"items Items"
		"Nrespondents Respondents"
		"nobs Respondent-items"
		) 
	title("Dep. var. is 1(response is correct)")	
;

esttab using $tabsavedir/mturk-hk-reg-table-fragment.tex, 
	b(%9.3fc)
	se(%9.3fc)
	varwidth(20)
	modelwidth(8)	
	star (+ 0.1 * 0.05 ** 0.01 *** 0.001)
	keep(1.republican 1.likert 1.republican#1.likert)
	obslast
	label
	nobase 	
	noobs
	nomtitle
	coeflabel(
		1.republican "Republican=1"
		1.likert "CCD"
		1.republican#1.likert "Republican=1 $\times$ CCD"
		)	
	scalar(
		"r2 R$^2$" 
		"itemFE Survey item FE"
		"items Items"
		"Nrespondents Respondents"
		"nobs Respondent-items"
		) 
	alignment(D{.}{.}{-1})
	substitute(\_ _)
	fragment booktabs replace        
;

#delimit cr



