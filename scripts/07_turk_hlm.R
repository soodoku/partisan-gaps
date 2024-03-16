#
# MTurk Hierarchical Models (Reviewer Demand)
# 

# Loading libraries
library(dplyr)
library(reshape2)
library(broom)
library(lme4)
library(readr)
library(stargazer)

## Data
mt = read_csv("../data/mturk1.csv")

# Recode
mt$survey1 <- relevel(factor(mt$survey), ref = "RW")
levels(mt$survey1) <- c("RW", "IMC", "CUD", "FSR")

mt$item1 <- relevel(factor(mt$item), ref = "Incorrect")

# Model
m1 <- lmer(I(item1) ~ rep*survey1 + (rep*survey1 | id) + (rep*survey| item_type), data = mt)

stargazer(m1, type = "latex", title = "Linear Mixed-Effects Model", align = TRUE)

# but likely more useful: to adopt a multilevel modelling framework where 
# you include varying intercepts over conditions and varying slopes over your 
# congenial variable. 

m2 <- lmer(I(item1) ~ rep*survey1 + (1 | survey1) + (1 | id) + (rep*survey1| rep), data = mt)




#  