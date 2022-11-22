global arms		RW IPS FSR 14k 24k
global demo 	age i.female i.educ i.hisla $races

rename v1 id
label var id "Participant ID"

*------------------------------------------------------------------------------
*** Response for the 9 items
global items 	birth religion illegal death increase science fraud mmr deficit
label define itemResponseLabel 1 "Correct" 0 "Incorrect"

foreach var of varlist $items {
	tempvar _`var'
	gen `_`var'' = `var'
	drop `var'
	gen `var' = (`_`var''=="TRUE") if (`_`var''!="NA")
	label variable `var' "=1 if response is wrong and congenial to R for `var' item"
	* If we define it as correct and congenial to D, and then use D as the "congenial dummy". it's going
	* to be the same. (Independents dropped)
	// replace `var' = 1 - `var'
	// label variable `var' "=1 if response is correct and congenial for D for `var' item"
	label values `var' itemResponseLabel
}
* deficif seems to have been coded differently compared to previous 8 items
* https://github.com/soodoku/partisan-gaps/blob/main/scripts/02_mturk_recode.R
replace deficit = 1 - deficit 

rename avg avg_str
destring avg_str, gen(avg) force
label variable avg "Avg of the 9 survey questions"

*------------------------------------------------------------------------------
*** pid
rename pid pid_str
drop if pid_str =="Something else"

label define pidLabel 1 "Democrat" 2 "Independent" 3 "Republican"
encode pid_str, gen(pid) label(pidLabel)

fvset base 2 pid // permanently set Independent as base

gen rep = (pid_str=="Republican") if !missing(pid_str)


*------------------------------------------------------------------------------
*** Demo
rename gender gender_str
label define genderLabel 0 "Male" 1 "Female"
encode gender_str, gen(female) label(genderLabel)

foreach demo in educ hisla race {
	rename `demo' `demo'_str
	encode `demo'_str, gen(`demo')
}

gen asian = strmatch(race_str, "Asian*")
gen black = strmatch(race_str, "Black*")
gen white = strmatch(race_str, "White*")
gen others = strmatch(race_str, "Other*")
global races asian black white others

*------------------------------------------------------------------------------
*** Survey types
encode question_type, gen(survey)
fvset base 4 survey // permanently set IPS (IDA) as base
