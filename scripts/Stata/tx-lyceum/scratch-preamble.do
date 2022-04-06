// use "D:\partisan-gaps\data\tx_lyceum\Texas Lyceum 2012 Data.dta", clear

/* Demographics */
global demoX news agecohort i.married i.children i.schoolm1 i.income i.edu i.religion i.race i.libcon i.gender

encode ageo, gen(agecohort)

gen rep = 0
replace rep = (pid==2) 
replace rep = . if pid >=3 /* drop party DK or neither*/ 
label var rep "=1 if Republican"


/* Defining yq45 = dep. var. for Q45 (Unemployment)
Since the 2010 midterm elections...
Q45a = ..., has the unemployment rate gone up, gone down, or remained the same?  Or couldn’t you say?
Q45b = ... when Republicans regained control of the U.S. Congress, has the unemployment rate gone up, gone down, or remained the same?  Or couldn’t you say?
Q45C = ... when the Democrats retained control of the Senate, has the unemployment rate gone up, gone down, or remained the same?  Or couldn’t you say?

1.  Gone up
2.  Gone down
3.  Stayed the same
4.  Couldn’t say
*/
gen q45 = q45a if !missing(q45a)
replace q45 = q45b if !missing(q45b)
replace q45 = q45c if !missing(q45c)
rename sel03 q45arm

gen yq45 = (q45==1) 


/* Defining yq46 = dep. var. for Q46 (Fed taxes)
Since the 2010 midterm elections...
Q46a = Since January 2009, have federal taxes increased, decreased, or remained the same.
Q46b = Since Barack Obama took office, have federal taxes increased, decreased, or remained the same.
Q46C = Based on what you have heard, since Barack Obama took office, have federal taxes increased, decreased, or remained the same.

1.  Increased
2.  Decreased
3.  Remained the same
4.  Couldn’t say
*/
gen q46 = q46a if !missing(q46a)
replace q46 = q45b if !missing(q46b)
replace q46 = q45c if !missing(q46c)
rename sel04 q46arm

gen yq46 = (q46==1) 


