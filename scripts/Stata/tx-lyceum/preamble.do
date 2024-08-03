use "D:/partisan-gaps/data/tx_lyceum/Texas Lyceum 2012 Data.dta", clear

/* Demographics */
global demoX news agecohort i.married i.children i.schoolm1 i.income i.edu i.religion i.race i.libcon i.gender

encode ageo, gen(agecohort)

gen rep = (pid==2) 
gen dem = (pid==1) 
drop if pid == 3 /* drop Neither */ 
drop if pid == 4 /* DK/Refused */ 

/* Defining unempup = dep. var. for Q45 (Unemployment)
Since the 2010 midterm elections...
Q45a = ..., has the unemployment rate gone up, gone down, or remained the same?  Or couldn’t you say?
Q45b = ... when Republicans regained control of the U.S. Congress, has the unemployment rate gone up, gone down, or remained the same?  Or couldn’t you say?
Q45C = ... when the Democrats retained control of the Senate, has the unemployment rate gone up, gone down, or remained the same?  Or couldn’t you say?

1.  Gone up
2.  Gone down
3.  Stayed the same
4.  Couldn’t say
*/
// gen unempup = (q45a==1) | (q45b==1) | (q45c==1)
// label var unempup "Responded that unemployment rate has gone up"
* Correct answer = Gone Down
gen unemp_correct = (q45a==2) | (q45b==2) | (q45c==2)
label var unemp_correct "= 1 if correctly responded that unemp. went down"

rename sel03 q45arm

/* Defining fedtaxup = dep. var. for Q46 (Fed taxes)
Since the 2010 midterm elections...
Q46a = Since January 2009, have federal taxes increased, decreased, or remained the same.
Q46b = Since Barack Obama took office, have federal taxes increased, decreased, or remained the same.
Q46C = Based on what you have heard, since Barack Obama took office, have federal taxes increased, decreased, or remained the same.

1.  Increased
2.  Decreased
3.  Remained the same
4.  Couldn’t say
*/
// gen fedtaxup = (q46a==1) | (q46b==1) | (q46c==1)
// label var fedtaxup "Responded that federal taxes has gone up"
gen fedtax_correct = (q46a==3) | (q46b==3) | (q46c==3)
label var fedtax_correct "= 1 if correctly responded that fed tax remained the same"

gen fedtax_dk = (q46a==4) | (q46b==4) | (q46c==4)
label var fedtax_dk "Responded DK for has federal taxes has gone up?"

rename sel04 q46arm
