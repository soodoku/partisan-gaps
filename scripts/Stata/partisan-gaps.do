
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
log using logs/partisan-gaps.txt, replace text

version 13              // Still on version 13 :(

global figsavedir `rootdir'/figs
global tabsavedir `rootdir'/tabs
adopath ++ ./ado 		// Add path to ados

*** Setup dependencies
txt2macro stata-requirements.txt
setup "`r(mymacro)'"
* -----------------------------------------------------------------------------
tictoc tic

**** Basic prep of data
import delimited `rootdir'/data/turk/mturk-recoded.csv
do ./mturk/preamble.do

// **** Figure for raw partisan gaps by items, by survey type
do ./mturk/fig-partisan-gap.do

// *** Balance tests (24k vs RW), takes a while
do ./mturk/baltest-24k-rw.do

**** Reg table for effect of party & survey type on response
do ./mturk/reg-table.do



tictoc toc

log close
