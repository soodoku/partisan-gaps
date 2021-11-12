global items 	birth religion illegal death increase science fraud mmr deficit
global arms		RW IPS FSR 14k 24k
global demo 	age i.gender i.educ i.hisla i.race

rename v1 id
label var id "Participant ID"

rename avg avg_str
destring avg_str, gen(avg) force

*------------------------------------------------------------------------------
*** Response for the 9 items
label define itemResponseLabel 1 "Correct" 0 "Incorrect"

foreach var of varlist $items {
	tempvar _`var'
	gen `_`var'' = `var'
	drop `var'
	gen `var' = (`_`var''=="TRUE") if (`_`var''!="NA")
	label variable `var' "=1 if response is congenial to party for `var' item"
	label values `var' itemResponseLabel
}

replace deficit = 1 - deficit

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
encode gender_str, gen(gender) label(genderLabel)

foreach demo in educ hisla race {
	rename `demo' `demo'_str
	encode `demo'_str, gen(`demo')
}

*------------------------------------------------------------------------------
*** Survey types
encode question_type, gen(survey)
fvset base 5 survey // permanently set RW as base
