/* 
Multiple choice sample: MTurks HK 
*/
import delimited D:/partisan-gaps/data/mturk_hk/mturk_hk_MC.csv, clear

rename congenial congenial_str
drop if congenial_str=="NA"
encode congenial_str, gen(congenial)

rename questions questions_str
encode questions_str, gen(questions)

reg responses i.congenial i.questions, cluster(respondent)
eststo mc


/* 
Likert scale sample: MTurks HK 
*/
import delimited D:/partisan-gaps/data\mturk_hk/mturk_hk_LIKERT.csv, clear

rename congenial congenial_str
drop if congenial_str=="NA"
encode congenial_str, gen(congenial)

rename questions questions_str
encode questions_str, gen(questions)

rename scale_mc_c_10 scale_mc_c_10_str
drop if scale_mc_c_10_str=="NA"
encode scale_mc_c_10_str, gen(scale_mc_c_10)

reg scale_mc_c_10 i.congenial i.questions, cluster(respondent)
eststo scale


/* 
Plot the stored coefficients for congenial
*/
local MSIZE huge
local MLWIDTH vvvthin
local MARKER_OPTS msize(`MSIZE') mlwidth(`MLWIDTH')

#delimit;
coefplot 
	(mc, msymbol(O) `MARKER_OPTS') 
	(scale, msymbol(dh) `MARKER_OPTS'), 
	keep(2.congenial) 
	coeflabels(2.congenial = `""Congenial" "partisanship""', labsize(large))
	ciopts(lwidth(medthick)) 
	xlabel(0(.03).09, labsize(medlarge))
	scheme(lean2)
	plotregion(lcolor(black) lwidth(medthin) margin(0 0 0 0)) 	
	legend(
		label(2 "Multiple Choice") 
		label(4 "Likert Scale")
		// title({bf:Condition})
		size(large)
		col(1) ring(0)
		)
;
#delimit cr
graph export "$figsavedir/mturk-hk-MC-LIKERT.pdf", replace	
