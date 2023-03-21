
* -----------------------------------------------------------------------------
* Program Setup
* -----------------------------------------------------------------------------
cls 					// Clear results window
clear all               // Start with a clean slate
set more off            // Disable partitioned output
macro drop _all         // Clear all macros to avoid namespace conflicts
set linesize 120        // Line size limit to make output more readable, affects logs

local rootdir D:/partisan-gaps // for my convenience to set project root dir, comment out to avoid conflict
cd `rootdir'

cd scripts/Stata

cap log close
log using partisan-gaps-log.txt, replace text

version 13              // Still on version 13 :(

global figsavedir `rootdir'/figs
global tabsavedir `rootdir'/tabs
adopath ++ ./ado 		// Add path to ados

*** Setup dependencies
txt2macro stata-requirements.txt
setup "`r(mymacro)'"
* -----------------------------------------------------------------------------
tictoc tic

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* MTurk results (Study 1)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**** Basic prep of data
import delimited `rootdir'/data/turk/mturk-recoded.csv
do ./mturk/preamble.do

**** Figure for raw partisan gaps by items, by survey type
* Figure 1
do ./mturk/fig-partisan-gap.do
do ./mturk/fig-partisan-gap-ips-24k.do

*** Balance tests (IPS/IDA as base) 
do ./mturk/balance-tests.do // store estimates only

**** Reg results for effect of party & survey type on response (Tab 2 + Fig 2)
* Table 2
do ./mturk/reg-table.do
* Figure 2
do ./mturk/barplot.do

**** Figure 5: IMC/14k vs CCD/24k
do ./mturk/fig-partisan-gap-imc-24k.do

**** Reg results for comparing 24k/CCD (Confidence scoring) with the four other 
****  multiple choice conditions (IPS/IDA, RW/CUD, FSR/FSR, 14K/IMC)
* (In appendix)
* Tables in SI 1.1
do ./mturk/confidence-scoring-reg-tables.do
* Figures in SI 1.1
do ./mturk/confidence-scoring-barplots.do

**** Figure: All multiple choice vs CCD/24k
import delimited `rootdir'/data/turk/mturk-recoded.csv, clear
do ./mturk/preamble.do

do ./mturk/fig-partisan-gap-mc-24k.do

* Robustness test with CCD threshold = 8 (instead of 10)
import delimited `rootdir'/data/turk/mturk-recoded-greaterthan7.csv, clear
do ./mturk/preamble.do
do ./mturk/fig-partisan-gap-imc-24k-greaterthan7.do


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* YouGov results (Study 2)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**** Basic prep of data
import delimited D:/partisan-gaps/data/survey_exp/selex.csv, clear
do ./survey-exp/preamble.do
drop if ind==1

**** Reg table for effect of party & survey type on response
* Table 3
do ./survey-exp/reg-table.do

**** Barplots for effect of party & survey type on response
* Figure 3a
do ./survey-exp/unemp-barplots.do
* Figure 3b
do ./survey-exp/deficit-barplots.do


// *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Texas Lyceum results (Study 3)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**** Basic prep of data
use "D:/partisan-gaps/data/tx_lyceum/Texas Lyceum 2012 Data.dta", clear
do ./tx-lyceum/preamble.do

**** Reg table for effect of party & survey type on response
* Table 4 & Table 5
do ./tx-lyceum/reg-table.do

**** Barplots for effect of party & survey type on response
* Figure 4
do ./tx-lyceum/unemp-barplot.do

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// * MTurk results (Study 4)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Table 6
do ./mturk_hk/reg_table.do

* Figure 6
do ./mturk_hk/barplots.do

do ./mturk_hk/fig-partisan-gap.do


tictoc toc

log close
