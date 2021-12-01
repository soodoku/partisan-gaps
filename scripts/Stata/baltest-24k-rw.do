
drop if (question_type!="24k") & (question_type!="RW")
gen tarm = (question_type=="24k") 


global bs_seed 0
global nboot 10000

cap program drop run_reg_corr
program define run_reg_corr
	args xvar

	qui eststo: reg tarm `xvar', vce(hc3) 
	global `xvar'_N = "(N=`e(N)')"
	
	rho_report tarm `xvar', seed($bs_seed) nboot($nboot)
	global `xvar'_rreport = "`r(rreport)'"
end

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** Run regressions and correlation

center age interest_1 vote_1 pid_strength_1, standardize inplace
qui tabulate educ, gen(d_educ)
local listofxvar female age hisla d_educ2 d_educ5 d_educ1 d_educ4 asian black white interest_1 vote_1 pid_strength_1

eststo clear 
local i = 1
foreach xvar of varlist `listofxvar' {
	_dots `i++' 0
	run_reg_corr `xvar'
}

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** Plot
grstyle init
grstyle set plain, noextend

#delimit; 
coefplot est*,
	mcolor(navy) msize(small) 
	ciopts(lcolor(gs7))
	keep(`listofxvar')		 
	eqrename(est1="Female $female_N $female_rreport"
			 est2="Age cohort $age_N $age_rreport"
			 est3="Hispanic/Latinx $hisla_N   $hisla_rreport"
			 // est4="No HS diploma `d_educ3_N' `d_educ3_rreport'"
			 est4="HS diploma $d_educ2_N $d_educ2_rreport"
			 est5="Some college $d_educ5_N $d_educ5_rreport"
			 est6="Four-year college $d_educ1_N $d_educ1_rreport"
			 est7="Post-graduate $d_educ4_N $d_educ4_rreport"
			 est8="Asian $asian_N $asian_rreport"
			 est9="Black $black_N $black_rreport"
			 est10="White $white_N $white_rreport"
			 // est11="Others `others_N' `others_rreport'"
			 est11="Political interest $interest_1_N $interest_1_rreport"
			 est12="Intention to vote $vote_1_N $vote_1_rreport"
			 est13="Political leaning $pid_strength_1_N $pid_strength_1_rreport"
			 )
	headings(
		"HS diploma $d_educ2_N $d_educ2_rreport"="{bf:Education}"
		"Asian $asian_N $asian_rreport"="{bf:Race}"
		"Political interest $interest_1_N $interest_1_rreport"="{bf:Politics}", 
		labsize(vsmall) labgap(-3.5)
		)
	asequation /// "set equation to model name or string" make the rows the models
	swapnames /// "swap coefficient names and equation names"
	xline(0, lcolor(gs10) lpattern(dash) lwidth(medium)) ///
	ytick(none) ///	remove horizontal grids	
	ylabel(, labsize(vsmall))
	xlabel(-.3(.1).3, labsize(vsmall))
 	// transform(* = min(max(@,-.24),.24)) /// truncate CI, 1st num is lower bound, 2nd num is upper bound	
	yscale(noline alt)
	plotregion(margin(0 1 0 0) ) ///	
	graphregion(margin(3 0 0 0)) ///	
	title("{bf:Pearson Correlation}" "{bf:Coefficient [95% CI]}", 
			position(11) justification(center) size(small)
		)
	legend(off)
;
#delimit cr

gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(show_ticks(no))) editcopy // yaxis1 edits

gr_edit .move yaxis1 leftof 8 5 // yaxis1 grid reposition

gr_edit .yaxis1.edit_tick 1 1   `"{bf:{fontface Consolas:Female $female_N              $female_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 2 2   `"{bf:{fontface Consolas:Age cohort $age_N           $age_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 3 3   `"{bf:{fontface Consolas:Hispanic/Latinx $hisla_N      $hisla_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 4 6   `"{bf:{fontface Consolas:HS diploma $d_educ2_N           $d_educ2_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 5 7   `"{bf:{fontface Consolas:Some college $d_educ5_N        $d_educ5_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 6 8   `"{bf:{fontface Consolas:Four-year college $d_educ1_N    $d_educ1_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 7 9   `"{bf:{fontface Consolas:Post-graduate $d_educ4_N       $d_educ4_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 8 12  `"{bf:{fontface Consolas:Asian $asian_N                $asian_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 9 13  `"{bf:{fontface Consolas:Black $black_N               $black_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 10 14 `"{bf:{fontface Consolas:White $white_N               $white_rreport}}"', tickset(major)
// gr_edit .yaxis1.edit_tick 11 15 `"Others            	      0.07 (-0.03 to 0.17)"', tickset(major)
gr_edit .yaxis1.edit_tick 11 17 `"{bf:{fontface Consolas:Political interest $interest_1_N  $interest_1_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 12 18 `"{bf:{fontface Consolas:Intention to vote $vote_1_N   $vote_1_rreport}}"', tickset(major)
gr_edit .yaxis1.edit_tick 13 19 `"{bf:{fontface Consolas:Political leaning $pid_strength_1_N   $pid_strength_1_rreport}}"', tickset(major)

gr_edit .title.DragBy 0 -31

graph export ../../ms/figures/baltest-24k-rw.pdf, replace	
