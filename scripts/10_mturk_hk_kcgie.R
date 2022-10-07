# Set Working dir 

## Gaurav's path
#setwd(basedir) 
#setwd("partisan-gaps")  # folder

## Daniel's path
#setwd(githubdir)
#setwd("partisan-gaps")  # folder

# Load the packages
library("tidyverse")

# Clean and transform the data
# This script generates three data sets for the analysis:
# - mturk_hk_probes focuses on the questions probing the reasons for a correct answer to multiple choice questions
# - mturk_hk_closed_correct focuses on the correct answers to multiple choice questions 
# - mturk_hk_scale focuses on the correct answers to likert scale questions (integer feeling questions)
# Notes:
# - only rgc_c_aca2_p, rgc_c_dt_p, obama_c_p, bush_c_p have probes about why a correct answer was given 
# - I code three partisanship variables. One drops all independents, one codes weak leaners to their parties (pid strength unequal 5)
#   and one codes strong leaners (pid_strength unequal 4,5,6)
# - knowledge == "I’ve read, seen, or heard that"
# - cheating == "I asked someone I know", "I looked it up"
# - guessing == "I just thought I’d take a shot"
# - inference == "It makes sense, in view of other things I know"
# - expressive == "It makes me feel good to think that"


# Load the data 
# This block drops unnecessary variables and generates the PID leaner variables for the other data sets
mturk_hk <- read_csv("data/mturk_hk/mturk_hk_recoded.csv") |> 
  rename(X = ...1) |> 
  dplyr::select(-c(ends_with("Click"),
                   ends_with("Submit"), 
                   ends_with("Count"), 
                   contains("obama"),
                   contains("bush"),
                   StartDate:meta_info_Resolution)) |> 
  mutate(pid_leaners = ifelse(pid %in% c("Independent", "Something else") & pid_strength_1 < 5, "Democrat",
                                  ifelse(pid  %in% c("Independent", "Something else") & pid_strength_1 > 5, "Republican", pid)),
         pid = ifelse(pid == "Independent", NA_character_, pid),
         pid_leaners = ifelse(pid_leaners == "Independent", NA_character_, pid_leaners),
         democrat_noleaners = ifelse(pid == "Democrat", 1, 
                                     ifelse(pid == "Republican", 0, NA)),
         democrat_leaners = ifelse(pid_leaners == "Democrat", 1, 0)) |> 
  rename(respondent = X)
  
## MTurk closed responses correct
mturk_hk_closed_correct <-
  mturk_hk |> 
  dplyr::select(respondent, democrat, republican, independent,
                democrat_noleaners, democrat_leaners, probe, 
                rgc_o_aca, rgc_c_aca,
                rgc_o_aca2, rgc_o_aca2_p, rgc_c_aca2, rgc_c_aca2_p,
                rgc_o_gg, rgc_c_gg,
                rgc_o_dt, rgc_o_dt_p, rgc_c_dt, rgc_c_dt_p) |> 
  mutate(gg    = coalesce(rgc_o_gg, rgc_c_gg),
         aca   = coalesce(rgc_o_aca, rgc_c_aca),
         aca2  = coalesce(rgc_o_aca2, rgc_c_aca2),
         dt    = coalesce(rgc_o_dt, rgc_c_dt),
         #aca2  = coalesce(rgc_c_aca2),
         #dt    = coalesce(rgc_c_dt),
         aca_correct = if_else(aca == "Increase the Medicare payroll tax for upper-income Americans", 1, 
                                ifelse(aca == "", NA, 0)),
         aca2_correct = if_else(aca2 == "Limit future increases in payments to Medicare providers", 1, 
                                     ifelse(aca2 == "", NA, 0)),
         gg_correct = if_else(gg == "A cause of rising sea levels", 1,
                              ifelse(gg == "", NA, 0)),
         dt_correct = if_else(dt == "Temporarily ban immigrants from several majority-Muslim countries", 1,
                             ifelse(dt == "", NA, 0))) |> 
  pivot_longer(cols = c(aca_correct, aca2_correct, gg_correct, dt_correct),
               names_to = "questions",
               values_to = "responses") |> 
  mutate(congenial = ifelse(questions %in% c("aca_correct", "aca2_correct", "gg_correct") & democrat_leaners == 1, 1,
                            ifelse(questions %in% c("dt_correct") & democrat_leaners == 0, 1, 0)),
         response_probe = ifelse(questions %in% c("aca2_correct", "dt_correct"), responses, NA)) |> 
  dplyr::select(-c(rgc_o_aca:dt)) |> 
  drop_na(responses)

## Generating a data set with the probes 
mturk_hk_probes <-
  mturk_hk |> 
  dplyr::select(respondent, democrat, republican, independent, 
                democrat_noleaners, democrat_leaners,
                rgc_c_aca2_p, rgc_c_dt_p,rgc_c_aca2,rgc_c_dt,
                pid, pid_strength_1) |> 
  mutate(aca2_correct = if_else(rgc_c_aca2 == "Limit future increases in payments to Medicare providers", 1, 
                                ifelse(rgc_c_aca2 == "", NA, 0)),
         dt_correct = if_else(rgc_c_dt == "Temporarily ban immigrants from several majority-Muslim countries", 1,
                              ifelse(rgc_c_dt == "", NA, 0))) |> 
  #dplyr::select(-c(rgc_c_aca2,rgc_c_dt)) |> 
  pivot_longer(cols = c(rgc_c_aca2_p, rgc_c_dt_p),
               names_to = "questions",
               values_to = "responses") |> 
  mutate(responses    = ifelse(responses == "", NA_character_, responses),
         aca2_correct = ifelse(questions == "rgc_c_aca2_p", aca2_correct, NA),
         dt_correct   = ifelse(questions == "rgc_c_dt_p", dt_correct, NA),
         correct    = coalesce(aca2_correct, dt_correct),
         knowledge    = ifelse(correct == 1 & responses %in% c("I’ve read, seen, or heard that"), 1,
                               ifelse(is.na(correct), NA, 0)),
         cheating   = ifelse(correct == 1 & responses %in% c("I asked someone I know", "I looked it up"), 1, 
                            ifelse(is.na(correct), NA, 0)),
         guessing   = ifelse(correct == 1 & responses %in% c("I just thought I’d take a shot"), 1, 
                            ifelse(is.na(correct), NA, 0)),
         inference  = ifelse(correct == 1 & responses %in% c("It makes sense, in view of other things I know"), 1, 
                            ifelse(is.na(correct), NA, 0)),
         expressive = ifelse(correct == 1 & responses %in% c("It makes me feel good to think that"), 1, 
                            ifelse(is.na(correct), NA, 0)),
         congenial = ifelse(questions %in% c("rgc_c_aca2_p") & democrat_leaners == 1, 1,
                            ifelse(questions %in% c("rgc_c_dt_p") & democrat_leaners == 0, 1, 0))) |> 
  drop_na(correct) |> 
  dplyr::select(respondent, pid, pid_strength_1, democrat:democrat_leaners, questions, rgc_c_aca2, rgc_c_dt, 
                responses, aca2_correct, dt_correct, everything())

## MTurk scale correct
mturk_hk_scale <-
  mturk_hk |> 
  dplyr::select(respondent, democrat, republican, independent, 
                democrat_noleaners, democrat_leaners,
                contains("_s_")) |> 
  pivot_longer(cols = contains("_s_"),
               names_to = "questions",
               values_to = "responses") |> 
  mutate(scale_correct_10 = ifelse(responses > 0 | responses < 10, 0, NA),
         scale_correct_10 = ifelse(questions == "rg_s_aca_3"  & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_aca2_3" & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_gg_4"   & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_gg2_2"  & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_gg2_4"  & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_dt_4"   & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(!questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", 
                                                     "rg_s_gg2_2", "rg_s_gg2_4", "rg_s_dt_4") & responses == 0,1, scale_correct_10),
         scale_correct_7 = ifelse(responses > 0 | responses <= 7, 0, NA),
         scale_correct_7 = ifelse(questions == "rg_s_aca_3"  & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_aca2_3" & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_gg_4"   & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_gg2_2"  & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_gg2_4"  & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_dt_4"   & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(!questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", 
                                                    "rg_s_gg2_2", "rg_s_gg2_4", "rg_s_dt_4") & responses < 3,1, scale_correct_7),
         scale_mc_c_10 = ifelse(responses < 10, 0, NA),
         scale_mc_c_10 = ifelse(questions == "rg_s_aca_3"  & responses == 10, 1, scale_mc_c_10),
         scale_mc_c_10 = ifelse(questions == "rg_s_aca2_3" & responses == 10, 1, scale_mc_c_10),
         scale_mc_c_10 = ifelse(questions == "rg_s_gg_4"   & responses == 10, 1, scale_mc_c_10),
         scale_mc_c_10 = ifelse(questions == "rg_s_dt_4"   & responses == 10, 1, scale_mc_c_10),
         scale_mc_c_10 = ifelse(!questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", 
                                                  "rg_s_dt_4"), NA, scale_mc_c_10),
         scale_mc_c_7 = ifelse(responses <= 7, 0, NA),
         scale_mc_c_7 = ifelse(questions == "rg_s_aca_3"  & responses > 7, 1, scale_mc_c_7),
         scale_mc_c_7 = ifelse(questions == "rg_s_aca2_3" & responses > 7, 1, scale_mc_c_7),
         scale_mc_c_7 = ifelse(questions == "rg_s_gg_4"   & responses > 7, 1, scale_mc_c_7),
         scale_mc_c_7 = ifelse(questions == "rg_s_dt_4"   & responses > 7, 1, scale_mc_c_7),
         scale_mc_c_7 = ifelse(!questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", 
                                                 "rg_s_dt_4"), NA, scale_mc_c_7)) |> 
  mutate(congenial = ifelse(questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", "rg_s_gg2_2", "rg_s_gg2_4") & democrat_leaners == 1, 1,
                            ifelse(questions %in% c("rg_s_dt_4") & democrat_leaners == 0, 1, 0))) |> 
  drop_na(scale_correct_10)

## Remove original file which is not required anymore
rm(mturk_hk)

## Export files for Stata analysis
write_csv(mturk_hk_closed_correct, "data/mturk_hk/mturk_hk_MC.csv")
write_csv(mturk_hk_probes, "data/mturk_hk/mturk_hk_PROBES.csv")
write_csv(mturk_hk_scale, "data/mturk_hk/mturk_hk_LIKERT.csv")

# fin