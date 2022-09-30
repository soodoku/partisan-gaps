# Set Working dir 

## Gaurav's path
setwd(basedir) 
setwd("partisan-gaps")  # folder

## Daniel's path
setwd(githubdir)
setwd("partisan-gaps")  # folder

# Load the packages
library("tidyverse")
library("texreg")
library("DeclareDesign")

# load the data 
mturk_hk <- read.csv("data/mturk_hk/mturk_hk_recoded.csv") 

mturk_hk_analysis <-
  mturk_hk |> 
  dplyr::select(X, democrat, republican, independent, rgc_c_aca2_p, rgc_c_dt_p, obama_c_p, bush_c_p, pid, pid_strength_1) |> 
  mutate(pid_leaners_4_6 = ifelse(pid %in% c("Independent", "Something else") & pid_strength_1 < 5, "Democrat",
                                  ifelse(pid  %in% c("Independent", "Something else") & pid_strength_1 > 5, "Republican", pid)),
         pid_leaners_3_7 = ifelse(pid %in% c("Independent", "Something else") & pid_strength_1 < 5, "Democrat",
                                  ifelse(pid  %in% c("Independent", "Something else") & pid_strength_1 > 6, "Republican", pid)),
         pid = ifelse(pid == "Independent", NA_character_, pid),
         pid_leaners_4_6 = ifelse(pid_leaners_4_6 == "Independent", NA_character_, pid_leaners_4_6),
         pid_leaners_3_7 = ifelse(pid_leaners_3_7 == "Independent", NA_character_, pid_leaners_3_7),
         democrat_noleaners = ifelse(pid == "Democrat", 1, 
                                     ifelse(pid == "Republican", 0, NA)),
         democrat_leaners_46 = ifelse(pid_leaners_4_6 == "Democrat", 1, 0),
         democrat_leaners_37 = ifelse(pid_leaners_3_7 == "Democrat", 1, 0)) |> 
  pivot_longer(cols = c(rgc_c_aca2_p, rgc_c_dt_p, obama_c_p, bush_c_p),
               names_to = "questions",
               values_to = "responses") |> 
  mutate(responses  = ifelse(responses == "", NA_character_, responses),
         knowledge  = ifelse(responses %in% c("I’ve read, seen, or heard that"), 1, 
                             ifelse(is.na(responses), NA, 0)),
         cheating   = ifelse(responses %in% c("I asked someone I know", "I looked it up"), 1, 
                             ifelse(is.na(responses), NA, 0)),
         guessing   = ifelse(responses %in% c("I just thought I’d take a shot"), 1, 
                             ifelse(is.na(responses), NA, 0)),
         inference  = ifelse(responses %in% c("It makes sense, in view of other things I know"), 1, 
                             ifelse(is.na(responses), NA, 0)),
         expressive = ifelse(responses %in% c("It makes me feel good to think that"), 1, 
                             ifelse(is.na(responses), NA, 0))) |> 
  rename(respondent = X)


## Robust regression model for: NO LEANERS
lm_know_rnl  <- lm_robust(knowledge  ~ democrat_noleaners, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_cheat_rnl <- lm_robust(cheating   ~ democrat_noleaners, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_guess_rnl <- lm_robust(guessing   ~ democrat_noleaners, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_infer_rnl <- lm_robust(inference  ~ democrat_noleaners, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_expr_rnl  <- lm_robust(expressive ~ democrat_noleaners, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")

screenreg(list(lm_know_rnl, lm_cheat_rnl, lm_guess_rnl, lm_infer_rnl, lm_expr_rnl))

## Robust regression model for: LEANERS, Independents or something else that had PID leaning lower or greater than 5
lm_know_r46  <- lm_robust(knowledge  ~ democrat_leaners_46, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_cheat_r46 <- lm_robust(cheating   ~ democrat_leaners_46, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_guess_r46 <- lm_robust(guessing   ~ democrat_leaners_46, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_infer_r46 <- lm_robust(inference  ~ democrat_leaners_46, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_expr_r46  <- lm_robust(expressive ~ democrat_leaners_46, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")

screenreg(list(lm_know_r46, lm_cheat_r46, lm_guess_r46, lm_infer_r46, lm_expr_r46))

## Robust regression model for: LEANERS, Independents or something else that had PID leaning lower or greater than 4 or 6
lm_know_r37  <- lm_robust(knowledge  ~ democrat_leaners_37, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_cheat_r37 <- lm_robust(cheating   ~ democrat_leaners_37, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_guess_r37 <- lm_robust(guessing   ~ democrat_leaners_37, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_infer_r37 <- lm_robust(inference  ~ democrat_leaners_37, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")
lm_expr_r37  <- lm_robust(expressive ~ democrat_leaners_37, data = mturk_hk_analysis, clusters = respondent, se_type = "stata")

screenreg(list(lm_know_r37, lm_cheat_r37, lm_guess_r37, lm_infer_r37, lm_expr_r37))

## Results combined
screenreg(list(lm_know_rnl, lm_cheat_rnl, lm_guess_rnl, lm_infer_rnl, lm_expr_rnl))
screenreg(list(lm_know_r46, lm_cheat_r46, lm_guess_r46, lm_infer_r46, lm_expr_r46))
screenreg(list(lm_know_r37, lm_cheat_r37, lm_guess_r37, lm_infer_r37, lm_expr_r37))

