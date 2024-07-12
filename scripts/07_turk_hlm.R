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
                    labels = c("Cond. 4", "Cond. 3", "Cond. 1", "Cond. 2"))
mt$survey1 <- factor(mt$survey1, levels = c("Cond. 1", "Cond. 2", "Cond. 3", "Cond. 4"))

mt$item1 <- ifelse(mt$item == "Correct", 1, 0)

# Model
m1 <- lmer(item1 ~ rep*survey1 + item_type + (rep*survey1| id), data = mt)
#m2 <- lmer(item1 ~ rep*survey1 + (rep*survey1 | id) + (rep*survey1| item_type), data = mt)
# varying intercepts over conditions and varying slopes over your congenial variable (R3)
#m3 <- lmer(item1 ~ rep*survey1 + (1 + rep*survey1| rep) + (1| survey1) + (rep*survey1 | id), data = mt)
# if you follow gelman: http://www.stat.columbia.edu/~gelman/research/unpublished/multiple2.pdf
# same as m1
m4 <- lmer(item1 ~ rep*survey1 + (1 + survey1| item_type) + (rep*survey1 | id), data = mt)

stargazer(m1, m4, 
          type = "latex", 
          title = "Comparison of Linear Mixed-Effects Models", 
          align = TRUE,
          dep.var.caption = "Dependent Variable: Correct",
          dep.var.labels = "item1",
          omit = "item",
          covariate.labels = c("Congenial", "Cond. 2", "Cond. 3", "Cond. 4",
                               "Congenial × Cond. 2", "Congenial × Cond. 3", "Congenial × Cond. 4", 
                               "Constant"),
          column.labels = c("Model 1", "Model 2"),
          omit.stat = c("LL", "ser", "f", "AIC", "BIC"),
          omit.table.layout = "n",
          header = FALSE,
          out = "../tabs/si_turk_hlm.tex")