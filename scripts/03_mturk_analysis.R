#
# MTurk Survey Experiment
# 

# Set working directory
setwd(basedir)
setwd("misinfo_misinfo")


setwd(githubdir)
setwd("partisan-gaps")


# Loading libraries
library(dplyr)
library(reshape2)
library(goji)
library(broom)

# Source Recode
source("scripts/02_mturk_recode.R")

# Calculation of means for 24k questions for 10
# NA is DK here

roots <- c("birth", "religion", "illegal", "death", "increase", "science", "fraud", "mmr", "deficit")
gs24k_stems_10  <- paste0("X24k_", roots, "_10")
gs24k_stems_8   <- paste0("X24k_", roots, "_8")
gs24k_stems_7   <- paste0("X24k_", roots, "_7")
gs24k_stems_5   <- paste0("X24k_", roots, "_5")

# GS 24
gs24k_10  <- sapply(mturk[mturk$question_type == "24k", gs24k_stems_10], function(x) mean(nona(x)))
gs24k_8   <- sapply(mturk[mturk$question_type == "24k", gs24k_stems_8],  function(x) mean(nona(x)))
gs24k_7   <- sapply(mturk[mturk$question_type == "24k", gs24k_stems_7],  function(x) mean(nona(x)))
gs24k_5   <- sapply(mturk[mturk$question_type == "24k", gs24k_stems_5],  function(x) mean(nona(x)))

# Calculating the means for 14k
gs14k_stems <- paste0("gs14k_", roots)
gs14k   <- sapply(mturk[mturk$question_type == "14k", gs14k_stems], function(x) mean(x))

# Calculating the means for IPS
ip_stems <- paste0("ip_", roots)
ips      <- sapply(mturk[mturk$question_type == "IPS", ip_stems], function(x) mean(x))

# Calculating the means for RW
rw_stems <- paste0("rws_", roots)
rws      <- sapply(mturk[mturk$question_type == "RW", rw_stems], function(x) mean(x))

# Calculating the means for FSR
fsr_stems <- paste0("fsrs_", roots)
fsr       <- sapply(mturk[mturk$question_type == "FSR", fsr_stems], function(x) mean(x))

# RW
# -----------------

mturk$qtype_rw <- factor(mturk$question_type, levels = c("RW", "IPS", "FSR", "14k", "24k"))

rw_birth_lm    <- with(mturk, summary(lm(birth    ~ qtype_rw)))
rw_religion_lm <- with(mturk, summary(lm(religion ~ qtype_rw)))
rw_illegal_lm  <- with(mturk, summary(lm(illegal  ~ qtype_rw)))
rw_death_lm    <- with(mturk, summary(lm(death    ~ qtype_rw)))
rw_increase_lm <- with(mturk, summary(lm(increase ~ qtype_rw)))
rw_science_lm  <- with(mturk, summary(lm(science  ~ qtype_rw)))
rw_fraud_lm    <- with(mturk, summary(lm(fraud    ~ qtype_rw)))
rw_mmr_lm      <- with(mturk, summary(lm(mmr      ~ qtype_rw)))
rw_deficit_lm  <- with(mturk, summary(lm(deficit  ~ qtype_rw)))
rw_avg_lm      <- with(mturk, summary(lm(avg  ~ qtype_rw)))

mturk$qtype_ip <- factor(mturk$question_type, levels = c("IPS", "FSR", "14k", "24k", "RW"))

ip_birth_lm    <- with(mturk, summary(lm(birth    ~ qtype_ip)))
ip_religion_lm <- with(mturk, summary(lm(religion ~ qtype_ip)))
ip_illegal_lm  <- with(mturk, summary(lm(illegal  ~ qtype_ip)))
ip_death_lm    <- with(mturk, summary(lm(death    ~ qtype_ip)))
ip_increase_lm <- with(mturk, summary(lm(increase ~ qtype_ip)))
ip_science_lm  <- with(mturk, summary(lm(science  ~ qtype_ip)))
ip_fraud_lm    <- with(mturk, summary(lm(fraud    ~ qtype_ip)))
ip_mmr_lm      <- with(mturk, summary(lm(mmr      ~ qtype_ip)))
ip_deficit_lm  <- with(mturk, summary(lm(deficit  ~ qtype_ip)))
ip_avg_lm      <- with(mturk, summary(lm(avg  ~ qtype_ip)))

mturk$qtype_fsr <- factor(mturk$question_type, levels = c("FSR", "14k", "24k", "RW", "IPS"))

fsr_birth_lm    <- with(mturk, summary(lm(birth    ~ qtype_fsr)))
fsr_religion_lm <- with(mturk, summary(lm(religion ~ qtype_fsr)))
fsr_illegal_lm  <- with(mturk, summary(lm(illegal  ~ qtype_fsr)))
fsr_death_lm    <- with(mturk, summary(lm(death    ~ qtype_fsr)))
fsr_increase_lm <- with(mturk, summary(lm(increase ~ qtype_fsr)))
fsr_science_lm  <- with(mturk, summary(lm(science  ~ qtype_fsr)))
fsr_fraud_lm    <- with(mturk, summary(lm(fraud    ~ qtype_fsr)))
fsr_mmr_lm      <- with(mturk, summary(lm(mmr      ~ qtype_fsr)))
fsr_deficit_lm  <- with(mturk, summary(lm(deficit  ~ qtype_fsr)))
fsr_avg_lm      <- with(mturk, summary(lm(avg      ~ qtype_fsr)))


# Binding
# -----------------

labs     <- c("Birth", "Religion", "Illegal", "Death", "Increase", "Science", "Fraud", "MMR", "Deficit")
table_2  <- data.frame(labs, rws, ips, fsr, gs14k, gs24k_10)

# RW Diff.
rdub <- c("rw-ip", "rw-fsr", "rw-14k", "rw-24k")
table_2[, rdub]   <- NA 
table_2[1, rdub]  <- paste0(nolead0s( - round(rw_birth_lm$coef[2:5, 1], 3)),  stars(rw_birth_lm$coef[2:5, 4]))
table_2[2, rdub]  <- paste0(nolead0s( - round(rw_religion_lm$coef[2:5, 1], 3)), stars(rw_birth_lm$coef[2:5, 4]))
table_2[3, rdub]  <- paste0(nolead0s( - round(rw_illegal_lm$coef[2:5, 1], 3)), stars(rw_birth_lm$coef[2:5, 4]))
table_2[4, rdub]  <- paste0(nolead0s( - round(rw_death_lm$coef[2:5, 1], 3)), stars(rw_birth_lm$coef[2:5, 4]))
table_2[5, rdub]  <- paste0(nolead0s( - round(rw_increase_lm$coef[2:5, 1], 3)), stars(rw_birth_lm$coef[2:5, 4]))
table_2[6, rdub]  <- paste0(nolead0s( - round(rw_science_lm$coef[2:5, 1], 3)), stars(rw_birth_lm$coef[2:5, 4]))
table_2[7, rdub]  <- paste0(nolead0s( - round(rw_fraud_lm$coef[2:5, 1], 3)), stars(rw_birth_lm$coef[2:5, 4]))
table_2[8, rdub]  <- paste0(nolead0s( - round(rw_mmr_lm$coef[2:5, 1], 3)), stars(rw_birth_lm$coef[2:5, 4]))
table_2[9, rdub]  <- paste0(nolead0s( - round(rw_deficit_lm$coef[2:5, 1], 3)), stars(rw_birth_lm$coef[2:5, 4]))
table_2[10, rdub] <- paste0(nolead0s( - round(rw_avg_lm$coef[2:5, 1], 3)), stars(rw_avg_lm$coef[2:5, 4]))

# IP  Diff.
ipee <- c("ip-fsr", "ip-14k", "ip-24k")
table_2[, ipee]   <- NA 
table_2[1, ipee]  <- paste0(nolead0s( - round(ip_birth_lm$coef[2:4, 1], 3)), stars(rw_birth_lm$coef[2:4, 4]))
table_2[2, ipee]  <- paste0(nolead0s( - round(ip_religion_lm$coef[2:4, 1], 3)), stars(rw_birth_lm$coef[2:4, 4]))
table_2[3, ipee]  <- paste0(nolead0s( - round(ip_illegal_lm$coef[2:4, 1], 3)), stars(rw_birth_lm$coef[2:4, 4]))
table_2[4, ipee]  <- paste0(nolead0s( - round(ip_death_lm$coef[2:4, 1], 3)), stars(rw_birth_lm$coef[2:4, 4]))
table_2[5, ipee]  <- paste0(nolead0s( - round(ip_increase_lm$coef[2:4, 1], 3)), stars(rw_birth_lm$coef[2:4, 4]))
table_2[6, ipee]  <- paste0(nolead0s( - round(ip_science_lm$coef[2:4, 1], 3)), stars(rw_birth_lm$coef[2:4, 4]))
table_2[7, ipee]  <- paste0(nolead0s( - round(ip_fraud_lm$coef[2:4, 1], 3)), stars(rw_birth_lm$coef[2:4, 4]))
table_2[8, ipee]  <- paste0(nolead0s( - round(ip_mmr_lm$coef[2:4, 1], 3)), stars(rw_birth_lm$coef[2:4, 4]))
table_2[9, ipee]  <- paste0(nolead0s( - round(ip_deficit_lm$coef[2:4, 1], 3)), stars(rw_birth_lm$coef[2:4, 4]))
table_2[10, ipee] <- paste0(nolead0s( - round(ip_avg_lm$coef[2:4, 1], 3)), stars(rw_avg_lm$coef[2:4, 4]))

# FSR 
# IP  Diff.
efsr <- c("fsr-14k", "fsr-24k")
table_2[, efsr]   <- NA 
table_2[1, efsr]  <- paste0(nolead0s( - round(fsr_birth_lm$coef[2:3, 1], 3)), stars(rw_birth_lm$coef[2:3, 4]))
table_2[2, efsr]  <- paste0(nolead0s( - round(fsr_religion_lm$coef[2:3, 1], 3)), stars(rw_birth_lm$coef[2:3, 4]))
table_2[3, efsr]  <- paste0(nolead0s( - round(fsr_illegal_lm$coef[2:3, 1], 3)), stars(rw_birth_lm$coef[2:3, 4]))
table_2[4, efsr]  <- paste0(nolead0s( - round(fsr_death_lm$coef[2:3, 1], 3)), stars(rw_birth_lm$coef[2:3, 4]))
table_2[5, efsr]  <- paste0(nolead0s( - round(fsr_increase_lm$coef[2:3, 1], 3)), stars(rw_birth_lm$coef[2:3, 4]))
table_2[6, efsr]  <- paste0(nolead0s( - round(fsr_science_lm$coef[2:3, 1], 3)), stars(rw_birth_lm$coef[2:3, 4]))
table_2[7, efsr]  <- paste0(nolead0s( - round(fsr_fraud_lm$coef[2:3, 1], 3)), stars(rw_birth_lm$coef[2:3, 4]))
table_2[8, efsr]  <- paste0(nolead0s( - round(fsr_mmr_lm$coef[2:3, 1], 3)), stars(rw_birth_lm$coef[2:3, 4]))
table_2[9, efsr]  <- paste0(nolead0s( - round(fsr_deficit_lm$coef[2:3, 1], 3)), stars(rw_birth_lm$coef[2:3, 4]))
table_2[10, efsr] <- paste0(nolead0s( - round(fsr_avg_lm$coef[2:3, 1], 3)), stars(rw_avg_lm$coef[2:3, 4]))

# Remove Fraud and Partisan
table_2 <- table_2[- c(7, 9), ]

# Average
round(colMeans(sapply(table_2[1:7, 2:6], as.numeric)), 3)

#table_2[10, ] <- c("Average", colMeans(table_2[2:15]))
table_2[9, ] <- c("n", table(factor(mturk$question_type, levels = c("RW", "IPS", "FSR", "14k", "24k"))), rep("", 9))

write.csv(table_2, file = "res/table_2_mturk.csv", row.names = F)

# SI Table for Alternate Scoring Regimes

si_table_e1_alternate_coding_mturk <- data.frame(gs24k_10, gs24k_8, gs24k_7, gs24k_5)
si_table_e1_alternate_coding_mturk <- si_table_e1_alternate_coding_mturk[ - c(7, 9), ]
si_table_e1_alternate_coding_mturk[8,] <- colMeans(si_table_e1_alternate_coding_mturk)

write.csv(si_table_e1_alternate_coding_mturk, file = "res/si_table_e1_alternate_coding_mturk.csv", row.names = F)
