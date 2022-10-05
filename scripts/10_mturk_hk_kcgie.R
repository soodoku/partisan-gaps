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
                   StartDate:meta_info_Resolution)) |> 
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
  rename(respondent = X)
  

## Generating a data set with the probes 
mturk_hk_probes <-
  mturk_hk |> 
  dplyr::select(respondent, democrat, republican, independent, 
                democrat_noleaners, democrat_leaners_46, democrat_leaners_37,
                rgc_c_aca2_p, rgc_c_dt_p, obama_c_p, bush_c_p,
                pid, pid_strength_1) |> 
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
                             ifelse(is.na(responses), NA, 0)),
         congenial = ifelse(questions %in% c("rgc_c_aca2_p", "obama_c_p") & democrat_leaners_46 == 1, 1,
                            ifelse(questions %in% c("rgc_c_dt_p", "bush_c_p") & democrat_leaners_46 == 0, 1, 0)),
         congenial_noinflation = ifelse(questions %in% c("obama_c_p", "bush_c_p"), NA, congenial))

## MTurk closed responses correct
mturk_hk_closed_correct <-
  mturk_hk |> 
  dplyr::select(respondent, democrat, republican, independent,
                democrat_noleaners, democrat_leaners_46, democrat_leaners_37,
                rgc_o_aca, rgc_c_aca,
                rgc_o_aca2, rgc_o_aca2_p, rgc_c_aca2, rgc_c_aca2_p,
                rgc_o_gg, rgc_c_gg,
                rgc_o_dt, rgc_o_dt_p, rgc_c_dt, rgc_c_dt_p,
                obama_o, obama_o_p, obama_c, obama_c_p, 
                bush_o, bush_o_p, bush_c, bush_c_p) |> 
  mutate(obama = coalesce(obama_o, obama_c),
         bush  = coalesce(bush_o, bush_c),
         gg    = coalesce(rgc_o_gg, rgc_c_gg),
         aca   = coalesce(rgc_o_aca, rgc_c_aca),
         aca2  = coalesce(rgc_o_aca2, rgc_c_aca2),
         dt    = coalesce(rgc_o_dt, rgc_c_dt),
         aca_correct = if_else(aca == "Increase the Medicare payroll tax for upper-income Americans", 1, 
                                ifelse(aca == "", NA, 0)),
         aca2_correct = if_else(aca2 == "Limit future increases in payments to Medicare providers", 1, 
                                     ifelse(aca2 == "", NA, 0)),
         gg_correct = if_else(gg == "A cause of rising sea levels", 1,
                              ifelse(gg == "", NA, 0)),
         dt_correct = if_else(dt == "Temporarily ban immigrants from several majority-Muslim countries", 1,
                             ifelse(dt == "", NA, 0)),
         obama_correct = if_else(obama == "Increased", 1, 
                                      ifelse(obama == "", NA, 0)),
         bush_correct = if_else(bush == "Increased", 1, 
                                      ifelse(bush == "", NA, 0))) |> 
  pivot_longer(cols = c(aca_correct, aca2_correct, gg_correct, dt_correct,
                        obama_correct, bush_correct),
               names_to = "questions",
               values_to = "responses") |> 
  mutate(congenial = ifelse(questions %in% c("aca_correct", "aca2_correct", "gg_correct", "obama_correct") & democrat_leaners_46 == 1, 1,
                            ifelse(questions %in% c("dt_correct", "bush_correct") & democrat_leaners_46 == 0, 1, 0))) |> 
  dplyr::select(-c(rgc_o_aca:dt)) |> 
  mutate(responses_noinflation = ifelse(questions %in% c("obama_correct", "bush_correct"), NA, responses),
         response_onlyinflation = ifelse(questions %in% c("obama_correct", "bush_correct"), responses, NA))

## MTurk scale correct
mturk_hk_scale <-
  mturk_hk |> 
  dplyr::select(respondent, democrat, republican, independent, 
                democrat_noleaners, democrat_leaners_46, democrat_leaners_37,
                contains("_s_")) |> 
  pivot_longer(cols = contains("_s_"),
               names_to = "questions",
               values_to = "responses") |> 
  mutate(scale_correct_10 = ifelse(responses > 0 | responses < 10, 0, NA),
         scale_correct_10 = ifelse(questions == "rg_s_aca_3" & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_aca2_3" & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_gg_4" & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_gg2_2" & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_gg2_4" & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(questions == "rg_s_dt_4" & responses == 10, 1, scale_correct_10),
         scale_correct_10 = ifelse(!questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", 
                                                     "rg_s_gg2_2", "rg_s_gg2_4", "rg_s_dt_4") & responses == 0,1, scale_correct_10),
         scale_correct_7 = ifelse(responses > 0 | responses < 7, 0, NA),
         scale_correct_7 = ifelse(questions == "rg_s_aca_3" & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_aca2_3" & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_gg_4" & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_gg2_2" & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_gg2_4" & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(questions == "rg_s_dt_4" & responses > 7, 1, scale_correct_7),
         scale_correct_7 = ifelse(!questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", 
                                                    "rg_s_gg2_2", "rg_s_gg2_4", "rg_s_dt_4") & responses < 3,1, scale_correct_7),
         scale_mc_c_10 = ifelse(responses < 10, 0, NA),
         scale_mc_c_10 = ifelse(questions == "rg_s_aca_3" & responses == 10, 1, scale_mc_c_10),
         scale_mc_c_10 = ifelse(questions == "rg_s_aca2_3" & responses == 10, 1, scale_mc_c_10),
         scale_mc_c_10 = ifelse(questions == "rg_s_gg_4" & responses == 10, 1, scale_mc_c_10),
         scale_mc_c_10 = ifelse(questions == "rg_s_dt_4" & responses == 10, 1, scale_mc_c_10),
         scale_mc_c_10 = ifelse(!questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", 
                                                  "rg_s_dt_4"), NA, scale_mc_c_10),
         scale_mc_c_7 = ifelse(responses < 7, 0, NA),
         scale_mc_c_7 = ifelse(questions == "rg_s_aca_3" & responses > 7, 1, scale_mc_c_7),
         scale_mc_c_7 = ifelse(questions == "rg_s_aca2_3" & responses > 7, 1, scale_mc_c_7),
         scale_mc_c_7 = ifelse(questions == "rg_s_gg_4" & responses > 7, 1, scale_mc_c_7),
         scale_mc_c_7 = ifelse(questions == "rg_s_dt_4" & responses > 7, 1, scale_mc_c_7),
         scale_mc_c_7 = ifelse(!questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", 
                                                 "rg_s_dt_4"), NA, scale_mc_c_7)) |> 
  mutate(congenial = ifelse(questions %in% c("rg_s_aca_3", "rg_s_aca2_3", "rg_s_gg_4", "rg_s_gg2_2", "rg_s_gg2_4") & democrat_leaners_46 == 1, 1,
                            ifelse(questions %in% c("rg_s_dt_4") & democrat_leaners_46 == 0, 1, 0))) 


## Analysis of the closed ended questions
mturk_hk_closed_correct |> 
  dplyr::select(responses, congenial, democrat_leaners_46) |>
  mutate(democrat_leaners_46 = ifelse(democrat_leaners_46 == 1, "Democrat", "Republican"),
         responses = ifelse(responses == 1, "Correct", "Incorrect"),
         congenial = ifelse(congenial == 1, "Congenial", "Not Congenial")) |> 
  drop_na() |> 
  ggplot(aes(x = responses, fill = congenial)) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom") + facet_grid(~democrat_leaners_46)

mturk_hk_closed_correct |> 
  dplyr::select(responses_noinflation, congenial, democrat_leaners_46) |>
  mutate(democrat_leaners_46 = ifelse(democrat_leaners_46 == 1, "Democrat", "Republican"),
         responses_noinflation = ifelse(responses_noinflation == 1, "Correct", "Incorrect"),
         congenial = ifelse(congenial == 1, "Congenial", "Not Congenial")) |> 
  drop_na() |> 
  ggplot(aes(x = responses_noinflation, fill = congenial)) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom") + facet_grid(~democrat_leaners_46)


## Analysis of multiple choice questions 
lm_closed_correct   <- lm_robust(responses  ~ congenial + questions, data = mturk_hk_closed_correct, clusters = respondent, se_type = "stata")
lm_closed_correct2  <- lm_robust(responses_noinflation  ~ congenial + questions, data = mturk_hk_closed_correct, clusters = respondent, se_type = "stata")
lm_closed_correct3  <- lm_robust(response_onlyinflation  ~ congenial + questions, data = mturk_hk_closed_correct, clusters = respondent, se_type = "stata")

screenreg(list(lm_closed_correct, lm_closed_correct2, lm_closed_correct3),
          omit.coef = "questions",
          custom.model.names = c("W Inflation", "WO Inflation", "Only Inflation"))

## Analysis of the scale questions
## TODO: Check N

mturk_hk_scale |> 
  dplyr::select(scale_mc_c_10, democrat_leaners_46) |> 
  drop_na() |> 
  ggplot(aes(x = as.factor(scale_mc_c_10), fill = as.factor(democrat_leaners_46))) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom")
  
mturk_hk_scale |> 
  dplyr::select(scale_mc_c_10, congenial) |> 
  drop_na() |> 
  ggplot(aes(x = as.factor(scale_mc_c_10), fill = as.factor(congenial))) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom")

mturk_hk_scale |> 
  dplyr::select(scale_mc_c_7, democrat) |> 
  drop_na() |> 
  ggplot(aes(x = scale_mc_c_7, fill = as.factor(democrat))) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom")

lm_correct_mc10  <- lm_robust(scale_mc_c_10  ~ congenial + questions, data = mturk_hk_scale, clusters = respondent, se_type = "stata")
lm_correct_mc7   <- lm_robust(scale_mc_c_7   ~ congenial + questions, data = mturk_hk_scale, clusters = respondent, se_type = "stata")

screenreg(list(lm_correct_mc10,lm_correct_mc7),
          omit.coef = "questions",
          custom.model.names = c("MC_C10", "MC_C7"))

lm_correct_10  <- lm_robust(scale_correct_10  ~ democrat_leaners_46 + questions, data = mturk_hk_scale, clusters = respondent, se_type = "stata")
lm_correct_7   <- lm_robust(scale_correct_7   ~ democrat_leaners_46 + questions, data = mturk_hk_scale, clusters = respondent, se_type = "stata")

screenreg(list(lm_correct_10,lm_correct_7),
          omit.coef = "questions",
          custom.model.names = c("All_C10", "All_C7"))

screenreg(list(lm_correct_mc10, lm_correct_10),
          omit.coef = "questions",
          custom.model.names = c("MC_C10", "All_C10"))


## Analysis for the probes
lm_knowledge   <- lm_robust(knowledge   ~ congenial + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")
lm_cheating    <- lm_robust(cheating    ~ congenial + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")
lm_guessing    <- lm_robust(guessing    ~ congenial + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")
lm_inference   <- lm_robust(inference   ~ congenial + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")
lm_expressive  <- lm_robust(expressive  ~ congenial + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")

screenreg(list(lm_knowledge, lm_cheating, lm_guessing, lm_inference, lm_expressive),
          omit.coef = "questions",
          custom.model.names = c("Knowledge", "Cheating", "Guessing", "Inference", "Expressive"))

lm_knowledge   <- lm_robust(knowledge   ~ congenial_noinflation + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")
lm_cheating    <- lm_robust(cheating    ~ congenial_noinflation + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")
lm_guessing    <- lm_robust(guessing    ~ congenial_noinflation + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")
lm_inference   <- lm_robust(inference   ~ congenial_noinflation + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")
lm_expressive  <- lm_robust(expressive  ~ congenial_noinflation + questions, data = mturk_hk_probes, clusters = respondent, se_type = "stata")

screenreg(list(lm_knowledge, lm_cheating, lm_guessing, lm_inference, lm_expressive),
          omit.coef = "questions",
          custom.model.names = c("Knowledge", "Cheating", "Guessing", "Inference", "Expressive"))


      