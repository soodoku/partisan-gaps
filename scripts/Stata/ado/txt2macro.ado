capture program drop txt2macro
program define txt2macro, rclass
	* https://stats.idre.ucla.edu/stata/faq/how-do-i-use-file-read-to-read-in-information-in-an-external-text-file/
	version 13
	args filename

	cap file close myfile

	file open myfile using `filename', read
	file read myfile line
	local mymacro `line'

	// dis "`line'"

	while r(eof)==0 { 
		file read myfile line
		// display "`line'"
		local mymacro `mymacro' `line'
	}

	file close myfile

	return local mymacro `mymacro'

end

// txt2macro stata-requirements.txt
// local requirements `r(mymacro)'
// dis "`requirements'"
