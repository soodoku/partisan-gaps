cap program drop rho_report
program define rho_report, rclass
	version 13
	syntax varlist(min=2 max=2 numeric), [seed(string) nboot(string) NUMformat(string)]

	if "`seed'"=="" local seed 42
	if "`nboot'"=="" local nboot 100
	if "`numformat'"=="" local numformat %5.2f

	qui bootstrap rho = r(rho), ///
		nodots seed(`seed') reps(`nboot'): ///
		corr `varlist'

	tempname ci_mat rho

	mat `ci_mat' = e(ci_normal)
	local ll = `ci_mat'[1,1]
	local ul = `ci_mat'[2,1]

	mat `rho' = e(b)
	local r = `rho'[1,1]

	local rreport = string(`r',"`numformat'") ///
					+ " [" ///
					+ string(`ll',"`numformat'") ///
					+ " to " + string(`ul',"`numformat'") ///
					+ "]"

	return local rreport `rreport'
end 

// sysuse auto, clear
// rho_report price weight
// return list
