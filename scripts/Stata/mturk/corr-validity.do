import delimited $rootdir/data/turk/mturk-recoded.csv, clear
do ./mturk/preamble.do
// =================================================================================

tab interest_1
tab vote_1
tab deficit
tab educ
tab survey

// =================================================================================
// Coding correct responses (for the four groups: ips rw fsr x14k)
// =================================================================================
* 1 birth
local _stem "birth"
local _correct = "The US"
foreach qtype in ips rw fsr x14k {
	local _correct_indicator c`_stem'_`qtype'
	local _original_response `qtype'_`_stem'
	cap drop `_correct_indicator'
	gen byte `_correct_indicator' = (strpos(`_original_response', "`_correct'")>0) if ~missing(`_original_response')
}
* 14k has a space after "The US" --> "The US "

* 2 religion
local _stem "religion"
local _correct = "Christian"
foreach qtype in ips rw fsr x14k {
	local _correct_indicator c`_stem'_`qtype'
	local _original_response `qtype'_`_stem'
	cap drop `_correct_indicator'
	gen byte `_correct_indicator' = (`_original_response'=="`_correct'") if ~missing(`_original_response')
}

* 3 illegal
local _stem "illegal"
local _correct = "not give illegal immigrants"
foreach qtype in ips rw fsr x14k {
	local _correct_indicator c`_stem'_`qtype'
	local _original_response `qtype'_`_stem'
	cap drop `_correct_indicator'
	gen byte `_correct_indicator' = (strpos(strlower(`_original_response'), "`_correct'")>0) if ~missing(`_original_response')
}

* 4 death
local _stem "death"
local _correct = "Does not create government panels to make decisions about end-of-life care"
foreach qtype in ips rw fsr x14k {
	local _correct_indicator c`_stem'_`qtype'
	local _original_response `qtype'_`_stem'
	cap drop `_correct_indicator'
	gen byte `_correct_indicator' = (`_original_response'=="`_correct'") if ~missing(`_original_response')
}

* 5 increase
local _stem "increase"
local _correct = "human activity"
foreach qtype in ips rw fsr {
	local _correct_indicator c`_stem'_`qtype'
	local _original_response `qtype'_`_stem'
	cap drop `_correct_indicator'
	gen byte `_correct_indicator' = (strpos(strlower(`_original_response'), "`_correct'")>0) if ~missing(`_original_response')
}
* 14k phrases differently
* with "Increasing because human activity,..." instead of
* with "Increasing because of human activity,..."
local _correct = "Increasing because human activity, like burning coal and gasoline"
local _correct_indicator c`_stem'_x14k
local _original_response x14k_`_stem'
cap drop `_correct_indicator'
gen byte `_correct_indicator' = (`_original_response'=="`_correct'") if ~missing(`_original_response')

* 6 science
local _stem "science"
local _correct = "Most climate scientists believe that global warming is occurring"
foreach qtype in ips rw fsr x14k {
	local _correct_indicator c`_stem'_`qtype'
	local _original_response `qtype'_`_stem'
	cap drop `_correct_indicator'
	gen byte `_correct_indicator' = (`_original_response'=="`_correct'") if ~missing(`_original_response')
}

* 7 fraud
local _stem "fraud"
local _correct = "Did not win the majority of the legally cast votes"
foreach qtype in ips rw fsr x14k {
	local _correct_indicator c`_stem'_`qtype'
	local _original_response `qtype'_`_stem'
	cap drop `_correct_indicator'
	gen byte `_correct_indicator' = (`_original_response'=="`_correct'") if ~missing(`_original_response')
}

* 8 mmr
local _stem "mmr"
local _correct = "not cause autism"
foreach qtype in ips rw fsr x14k {
	local _correct_indicator c`_stem'_`qtype'
	local _original_response `qtype'_`_stem'
	cap drop `_correct_indicator'
	gen byte `_correct_indicator' = (strpos(strlower(`_original_response'), "`_correct'")>0) if ~missing(`_original_response')
}
// * 14k phrases differently
// * with "Not cause autism in children" instead of
// * with "Does not cause autism is children"

// * fsr phrases differently (correctly)
// * with "Not cause autism in children" instead of
// * with "Does not cause autism is children"

* 9 deficit
local _stem "deficit"
local _correct = "increased"
foreach qtype in ips rw fsr x14k {
	local _correct_indicator c`_stem'_`qtype'
	local _original_response `qtype'_`_stem'
	cap drop `_correct_indicator'
	gen byte `_correct_indicator' = (strpos(strlower(`_original_response'), "`_correct'")>0) if ~missing(`_original_response')
}

// =================================================================================
// Coding correct responses (for x24k)
* 1 birth
local _stem "birth"
local _correct_indicator c`_stem'_x24k
cap drop `_correct_indicator' 
gen double `_correct_indicator' = (x24k_`_stem'=="10") if x24k_`_stem'!="NA"

* 2 religion
local _stem "religion"
local _correct_indicator c`_stem'_x24k
cap drop `_correct_indicator' 
gen double `_correct_indicator' = (x24k_`_stem'=="0") if x24k_`_stem'!="NA"

* 3 illegal
local _stem "illegal"
local _correct_indicator c`_stem'_x24k
cap drop `_correct_indicator' 
gen double `_correct_indicator' = (x24k_`_stem'=="0") if x24k_`_stem'!="NA"

* 4 death
local _stem "death"
local _correct_indicator c`_stem'_x24k
cap drop `_correct_indicator' 
gen double `_correct_indicator' = (x24k_`_stem'=="10") if x24k_`_stem'!="NA"

* 5 increase
local _stem "increase"
local _correct_indicator c`_stem'_x24k
cap drop `_correct_indicator' 
gen double `_correct_indicator' = (x24k_`_stem'=="10") if x24k_`_stem'!="NA"

* 6 science
local _stem "science"
local _correct_indicator c`_stem'_x24k
cap drop `_correct_indicator' 
gen double `_correct_indicator' = (x24k_`_stem'=="0") if x24k_`_stem'!="NA"

* 7 fraud
local _stem "fraud"
local _correct_indicator c`_stem'_x24k
cap drop `_correct_indicator' 
gen double `_correct_indicator' = (x24k_`_stem'=="0") if x24k_`_stem'!="NA"

* 8 mmr
local _stem "mmr"
local _correct_indicator c`_stem'_x24k
cap drop `_correct_indicator' 
gen double `_correct_indicator' = (x24k_`_stem'=="0") if x24k_`_stem'!="NA"

* 9 deficit
local _stem "deficit"
local _correct_indicator c`_stem'_x24k
cap drop `_correct_indicator' 
gen double `_correct_indicator' = (x24k_`_stem'=="10") if x24k_`_stem'!="NA"


// =================================================================================
// Tally totals by the 5 question types
foreach qtype in ips rw fsr x14k x24k {
	cap drop cavg_`qtype'
	egen double cavg_`qtype' = rowtotal(cbirth_`qtype' creligion_`qtype' cillegal_`qtype' cdeath_`qtype' cincrease_`qtype' cscience_`qtype' cfraud_`qtype' cmmr_`qtype' cdeficit_`qtype') if ~missing(cbirth_`qtype')
	replace cavg_`qtype' = cavg_`qtype'/9
}


gen double cavg = .
replace cavg = cavg_ips if question_type=="IPS"
replace cavg = cavg_rw if question_type=="RW"
replace cavg = cavg_fsr if question_type=="FSR"
replace cavg = cavg_x14k if question_type=="14k"
replace cavg = cavg_x24k if question_type=="24k"

su cavg*


// =================================================================================
// Make education continuous
cap drop ceduc
gen ceduc = .
replace ceduc = 1 if educ_str=="No high school diploma"
replace ceduc = 2 if educ_str=="High school diploma or equivalent"
replace ceduc = 3 if educ_str=="Some college"
replace ceduc = 4 if educ_str=="Four year college graduate"
replace ceduc = 5 if educ_str=="Post-graduate degree"

// Score the knowledge question
cap drop know
gen know = .
replace know = (deficits=="Democratic party is better at that") & ~missing(deficits)

global criteria interest_1 vote_1 ceduc


// =================================================================================
// =================================================================================
// Correlation with criterion
// =================================================================================
foreach qtype in ips rw fsr x14k x24k {
foreach criterion of global criteria {
	corr cavg_`qtype' `criterion'
	local corr_`qtype'_`criterion' = r(rho)
	corr_pval
	local corrpval_`qtype'_`criterion' = r(corr_pval)
	dis in white `corr_`qtype'_`criterion''
}
}

#delimit;
matrix corr_table2 = (
	`corr_ips_interest_1', `corr_rw_interest_1', `corr_fsr_interest_1', `corr_x14k_interest_1', `corr_x24k_interest_1' \
	// `corrpval_ips_interest_1', `corrpval_rw_interest_1', `corrpval_fsr_interest_1', `corrpval_x14k_interest_1', `corrpval_x24k_interest_1' \
	`corr_ips_vote_1', `corr_rw_vote_1', `corr_fsr_vote_1', `corr_x14k_vote_1', `corr_x24k_vote_1' \
	// `corrpval_ips_vote_1', `corrpval_rw_vote_1', `corrpval_fsr_vote_1', `corrpval_x14k_vote_1', `corrpval_x24k_vote_1' \
	`corr_ips_ceduc', `corr_rw_ceduc', `corr_fsr_ceduc', `corr_x14k_ceduc', `corr_x24k_ceduc'
	// `corrpval_ips_ceduc', `corrpval_rw_ceduc', `corrpval_fsr_ceduc', `corrpval_x14k_ceduc', `corrpval_x24k_ceduc' 
	// `corr_ips_pid_strength_1', `corr_rw_pid_strength_1', `corr_fsr_pid_strength_1', `corr_x14k_pid_strength_1', `corr_x24k_pid_strength_1' 
)
;
#delimit cr
matrix colnames corr_table2 = "IPS/IDA" "RW/CUD" "FSR/FSR" "14k/IMC" "24k/CCD" 
// matrix rownames corr_table2 = "interest" "." "participation" "." "education" "."
matrix rownames corr_table2 = "Politicalinterest" "Politicalparticipation" "Education"
matlist corr_table2, format(%6.3f)

dis `corrpval_ips_interest_1'
#delimit;
matrix corr_table2_pval = (
	`corr_ips_interest_1', `corr_rw_interest_1', `corr_fsr_interest_1', `corr_x14k_interest_1', `corr_x24k_interest_1' \
	`corrpval_ips_interest_1', `corrpval_rw_interest_1', `corrpval_fsr_interest_1', `corrpval_x14k_interest_1', `corrpval_x24k_interest_1' \
	`corr_ips_vote_1', `corr_rw_vote_1', `corr_fsr_vote_1', `corr_x14k_vote_1', `corr_x24k_vote_1' \
	`corrpval_ips_vote_1', `corrpval_rw_vote_1', `corrpval_fsr_vote_1', `corrpval_x14k_vote_1', `corrpval_x24k_vote_1' \
	`corr_ips_ceduc', `corr_rw_ceduc', `corr_fsr_ceduc', `corr_x14k_ceduc', `corr_x24k_ceduc' \
	`corrpval_ips_ceduc', `corrpval_rw_ceduc', `corrpval_fsr_ceduc', `corrpval_x14k_ceduc', `corrpval_x24k_ceduc' 
)
;
#delimit cr
matrix colnames corr_table2_pval = "IPS/IDA" "RW/CUD" "FSR/FSR" "14k/IMC" "24k/CCD" 
matrix rownames corr_table2_pval = "interest" "(pval)" "participation" "(pval)" "education" "(pval)"
matlist corr_table2_pval

// Output
preserve
drop _all
svmat2 corr_table2, rnames(type) // Adding to dta temporarily
order type
foreach var of varlist corr_table21 corr_table22 corr_table23 corr_table24 corr_table25 {
	replace `var' = round(`var', 0.001)
}
list
texsave using ../../tabs/correlation-validity-table.tex, dataonly replace 
restore

// =================================================================================
// =================================================================================
// Inter-item correlation, by group
// =================================================================================
local CRONBACH_ALPHA_OPTS asis item std

// Inter-item correlation for correct responses as the items
global correct_items_ips  cbirth_ips  creligion_ips  cillegal_ips  cdeath_ips  cincrease_ips  cscience_ips  cfraud_ips  cmmr_ips  cdeficit_ips
global correct_items_rw   cbirth_rw   creligion_rw   cillegal_rw   cdeath_rw   cincrease_rw   cscience_rw   cfraud_rw   cmmr_rw   cdeficit_rw
global correct_items_fsr  cbirth_fsr  creligion_fsr  cillegal_fsr  cdeath_fsr  cincrease_fsr  cscience_fsr  cfraud_fsr  cmmr_fsr  cdeficit_fsr
global correct_items_x14k cbirth_x14k creligion_x14k cillegal_x14k cdeath_x14k cincrease_x14k cscience_x14k cfraud_x14k cmmr_x14k cdeficit_x14k
global correct_items_x24k cbirth_x24k creligion_x24k cillegal_x24k cdeath_x24k cincrease_x24k cscience_x24k cfraud_x24k cmmr_x24k cdeficit_x24k


alpha $correct_items_ips, `CRONBACH_ALPHA_OPTS'
alpha $correct_items_rw, `CRONBACH_ALPHA_OPTS'
alpha $correct_items_fsr, `CRONBACH_ALPHA_OPTS'
alpha $correct_items_x14k, `CRONBACH_ALPHA_OPTS'
alpha $correct_items_x24k, `CRONBACH_ALPHA_OPTS'
