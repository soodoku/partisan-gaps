encode pid2, gen(rep)

/* Unemployment (qpk7)
Unemployment rate since the 2010 midterm elections ...

Count Code Label
----- ---- -----
690 1 Gone Up
675 2 Remained the same
847 3 Gone Down
242 4 Can't Say
46 8 Skipped
0 9 Not Asked
*/
gen unempup = (qpk7=="Gone Up") 
label var unempup "Responded that unempployment has gone up"

/* Unemployment (qpk7)
Budget deficit since the 2010 midterm elections ...

Count Code Label
----- ---- -----
1576 1 Gone Up
441 2 Remained the same
160 3 Gone Down
284 4 Can't Say
39 8 Skipped
0 9 Not Asked
*/
gen deficitup = (qpk8=="Gone Up")
label var deficitup "Responded that budget deficit has gone up"


/* Partisan cue (qpk7_insert)
when Democrats retained control of  the Senate
when Republicans regained control of the US Cong
*/
gen cue = (strpos(qpk7_insert, "Rep")>0)
label var cue "=1 if Republican cue"


/* Demographics

*/
global demoX birthyr i.gender i.white i.educ i.marstat i.employ newsint i.faminc

rename gender gender_str
encode gender_str, gen(gender)

encode race, gen(white)

rename educ educ_str
encode educ_str, gen(educ)

rename marstat marstat_str
encode marstat_str, gen(marstat)

rename employ employ_str
encode employ_str, gen(employ)

rename faminc faminc_str
encode faminc_str, gen(faminc)
