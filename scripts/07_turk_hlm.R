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
mt$survey1 <- factor(mt$survey, levels = c("14k", "FSR", "IPS", "RW"),
                    labels = c("IMC", "FSR", "IDA", "CUD"))
mt$survey1 <- relevel(mt$survey1, ref = "IDA") 

mt$item1 <- ifelse(mt$item == "Correct", 1, 0)


# Model
m1 <- lmer(item1 ~ rep*survey1 + item_type + (rep*survey1| id), data = mt)
m2 <- lmer(item1 ~ rep*survey1 + (rep*survey1 | id) + (rep*survey1| item_type), data = mt)
m3 <- lmer(item1 ~ rep*survey1 + (survey1| rep) + (1| survey1), data = mt)

stargazer(m1, m2, m3, 
          type = "latex", 
          title = "Comparison of Linear Mixed-Effects Models", 
          align = TRUE,
          dep.var.caption = "Dependent Variable: Correct",
          dep.var.labels = "item1",
          omit = "item",
          covariate.labels = c("Congenial", "CUD", "FSR", "IMC",
                               "Congenial × CUD", "Congenial × FSR", "Congenial × IMC", 
                               "Constant"),
          column.labels = c("Model 1", "Model 2", "Model 3"),
          omit.stat = c("LL", "ser", "f", "AIC", "BIC"),
          omit.table.layout = "n",
          header = FALSE,
          out = "../tabs/si_turk_hlm.tex")
