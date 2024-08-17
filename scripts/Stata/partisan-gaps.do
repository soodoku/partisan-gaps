* -----------------------------------------------------------------------------
* Program Setup
* -----------------------------------------------------------------------------
cls 					// Clear results window
clear all               // Start with a clean slate
set more off            // Disable partitioned output
macro drop _all         // Clear all macros to avoid namespace conflicts
set linesize 120        // Line size limit to make output more readable, affects logs

global rootdir D:/partisan-gaps // for my convenience to set project root dir, comment out to avoid conflict
cd $rootdir

cd scripts/Stata

cap log close
log using partisan-gaps-log.txt, replace text

version 13              // Still on version 13 :(

global figsavedir $rootdir/figs
global tabsavedir $rootdir/tabs
adopath ++ ./ado 		// Add path to ados

*** Setup dependencies
txt2macro stata-requirements.txt
setup "`r(mymacro)'"
* -----------------------------------------------------------------------------

// ***************************************************
* Study 1: The Effect of Guessing-Encouraging Features
// ***************************************************
* Figure 1
* Partisan Gap by Treatment Arm (MTurk 1)
do ./mturk/fig-partisan-gap.do

* Table 2
* The Effect of Various Treatments on the Partisan Gap (MTurk 1)
do ./mturk/reg-table.do

// ****************************************************
* Study 2: The Effect of Partisan Cues on Partisan Gaps
// ****************************************************
* Table 3
* The Impact of Partisan Cues on Partisan Gaps (YouGov)
do ./survey-exp/reg-table.do

* Table 4
* Impact of Partisan Cues on Proportion Correct on Unemployment (Texas Lyceum)
* Table 5
* Impact of Partisan Cues and Guessing-Encouraging Wording on Proportion Correct on
do ./tx-lyceum/reg-table.do

// **********************************************************
* Study 3:  The Effect of the Scoring Method on Partisan Gaps
// **********************************************************
* Figure 2
* Partisan Gaps in Knowledge in Different Question Designs
do ./mturk/fig-partisan-gap-imc-24k.do

* Table 6
* Confidence Scoring and Knowledge Gaps: MTurk 2
do ./mturk_hk/reg_table.do

* Figure 3
* Partisan Gaps by Coding (MTurk 2)
do ./mturk_hk/barplots.do

// *********************
* Validty (from MTurk 1)
// *********************
* Table 7
* Validity and Reliability
do ./mturk/corr-validity.do

// *************************************************************
// Supplementary Material
// *************************************************************
* SI 1: Balance Tests
* Figures SI 1.1 to 1.4
* Estimates for Balance of conditions in MTurk 1
do ./mturk/balance-tests.do

* SI 2: Additional Results for Confidence Coding (Mturk 1)
* CCD vs. other conditions
* Tables SI 2.1 to 2.5
do ./mturk/confidence-scoring-reg-tables.do
* Figures in SI 1.1
do ./mturk/confidence-scoring-barplots.do

* Figure SI 2.6
* Partisan Gaps in Knowledge Across Question Designs (Pooled multiple choices)
do ./mturk/fig-partisan-gap-mc-24k.do

* SI 6: Alternate Scoring Criteria for CCD
* Figure SI 6.1
* Robustness Check for Confidence Coding and Knowledge Gaps: MTurk 1
do ./mturk/fig-partisan-gap-imc-24k-greaterthan7.do

* SI 7: Alternative visualizations of results
* Figure SI 7.1: The Effect of Various Treatments on the Partisan Gap (MTurk 1)
do ./mturk/coefplot.do

* Figure SI 7.2
* Partisan Gap by Treatment Arm (MTurk 1)
* do ./mturk/reg-table.do

* Figure SI 7.3
* Weighted Estimate of Inflation of Partisan Gap (Study 2)
* do ./meta/meta.do

* SI 8: Differences by Subgroups (Gender/Race)
* Table SI 8.1
* The Effect of Various Treatments on the Partisan Gap (MTurk 1), by Gender
do ./mturk/reg-table-bygender.do

* Table SI 8.2
* The Effect of Various Treatments on the Partisan Gap (MTurk 1), by White vs Non-White
do ./mturk/reg-table-byrace-white-nonwhite.do

* SI 9: Hierarchical MOdels
* Table SI 9.1
* Comparison of Linear Mixed-Effects Models
* see scripts/07_turk_hlm.R


log close
