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


gen unemp_dk = (q45a==4) | (q45b==4) | (q45c==4)
label var unemp_dk "Responded DK for unemployment"

/* Congenial cues 
Cue is congenial when the cue makes a partisan more likely to get the correct response (unemp went up)
This is when:
	* a R sees a D cue
	* a D sees a R cue
*/
rename sel03 q45arm

gen unempcongenial = (rep==1 & q45arm==3) | (rep==0 & q45arm==2)
gen unempuncongenial = (rep==1 & q45arm==2) | (rep==0 & q45arm==3)
gen unempneutral = (q45arm==1)
assert (unempcongenial + unempuncongenial + unempneutral)==1


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


// /* Cues 

// Cue is congenial when a Rep sees the Dem cue (Q46b)

// Cue is congenial w guessing encouraged when Rep sees the Dem cue with "based on what you have heard" (Q46C)

// Note: Only Rep can have congenial guess. Dem will have only neutral or uncongenial cues
// */
// rename sel04 q46arm

// gen fedtaxcongenial = (rep==1 & q46arm==2)
// gen fedtaxuncongenial = (rep==0 & q46arm==2)
// gen fedtaxcongenialguess = (rep==1 & q46arm==3)
// gen fedtaxuncongenialguess = (rep==0 & q46arm==3)
// gen fedtaxneutral = (q46arm==1)


// assert (fedtaxcongenial + fedtaxuncongenial + fedtaxcongenialguess + fedtaxuncongenialguess + fedtaxneutral)==1


/* Cues 

Cue is congenial when a Rep sees the Dem cue (Q46b)

Cue is congenial w guessing encouraged when Rep sees the Dem cue with "based on what you have heard" (Q46C)

Note: Only Rep can have congenial guess. Dem will have only neutral or uncongenial cues
*/
// gen tax_congenial = (dem==1)
// rename sel04 q46arm
// gen taxDcue = (q46arm==2)
// gen taxDcue_guess = (q46arm==3)

// reg fedtax_correct tax_congenial##(taxDcue taxDcue_guess), vce(hc3)

// reg fedtax_dk tax_congenial##(taxDcue taxDcue_guess), vce(hc3)
