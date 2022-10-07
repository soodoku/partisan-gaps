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

## Sourcing the data cleaning file 
source("scripts/10_mturk_hk_kcgie.R")


##########
## Models for the document:

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

# Presenting the difference between multiple choice and likert scale:
screenreg(list(lm_closed_c, lm_mc10_c),
          omit.coef = "questions",
          custom.model.names =  c("Multiple Choice", "Confidence Coding"))

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