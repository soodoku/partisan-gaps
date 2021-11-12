grstyle init
grstyle set plain, 


eststo clear
foreach arm in $arms {
	reg avg i.rep if (pid_str!="Independent") & (question_type=="`arm'"), vce(hc3)
	est store e_`arm'
}


#delimit;
coefplot (e_RW) || (e_IPS) || (e_FSR) || (e_14k) || (e_24k),
	msymbol(s) msize(large)
	lwidth(medthick)
	ciopts(recast(rcap) lwidth(medthick))
	recast(connected)
	vertical
	asequation
	byopts(row(1))
	subtitle("") /// Remove subtitles for now	
	ylabel(, angle(horizontal))
	order("{bf:Dem}")
	rename(
		_cons = "{bf:Dem}"
		1.rep = "{bf:Rep}"
		)		
;
#delimit cr

* Add column titles	
addplot 1: , title("{bf:RW}", size(med)) norescaling
addplot 2: , title("{bf:IPS}") norescaling
addplot 3: , title("{bf:FSR}") norescaling
addplot 4: , title("{bf:14k}") norescaling
addplot 5: , title("{bf:24k}") norescaling
