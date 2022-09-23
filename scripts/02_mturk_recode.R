#
# MTurk Survey Experiment
# 

# Set working directory
# commented paths for call in the 03_mturk_analysis.R script
#setwd(basedir)
#setwd("misinfo_misinfo")

#setwd(githubdir)
#setwd("partisan-gaps")


# Loading libraries
library(dplyr)
library(reshape2)
library(goji)
library(broom)

# Read in data
mturk <- read.csv("data/turk/mam_mturk_070917.csv", header = TRUE, stringsAsFactors = FALSE)

# Preparing data for analysis
mturk <- mturk[-c(1:2),] 

# Recode consent to 1 if agree, NA otherwise
table(mturk$consent)

# 32 didn't get MTurk Code and 11 didn't finish
table(mturk$mTurkCode == "")
table(mturk$Finished)
mturk <- subset(mturk, mTurkCode != "" & mturk$Finished == "True")

# Randomization in Don't Know Pledge
mturk$dk_pledge <- recode(mturk$pledge, "Yes" = "DK Enc", "No" = "DK Enc", .default = "DK Neutral")

# Check randomization
# 2/5 (.4) do not receive DK pledge treatment and 3/5 do (.6)
table(mturk$consent, mturk$dk_pledge, useNA = "always")

# Randomization across question type 
# Needs to be 1/5 (.2) each
table(mturk$consent, mturk$question_type, useNA = "always")

#------------------------------------------------------------

# 24k Gold Standard
# Empty strings in 24k = Don't Know

# Renaming the for 24k questions
mturk <- rename(mturk, 
	                 X24k_birth    = X24k_block1_3, 
	                 X24k_religion = X24k_block1_4,
	                 X24k_illegal  = X24k_block1_5,
	                 X24k_death    = X24k_block1_6,
	                 X24k_increase = X24k_block2_1,
	                 X24k_science  = X24k_block2_2,
	                 X24k_fraud    = X24k_block2_3,
	                 X24k_mmr      = X24k_block2_4,
	                 X24k_deficit  = X24k_block2_5)

# Convert to numeric (converts time to numeric also)
mturk[, grep("X24k", names(mturk))] <- lapply(mturk[, grep("X24k", names(mturk))], as.numeric)

# 24k
# -------------------

# If people pick correct at 10 or 0
mturk$X24k_birth_10    <- mturk$X24k_birth == 0
mturk$X24k_religion_10 <- mturk$X24k_religion == 10
mturk$X24k_illegal_10  <- mturk$X24k_illegal == 10
mturk$X24k_death_10    <- mturk$X24k_death == 0
mturk$X24k_increase_10 <- mturk$X24k_increase == 0
mturk$X24k_science_10  <- mturk$X24k_science == 10
mturk$X24k_fraud_10    <- mturk$X24k_fraud == 10
mturk$X24k_mmr_10      <- mturk$X24k_mmr == 10
mturk$X24k_deficit_10  <- mturk$X24k_deficit == 0

# If people pick correct > 8
mturk$X24k_birth_8    <- mturk$X24k_birth < 2
mturk$X24k_religion_8 <- mturk$X24k_religion > 8
mturk$X24k_illegal_8  <- mturk$X24k_illegal > 8
mturk$X24k_death_8    <- mturk$X24k_death < 2
mturk$X24k_increase_8 <- mturk$X24k_increase < 2
mturk$X24k_science_8  <- mturk$X24k_science > 8
mturk$X24k_fraud_8    <- mturk$X24k_fraud > 8
mturk$X24k_mmr_8      <- mturk$X24k_mmr > 8
mturk$X24k_deficit_8  <- mturk$X24k_deficit < 2

# If people pick correct > 7
mturk$X24k_birth_7    <- mturk$X24k_birth < 3
mturk$X24k_religion_7 <- mturk$X24k_religion > 7
mturk$X24k_illegal_7  <- mturk$X24k_illegal > 7
mturk$X24k_death_7    <- mturk$X24k_death < 3
mturk$X24k_increase_7 <- mturk$X24k_increase < 3
mturk$X24k_science_7  <- mturk$X24k_science > 7
mturk$X24k_fraud_7    <- mturk$X24k_fraud > 7
mturk$X24k_mmr_7      <- mturk$X24k_mmr > 7
mturk$X24k_deficit_7  <- mturk$X24k_deficit < 3

# If people pick correct > 5
mturk$X24k_birth_5    <- mturk$X24k_birth < 5
mturk$X24k_religion_5 <- mturk$X24k_religion > 5
mturk$X24k_illegal_5  <- mturk$X24k_illegal > 5
mturk$X24k_death_5    <- mturk$X24k_death < 5
mturk$X24k_increase_5 <- mturk$X24k_increase < 5
mturk$X24k_science_5  <- mturk$X24k_science > 5
mturk$X24k_fraud_5    <- mturk$X24k_fraud > 5
mturk$X24k_mmr_5      <- mturk$X24k_mmr > 5
mturk$X24k_deficit_5  <- mturk$X24k_deficit < 5


# 14k Gold Standard
# ------------------------

mturk$gs14k_birth       <- mturk$X14k_birth    == "Another country"
mturk$gs14k_religion    <- mturk$X14k_religion == "Muslim"
mturk$gs14k_illegal     <- mturk$X14k_illegal  == "Give illegal immigrants financial help to buy health insurance"
mturk$gs14k_death       <- mturk$X14k_death    == "Creates government panels to make decisions about end-of-life care"
mturk$gs14k_increase    <- mturk$X14k_increase == "Increasing because natural variation over time, such as produced the ice age" | 
                           mturk$X14k_increase == "Staying about the same as they have been"
mturk$gs14k_science     <- mturk$X14k_science  == 
                           "Climate scientists are about equally divided about whether global warming is occurring or not" |
                           mturk$X14k_science  == "Most climate scientists believe that global warming is NOT occurring"
mturk$gs14k_fraud       <- mturk$X14k_fraud    == "Win the majority of the legally cast votes"
mturk$gs14k_mmr         <- mturk$X14k_mmr      == "Cause autism in children"
mturk$gs14k_deficit     <- mturk$X14k_deficit  == "Decreased" | mturk$X14k_deficit == "Stayed about the same"

# IP Standard
# ------------------------

mturk$ip_birth       <- mturk$ips_birth    == "Another country"
mturk$ip_religion    <- mturk$ips_religion == "Muslim"
mturk$ip_illegal     <- mturk$ips_illegal  == "Gives illegal immigrants financial help to buy health insurance"
mturk$ip_death       <- mturk$ips_death    == "Creates government panels to make decisions about end-of-life care"
mturk$ip_increase    <- mturk$ips_increase == "Increasing because of natural variation over time, such as produced the ice age" | 
                        mturk$ips_increase == "Staying about the same as they have been"
mturk$ip_science     <- mturk$ips_science  == 
                           "Climate scientists are about equally divided about whether global warming is occurring or not" |
                        mturk$ips_science  == "Most climate scientists believe that global warming is not occurring"
mturk$ip_fraud       <- mturk$ips_fraud    == "Won the majority of the legally cast votes"
mturk$ip_mmr         <- mturk$ips_mmr      == "Causes autism in children"
mturk$ip_deficit     <- mturk$ips_deficit  == "Decreased" | mturk$X14k_deficit == "Stayed about the same"

# RW 
# ----------------------

mturk$rws_birth       <- mturk$rw_birth    == "Another country"
mturk$rws_religion    <- mturk$rw_religion == "Muslim"
mturk$rws_illegal     <- mturk$rw_illegal  == "Gives illegal immigrants financial help to buy health insurance"
mturk$rws_death       <- mturk$rw_death    == "Creates government panels to make decisions about end-of-life care"
mturk$rws_increase    <- mturk$rw_increase ==  "Increasing because of natural variation over time, such as produced the ice age" | 
                         mturk$rw_increase == "Staying about the same as they have been"
mturk$rws_science     <- mturk$rw_science  == 
                           "Climate scientists are about equally divided about whether global warming is occurring or not" |
                         mturk$rw_science  == "Most climate scientists believe that global warming is not occurring"
mturk$rws_fraud       <- mturk$rw_fraud    == "Won the majority of the legally cast votes"
mturk$rws_mmr         <- mturk$rw_mmr      == "Causes autism in children"
mturk$rws_deficit     <- mturk$rw_deficit  == "Decreased" | mturk$X14k_deficit == "Stayed about the same"

# FSR
# ---------------------------

mturk$fsrs_birth       <- mturk$fsr_birth    == "Another country"
mturk$fsrs_religion    <- mturk$fsr_religion == "Muslim"
mturk$fsrs_illegal     <- mturk$fsr_illegal  == "Give illegal immigrants financial help to buy health insurance"
mturk$fsrs_death       <- mturk$fsr_death    == "Creates government panels to make decisions about end-of-life care"
mturk$fsrs_increase    <- mturk$fsr_increase == "Increasing because of natural variation over time, such as produced the ice age" | 
                          mturk$fsr_increase == "Staying about the same as they have been"
mturk$fsrs_science     <- mturk$fsr_science  == 
                           "Climate scientists are about equally divided about whether global warming is occurring or not" |
                          mturk$fsr_science  == "Most climate scientists believe that global warming is not occurring"
mturk$fsrs_fraud       <- mturk$fsr_fraud    == "Win the majority of the legally cast votes"
mturk$fsrs_mmr         <- mturk$fsr_mmr      == "Cause autism in children"
mturk$fsrs_deficit     <- mturk$fsr_deficit  == "Decreased" | mturk$X14k_deficit == "Stayed about the same"

# One var. per item
# ----------------------
mturk$birth <- with(mturk, 
                    ifelse(question_type == "RW",  rws_birth,
                    ifelse(question_type == "IPS", ip_birth,
                    ifelse(question_type == "FSR", fsrs_birth,
                    ifelse(question_type == "14k", gs14k_birth, X24k_birth_10)))))

mturk$religion <- with(mturk, 
                    ifelse(question_type == "RW",  rws_religion,
                    ifelse(question_type == "IPS", ip_religion,
                    ifelse(question_type == "FSR", fsrs_religion,
                    ifelse(question_type == "14k", gs14k_religion, X24k_religion_10)))))

mturk$illegal <- with(mturk, 
                    ifelse(question_type == "RW",  rws_illegal,
                    ifelse(question_type == "IPS", ip_illegal,
                    ifelse(question_type == "FSR", fsrs_illegal,
                    ifelse(question_type == "14k", gs14k_illegal, X24k_illegal_10)))))

mturk$death <- with(mturk, 
                    ifelse(question_type == "RW",  rws_death,
                    ifelse(question_type == "IPS", ip_death,
                    ifelse(question_type == "FSR", fsrs_death,
                    ifelse(question_type == "14k", gs14k_death, X24k_death_10)))))

mturk$increase <- with(mturk, 
                    ifelse(question_type == "RW",  rws_increase,
                    ifelse(question_type == "IPS", ip_increase,
                    ifelse(question_type == "FSR", fsrs_increase,
                    ifelse(question_type == "14k", gs14k_increase, X24k_increase_10)))))

mturk$science <- with(mturk, 
                    ifelse(question_type == "RW",  rws_science,
                    ifelse(question_type == "IPS", ip_science,
                    ifelse(question_type == "FSR", fsrs_science,
                    ifelse(question_type == "14k", gs14k_science, X24k_science_10)))))

mturk$fraud <- with(mturk, 
                    ifelse(question_type == "RW",  rws_fraud,
                    ifelse(question_type == "IPS", ip_fraud,
                    ifelse(question_type == "FSR", fsrs_fraud,
                    ifelse(question_type == "14k", gs14k_fraud, X24k_fraud_10)))))

mturk$mmr <- with(mturk, 
                    ifelse(question_type == "RW",  rws_mmr,
                    ifelse(question_type == "IPS", ip_mmr,
                    ifelse(question_type == "FSR", fsrs_mmr,
                    ifelse(question_type == "14k", gs14k_mmr, X24k_mmr_10)))))

mturk$deficit <- with(mturk, 
                    ifelse(question_type == "RW",  rws_deficit,
                    ifelse(question_type == "IPS", ip_deficit,
                    ifelse(question_type == "FSR", fsrs_deficit,
                    ifelse(question_type == "14k", gs14k_deficit, X24k_deficit_10)))))

mturk$avg <- with(mturk, rowMeans(cbind(birth, religion, illegal, death, increase, science, mmr), na.rm = T))
