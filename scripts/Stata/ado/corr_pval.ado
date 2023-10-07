capture program drop corr_pval
program define corr_pval, rclass
	args adj
	///////////////////////////////////////////////////////////////////////////////
	// Description:
	// ------------
	//		Computes the p-value from running corr or pwcorr. Useful for storing
	// 			p-values for macros or tabulation. `adj' is 1 unless you are 
	// 			doing Bonferroni or Sidak corrections. 
	//
	// Syntax: 
	// -------
	// 		corr_pval
	// MWE:
	// ----
	// 		sysuse auto
	//		pwcorr price trunk, sig
	// 		corr_pval
	//		dis `r(corr_pval)'
	// Remarks:
	// --------
	//		. Code taken from underlying correlation command from ssc. 
	// 		. For some reason, the p-value is not available from return list.
	//		. See this: 
	// 			https://www.statalist.org/forums/forum/general-stata-discussion/general/4461-storing-p-value-of-corr-coeff-obtained-by-pwcorr
	//////////////////////////////////////////////////////////////////////////////		
	if "`adj'"=="" local adj = 1


	if (r(rho) != . & r(rho) < 1) {
		local corr_pval=min(2*`adj'*ttail(r(N)-2,abs(r(rho))*sqrt(r(N)-2)/sqrt(1-r(rho)^2)),1)
	}
	else if (r(rho)>=1 & r(rho) != .) {
		local corr_pval=0
	}
	else if r(rho) == . {
		local corr_pval= .
	}
	// dis `corr_pval'
	return local corr_pval `corr_pval'
end
