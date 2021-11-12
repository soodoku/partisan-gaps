cd D:/partisan-gaps // for my convenience to set project root dir, comment out to avoid conflict


* -----------------------------------------------------------------------------
* Program Setup
* -----------------------------------------------------------------------------
cd scripts/Stata

cap log close
log using logs/partisan-gaps.txt, replace text

cls 					// Clear results window
version 13              // Still on version 13 :(
clear all               // Start with a clean slate
set more off            // Disable partitioned output
macro drop _all         // Clear all macros to avoid namespace conflicts
set linesize 120        // Line size limit to make output more readable, affects logs
// local figsavedir ./out/figures	// Savepath for figures
// local tabsavedir ./out/tables 	// Savepath for tables
// sysdir set PERSONAL analysis/utilities // Add path to my ados
* -----------------------------------------------------------------------------

import delimited D:/partisan_gaps/data/mturk-recoded.csv

**** Basic prep of data
do preamble.do

**** Figure for raw partisan gaps by items, by survey type
do fig-partisan-gap.do

**** Reg table for effect of party & survey type on response
do reg-table.do

log close
