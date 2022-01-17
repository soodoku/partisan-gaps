##--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~---++
##   
## Misinformation
## YouGov/Polimetrix Survey (Selective Exposure)
## Last Edited: 08.28.13  
##   
##--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~---++


# Set Working dir.
setwd(basedir)

# Sourcing Common Functions
source("func/func.R")

# Load data
load("misinformation/data/selex.recode.rdata")

# Factor PID so that Ind. is the base
selex$pid3 <- factor(selex$pid3, levels=c("Independent", "Democrat", "Republican"))

# PK 
# Manipulations: 
# Picture: qpk1_treat, qpk2_treat 
# DK/offer a guess: qpk1, qpk1_force
# DK/offer a guess: qpk2, qpk2_force
# DK/Noffer a guess: qpk3, qpk3_force
# R/D Unemployment: qpk7 (qpk7_insert)
# R/D Budget Deficit: qpk8 (qpk8_insert)

# qpk9: BO Religion
# qpk10: MR Religion
# ideo_dem, ideo_rep
# ideo_ows, ideo_tp
# ideo_mr, ideo_bo

# Pictures
summary(lm(selex$boehner2 ~ selex$qpk1_treat))
summary(lm(selex$breyer2 ~ selex$qpk2_treat))

# Partisanship
summary(lm(I(selex$qpk7=='Gone Down') ~ as.factor(selex$qpk7_insert)*selex$pid))
summary(lm(I(selex$qpk8=='Gone Down') ~ as.factor(selex$qpk7_insert)*selex$pid2))

a <- glm(I(selex$qpk7=='Gone Down') ~ as.factor(selex$qpk7_insert)*selex$pid3, family="binomial")
b <- glm(I(selex$qpk8=='Gone Down') ~ as.factor(selex$qpk7_insert)*selex$pid3, family="binomial")

ng(a)
ng(b)
c <- cbind(round(summary(a)$coef[,c(1,4)],3), round(summary(b)$coef[,c(1,4)],3))

write.csv(c, file="misinformation/c.csv")


