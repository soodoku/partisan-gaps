capture program drop savefig
program define savefig
   // ====================================================================================
   /* This program saves Stata graph using graph export into multiple file formats.

      Example usage:
      savefig, path(savepath) format(png pdf) override(width(1000))

      MWE:
      sysuse auto, clear
      hist price
      savefig, path(myfig)

   */
   // ====================================================================================
   syntax, PATH_filestem(string) [FORMATs(string) OVERRIDE_args(string)]

    if "`formats'" == "" {
      local formats "pdf png"
    }

    foreach fsuffix in `formats' {
      local filename "`path_filestem'.`fsuffix'"

      if "`fsuffix'"=="pdf" {
         graph export "`filename'", as(`fsuffix') replace
      }
      else {
         cap graph export "`filename'", as(`fsuffix') replace `override_args'
         if _rc==198 {
            dis "Override ption not allowed - ignoring override option"
            graph export "`filename'", as(`fsuffix') replace
         }         
      }
      dis as result "Graph saved as `filename'"
    }
end

// sysuse auto, clear
// hist price
// savefig, path(test)
