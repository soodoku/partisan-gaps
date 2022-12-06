# Set Working dir 

## Gaurav's path
#setwd(basedir) 
#setwd("partisan-gaps")  # folder

## Daniel's path
setwd(githubdir)
setwd("partisan-gaps")  # folder

# Load the packages
library("tidyverse")
library("texreg")
library("DeclareDesign")

## Sourcing the data cleaning file 
source("scripts/10_mturk_hk_kcgie.R")

## Generate a combined data set with closed ended responses and likert scale for Scoring analysis 
df_analysis <-
  bind_rows(
  mturk_hk_closed_correct |> 
    dplyr::select(respondent, questions, congenial, responses) |> 
    mutate(survey = "Closed",
           response_type = "closed",
           questions = str_remove(questions, "_correct")) |> 
    rename(q_item = questions),
  mturk_hk_relscore |> 
    ungroup() |> 
    filter(correct == "correct") |> 
    dplyr::select(respondent, congenial, q_item,starts_with("relscore")) |> 
    pivot_longer(cols = starts_with("relscore"),
                 names_to = "response_type",
                 values_to = "responses") |> 
  mutate(survey = "RL")) |> 
  mutate(congenial = as.factor(congenial))



##########
## Models for the document:


lm_mc10rel_c_aca  <- lm_robust(responses ~ congenial*survey, 
                           data = subset(df_analysis, response_type %in% c("closed", "relscore_c_10") & q_item == "aca"), 
                           clusters = respondent, 
                           se_type = "stata")

lm_mc10rel_c_aca2  <- lm_robust(responses ~ congenial*survey, 
                               data = subset(df_analysis, response_type %in% c("closed", "relscore_c_10") & q_item == "aca2"), 
                               clusters = respondent, 
                               se_type = "stata")

lm_mc10rel_c_gg  <- lm_robust(responses ~ congenial*survey, 
                               data = subset(df_analysis, response_type %in% c("closed", "relscore_c_10") & q_item == "gg"), 
                               clusters = respondent, 
                               se_type = "stata")

lm_mc10rel_c_dt  <- lm_robust(responses ~ congenial*survey, 
                               data = subset(df_analysis, response_type %in% c("closed", "relscore_c_10") & q_item == "dt"), 
                               clusters = respondent, 
                               se_type = "stata")

lm_mc10rel_c  <- lm_robust(responses ~ congenial*survey + q_item, 
                           data = subset(df_analysis, response_type %in% c("closed", "relscore_c_10")), 
                           clusters = respondent, 
                           se_type = "stata")

lm_mc7rel_c  <- lm_robust(responses ~ congenial*survey + q_item, 
                           data = subset(df_analysis, response_type %in% c("closed", "relscore_c_8")), 
                           clusters = respondent, 
                           se_type = "stata")



lm_mc10relnu_c  <- lm_robust(responses ~ congenial*survey + q_item, 
                           data = subset(df_analysis, response_type %in% c("closed", "relscore_c_10_nounique")), 
                           clusters = respondent, 
                           se_type = "stata")


lm_mc10relnm_c  <- lm_robust(responses ~ congenial*survey + q_item, 
                           data = subset(df_analysis, response_type %in% c("closed", "relscore_c_10_nomin")), 
                           clusters = respondent, 
                           se_type = "stata")


screenreg(list(lm_mc10rel_c, lm_mc7rel_c,lm_mc10relnu_c,lm_mc10relnm_c),
          omit.coef = "q_item",
          custom.coef.names = c("Intercept", "Congenial", "Relative Scoring (RL)",  "Congenial*RL" ),
          custom.model.names =  c("Relative Scoring 10",  "RS >6","RS not unique", "RS no min" ))

screenreg(list(lm_mc10rel_c_aca,lm_mc10rel_c_aca2,lm_mc10rel_c_gg,lm_mc10rel_c_dt,lm_mc10rel_c),
          omit.coef = "q_item",
          custom.gof.rows = list("Survey item FE" = c("No", "No", "No", "No", "Yes")),
          custom.coef.names = c("Intercept", "Congenial", "Relative Scoring (RL)",  "Congenial*RL" ),
          custom.model.names =  c("Affordable Care Act", "Affordable Care Act 2", "Greenhouse Gases", "Donald Trump","All"))

texreg(list(lm_mc10rel_c_aca,lm_mc10rel_c_aca2,lm_mc10rel_c_gg,lm_mc10rel_c_dt,lm_mc10rel_c),
       omit.coef = "q_item",
       custom.gof.rows = list("Survey item FE" = c("No", "No", "No", "No", "Yes")),
       custom.coef.names = c("Intercept", "Congenial", "Relative Scoring (RL)",  "Congenial*RL" ),
       custom.model.names =  c("Affordable Care Act", "Affordable Care Act 2", "Greenhouse Gases", "Donald Trump","All"))


library(sjPlot)

plot_model(lm_mc10rel_c, type = "int") + theme_minimal()

## First table in the document
## TODO: this either needs to be added to Figure 1 or made its own version of the figure
## Multiple choice model:
lm_closed_c <- lm_robust(responses ~ congenial + questions, 
                         data = mturk_hk_closed_correct, 
                         clusters = respondent, 
                         se_type = "stata")
## Confidence coding model
lm_mc10_c  <- lm_robust(scale_mc_c_10 ~ congenial + questions, 
                        data = mturk_hk_scale, 
                        clusters = respondent, 
                        se_type = "stata")

lm_mc10rel_c  <- lm_robust(relscore_c_10 ~ congenial + questions, 
                        data = subset(mturk_hk_relscore, correct == "correct" ), 
                        clusters = respondent, 
                        se_type = "stata")


lm_mc7rel_c  <- lm_robust(relscore_c_7 ~ congenial + questions, 
                           data = subset(mturk_hk_relscore, correct == "correct" ), 
                           clusters = respondent, 
                           se_type = "stata")

lm_mc10relnu_c  <- lm_robust(relscore_c_10_nounique ~ congenial + questions, 
                           data = subset(mturk_hk_relscore, correct == "correct" ), 
                           clusters = respondent, 
                           se_type = "stata")

lm_mc10relnm_c  <- lm_robust(relscore_c_10_nomin ~ congenial + questions, 
                           data = subset(mturk_hk_relscore, correct == "correct" ), 
                           clusters = respondent, 
                           se_type = "stata")

# Presenting the difference between multiple choice and likert scale:
screenreg(list(lm_closed_c, lm_mc10_c, lm_mc10rel_c, lm_mc7rel_c,lm_mc10relnu_c,lm_mc10relnm_c),
          omit.coef = "questions",
          custom.model.names =  c("Multiple Choice", "Confidence Coding", "Relative Scoring 10",  "RS >6","RS not unique", "RS no min" ))

# Exporting the difference between multiple choice and likert scale:
texreg(list(lm_closed_c, lm_mc10_c),
       omit.coef = "questions",
       custom.coef.names = c("(Intercept)", "Congenial"),
       custom.gof.rows = list("Survey item FE" = c("Yes", "Yes")),
       reorder.gof = c(2,1,6,4,3,5),
       reorder.coef = c(2,1),
       custom.model.names = c("Multiple Choice", "Confidence Coding"))


####################################################
## Robustness models
## Analysis of multiple choice questions 
## Here we run two models
## First model is all the multiple choice questions that we can use 
## Second model is only the multiple choice questions that are followed up by a probe
lm_closed_c       <- lm_robust(responses      ~ congenial + questions, data = mturk_hk_closed_correct, clusters = respondent, se_type = "stata")
lm_closed_c_probe <- lm_robust(response_probe ~ congenial + questions, data = mturk_hk_closed_correct, clusters = respondent, se_type = "stata")

screenreg(list(lm_closed_c, lm_closed_c_probe),
          omit.coef = "questions",
          custom.model.names = c("MC Correct", "Probe Questions Correct"))

## Analysis of the scale questions
## Here we are running two models 
## First model is coding Likert scale at 10 as correct
## Second model is coding Likert scale at 7 as correct
lm_c10  <- lm_robust(scale_correct_10 ~ congenial + questions, data = mturk_hk_scale, clusters = respondent, se_type = "stata")
lm_c7   <- lm_robust(scale_correct_7  ~ congenial + questions, data = mturk_hk_scale, clusters = respondent, se_type = "stata")

screenreg(list(lm_c10, lm_c7),
          omit.coef = "questions",
          custom.model.names =  c("C10", "C7"))

lm_mc10_c  <- lm_robust(scale_mc_c_10 ~ congenial + questions, data = mturk_hk_scale, clusters = respondent, se_type = "stata")
lm_mc7_c   <- lm_robust(scale_mc_c_7  ~ congenial + questions, data = mturk_hk_scale, clusters = respondent, se_type = "stata")

screenreg(list(lm_mc10_c, lm_mc7_c),
          omit.coef = "questions",
          custom.model.names =  c("MC10", "MC7"))


## Analysis for the probes
lm_mcprobe   <- lm_robust(response_probe ~ congenial + questions, 
                          data = subset(mturk_hk_closed_correct, probe == "closed"), 
                          clusters = respondent, 
                          se_type = "stata")

lm_knowledge <- lm_robust(knowledge ~ congenial + questions, 
                          data = mturk_hk_probes, 
                          clusters = respondent, 
                          se_type = "stata")

# Presenting proportion correct for probe items and proportion of knowledge of those correct items
screenreg(list(lm_mcprobe, lm_knowledge),
          omit.coef = "questions",
          custom.coef.names = c("(Intercept)", "Congenial"),
          custom.model.names = c("Correct", "Knowledge"))

# Exporting the difference between multiple choice and likert scale:
texreg(list(lm_mcprobe, lm_knowledge),
       omit.coef = "questions",
       custom.coef.names = c("(Intercept)", "Congenial"),
       custom.gof.rows = list("Survey item FE" = c("Yes", "Yes")),
       reorder.gof = c(2,1,6,4,3,5),
       reorder.coef = c(2,1),
       custom.model.names = c("Correct", "Knowledge"))

# fin