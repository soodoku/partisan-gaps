set more off
import excel $rootdir/data/yg_tx_unemp.xlsx, firstrow clear

preserve
* No adjustments
drop if demo
#delimit;
meta set es se, 
	studylab(study) 
	studysize(n)
	eslabel(Partisan gap inflation)
;
#delimit cr

meta summarize

#delimit;
meta forestplot,
	nonotes
	markeropts(color(gs5%90) msize(large))
	omarkeropts(mcolor(navy%50))
	ciopts(lcolor(black%60))
	esrefline(lpattern(longdash) lcolor(navy%40))
	nullrefline(lpattern(dash))
	graphregion(color(white) lc(white) lw(medium) margin(0 0 0 0))
	plotregion(margin(0 0  0 0))
;
#delimit cr;
graph export ../../../figs/yg_tx_unemp_meta.pdf, replace	
restore

//
// * With demo baselines
// drop if demo==0
// #delimit;
// meta set es se, 
// 	studylab(study) 
// 	studysize(n)
// 	eslabel(Partisan gap inflation)
//	
// ;
// #delimit cr
//
// meta summarize
//
// #delimit;
// meta forestplot,
// 	nonotes
// 	markeropts(color(gs5%90) msize(large))
// 	omarkeropts(mcolor(navy%50))
// 	ciopts(lcolor(black%90))
// 	name(adjusted)
// ;
// #delimit cr;
// restore
