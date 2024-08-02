**** Basic prep of data
import delimited D:/partisan-gaps/data/survey_exp/selex.csv, clear

gen rep = (pid2=="Republican")
gen dem = (pid2=="Democrat")
gen ind = (pid3=="Independent")
encode pid3, gen(partisanship)

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
// gen unempup = (qpk7=="Gone Up") 
// label var unempup "Responded that unempployment has gone up"
gen unemp_correct = (qpk7=="Gone Down") 
label var unemp_correct "=1 if correctly responded that unemp. went down"

/* Budget deficit (qpk8)
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
// gen deficitup = (qpk8=="Gone Up")
// label var deficitup "Responded that budget deficit has gone up"
gen deficit_correct = (qpk8=="Gone Down") 
label var deficit_correct "=1 if correctly responded that deficit went down"

/* Demographics*/
global demoX birthyr i.gender i.white i.educ i.marstat i.employ i.newsint i.faminc

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


* Congenial cues 
* Correct answer is congenial to D if both unemp/deficit dropped during Obama's term
* This is the same as party - specifically D
gen congenial = (dem==1)

/* Partisan cue (qpk7_insert)
when Democrats retained control of the Senate
when Republicans regained control of the US Cong
*/
* Defining Dcue at question level
gen Dcue = (strpos(qpk7_insert, "when Democrats retained control of the Senate")>0)
label var Dcue "=1 if Dem. cue"
gen Rcue = 1 - Dcue
label var Rcue "=1 if Rep. cue"

drop if ind==1
