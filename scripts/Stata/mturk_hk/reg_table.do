import delimited ../../data/mturk_hk/mturk_hk_relative_scoring_MC.csv, clear

rename responses responses_str
gen responses = (responses_str=="1")
replace responses = . if responses_str=="NA"

rename congenial congenial_str
gen congenial = (congenial_str=="1")
replace congenial = . if congenial_str=="NA"

rename survey survey_str
encode survey_str, gen(survey)

local q_items aca aca2 gg dt
local close_relscore (response_type=="closed" | response_type=="relscore_c_10")
eststo clear
foreach q_item in `q_items' {
	eststo: qui reg responses i.congenial##i.survey if q_item == "`q_item'" & `close_relscore', cluster(respondent) 
		estadd local itemFE "\multicolumn{1}{c}{No}"
		estadd local items 1
		estadd local Nrespondents = "\multicolumn{1}{c}{`e(N_clust)'}"
		local nobs: display %9.0fc `e(N)'
		estadd local nobs "\multicolumn{1}{c}{`nobs'}"
}
eststo: qui reghdfe responses i.congenial##i.survey if `close_relscore', absorb(q_item) cluster(respondent) 
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
	keep(_cons 1.congenial 2.survey 1.congenial#2.survey)
	obslast
	label
	nobase 	
	noobs
	nomtitle	
	coeflabel(
		_cons "Constant"
		1.congenial "Congenial"
		2.survey "Relative Scoring (RS)"
		1.congenial#2.survey "Congenial $\times$ RS"
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
	keep(_cons 1.congenial 2.survey 1.congenial#2.survey)
	obslast
	label
	nobase 	
	noobs
	nomtitle	
	coeflabel(
		_cons "Constant"
		1.congenial "Congenial"
		2.survey "Relative Scoring (RS)"
		1.congenial#2.survey "Congenial $\times$ RS"
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
