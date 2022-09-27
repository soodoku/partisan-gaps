#
# mturk_hk  Recode 
#

# Set dir
#setwd(basedir)
#setwd("partisan-gaps")

#setwd(githubdir)
#setwd("partisan-gaps")

# Load libraries
#install.packages("devtools")
#devtools::install_github("soodoku/goji")
library(goji)
library(stringr)
library(tidyverse)
library(mosaic)

# Load functions
source("scripts/00_common_func.R")
source("http://pcwww.liv.ac.uk/~william/R/crosstab.r")

# Read in the data
mturk_hk <- read.csv("data/mturk_hk/hidden_knowledge_March 28, 2017_20.29.csv", 
                  header = TRUE, stringsAsFactors = FALSE) |> 
  filter(!row_number() %in% c(1,2)) |> 
  mutate(valid    = case_when(consent == "I agree" ~ "1"),
         cnc_test = case_when(cheat_no_cheat == "no_cheat" ~ "No Treatment",
                              cheat_no_cheat == "cheat" ~ "Treatment",
                              TRUE ~ "0"),
         visual_test = case_when(is.na(visual) ~ "0",
                                 TRUE ~ as.character(visual)),
         rg_test = case_when(is.na(reticence_guessing) ~ "0",
                                 TRUE ~ as.character(reticence_guessing)),
         fugitive_test = case_when(is.na(fugitive) ~ "0",
                                  TRUE ~ as.character(fugitive)),
         probe_test = case_when(is.na(probe) ~ "0",
                                   TRUE ~ as.character(probe)),
         fugivisual = case_when(is.na(fugitive_visual) ~ "0",
                                TRUE ~ as.character(fugitive_visual))) |> 
  filter(!is.na(valid) & ccode=="US" & cheat_no_cheat != "")


# --------------------------------
# Randomizing variables:
# cheat_no_cheat: cheat / no_cheat
# visual: text / photo
# reticence_guessing: closed / scale 
# fugitive: photo / text
# probe: open / closed 
# fugitive_visual: closed / asses 

# 1. Check that there are no missing values in randomization variables
# Included in the crosstabs below

# 2. Check that the randomization is producing roughly balanced data


# Randomization in Cheat_no_cheat
# 1/3--2/3
# Crosstab needs to produce: 2/3 receive treatment and 1/3 do not receive treatment
crosstab(mturk_hk , row.vars = "valid", col.vars = "cnc_test", type = "f")

# Randomization in Visualization
# Crosstab needs to show 50:50 randomization
crosstab(mturk_hk , row.vars = "valid", col.vars = "visual_test", type = "f")

# Randomization in Reticence Guessing
# Crosstab needs to show 50:50 randomization
crosstab(mturk_hk , row.vars = "valid", col.vars = "rg_test", type = "f")

# Randomization in Fugitive
# Crosstab needs to show 50:50 randomization
crosstab(mturk_hk , row.vars = "valid", col.vars = "fugitive_test", type = "f")

# Randomization in Probe
# Crosstab needs to show 1/3 open and 2/3 closed
crosstab(mturk_hk , row.vars = "valid", col.vars = "probe_test", type = "f")

# Randomization in Fugitive Visual
# Crosstab needs to show 50:50 randomization
crosstab(mturk_hk , row.vars = "valid", col.vars = "fugivisual", type = "f")

# 3. Check that crosstabs of independent randomizations have all 4 conditions (if 2*2)

# Probe and CNC
crosstab(mturk_hk , row.vars = c("valid", "cnc_test"), col.vars = "probe_test", type = "f", subtotals = FALSE)



# Visual cues in form of portraits 
# --------------------------------------

# Mitch McConnell
# Strict:    Senate Majority Leader, 
# Generous:  Senate + Republican, Senate + Kentucky + Senate + Leader, Majority + Leader, Senate Chair, Senate President, Senate Head
mturk_hk$mmcv 	<- str_detect(mturk_hk$vp_mmc, regex("senat|sente|majority", ignore_case = TRUE)) &
		       str_detect(mturk_hk$vp_mmc, regex("leader|chief|leder|head|president|chair", ignore_case = TRUE))

# Chuck Schumer 		       
# Senate + Leadership, Senate + NY, Senate + Democrat 
mturk_hk$csv 	<- str_detect(mturk_hk$vp_js, regex("senat|sente|senet|minority", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vp_js, regex("ldr|leader|in charge", ignore_case = TRUE))

# Angela Merkel
# Germany + leader 
mturk_hk$amv 	<- str_detect(mturk_hk$vp_am, regex("german", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vp_am, regex("pres|prez|leader|head|chanc|canc|chans|kansler|pm|premier|prime|chief|ruler|charge", ignore_case = TRUE))

# Vladimir Putin
# Russia + leader 
mturk_hk$vpv 	<- str_detect(mturk_hk$vp_vp, regex("russ|ruussia", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vp_vp, regex("pres|prez|preesident|leader|head|top dog|chancellor|pm|premier|prime|chief|ruler", ignore_case = TRUE))

# John Roberts
# Chief Justice, SC Justice 
mturk_hk$jrv 	<- str_detect(mturk_hk$vp_jr, regex("chief|chei", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vp_jr, regex("justice", ignore_case = TRUE))

# Nancy Pelosi
# House + Leader, Minority Leader, House + 
mturk_hk$npv 	<- str_detect(mturk_hk$vp_np, regex("minority", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vp_np, regex("leader", ignore_case = TRUE))

# Text cues in form of name
# ----------------------------
# Mitch McConnell 
mturk_hk$mmct 	<- str_detect(mturk_hk$vt_mmc, regex("senat|sente", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vt_mmc, regex("leader|chief|leder|head|president|chair|whip", ignore_case = TRUE))

mturk_hk$cst 	<- str_detect(mturk_hk$vt_cs, regex("senat|sente|senet|minority", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vt_cs, regex("ldr|leader|in charge", ignore_case = TRUE))

mturk_hk$amt 	<- str_detect(mturk_hk$vt_am, regex("german", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vt_am, regex("pres|prez|leader|head|chanc|canc|chans|kansler|pm|premier|prime|chief|ruler|charge", ignore_case = TRUE))

mturk_hk$vpt 	<- str_detect(mturk_hk$vt_vp, regex("russ", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vt_vp, regex("pres|prez|preesident|leader|head|top dog|chancellor|pm|premier|prime|chief|ruler", ignore_case = TRUE))

mturk_hk$jrt	<- str_detect(mturk_hk$vt_jr, regex("chief|chei", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vt_jr, regex("justice", ignore_case = TRUE))

mturk_hk$npt 	<- str_detect(mturk_hk$vt_np, regex("minority", ignore_case = TRUE)) & 
		       str_detect(mturk_hk$vt_np, regex("leader",  ignore_case = TRUE))

# Combine the vis and the text 
mturk_hk$mcconnell_vis_txt <- with(mturk_hk , ifelse(visual_test=="text", mmct, mmcv))
mturk_hk$schumer_vis_txt   <- with(mturk_hk , ifelse(visual_test=="text", cst, csv))
mturk_hk$merkel_vis_txt    <- with(mturk_hk , ifelse(visual_test=="text", amt, amv))
mturk_hk$putin_vis_txt     <- with(mturk_hk , ifelse(visual_test=="text", vpt, vpv))
mturk_hk$roberts_vis_txt   <- with(mturk_hk , ifelse(visual_test=="text", jrt, jrv))
mturk_hk$pelosi_vis_txt    <- with(mturk_hk , ifelse(visual_test=="text", npt, npv))

# Reticence, Guessing 
# --------------------------------

# We screwed up on gg2 so removing that: 
# gg2: Unconnected to burning natural gas (1), Produced more by burning clean coal than by burning other fossil fuels (2)
# Produced by nuclear power plants (3), Reduced by trees and other plants (4), Don’t know (5)

mturk_hk$aca   <- nona(mturk_hk$rgc_o_aca  == "Increase the Medicare payroll tax for upper-income Americans" | mturk_hk$rgc_c_aca == "Increase the Medicare payroll tax for upper-income Americans")
mturk_hk$aca2	<- nona(mturk_hk$rgc_o_aca2 == "Limit future increases in payments to Medicare providers" | mturk_hk$rgc_c_aca2 == "Limit future increases in payments to Medicare providers")
mturk_hk$gg 	<- nona(mturk_hk$rgc_o_gg   == "A cause of rising sea levels" | mturk_hk$rgc_c_gg == "A cause of rising sea levels")
#mturk_hk$gg2 	<- nona(mturk_hk$rgc_o_gg2  == "Reduced by trees and other plants" | mturk_hk$rgc_c_gg2 == "Reduced by trees and other plants")
mturk_hk$dt 	<- nona(mturk_hk$rgc_o_dt   == "Temporarily ban immigrants from several majority-Muslim countries" | mturk_hk$rgc_c_dt == "Temporarily ban immigrants from several majority-Muslim countries")


# If people pick correct at 10
mturk_hk$aca_10  <- nona(mturk_hk$rg_s_aca_3=="10")
mturk_hk$aca2_10 <- nona(mturk_hk$rg_s_aca2_3=="10")
mturk_hk$gg_10   <- nona(mturk_hk$rg_s_gg_4=="10")
#mturk_hk$gg2_10  <- nona(mturk_hk$rg_s_gg2_2=="10")
mturk_hk$dt_10   <- nona(mturk_hk$rg_s_dt_4=="10")

# If people pick correct > 7
mturk_hk$aca_7   <- nona(as.numeric(mturk_hk$rg_s_aca_3) > 7)
mturk_hk$aca2_7  <- nona(as.numeric(mturk_hk$rg_s_aca2_3) > 7)
mturk_hk$gg_7    <- nona(as.numeric(mturk_hk$rg_s_gg_4) > 7)
#mturk_hk$gg2_7   <- nona(as.numeric(mturk_hk$rg_s_gg2_2) > 7)
mturk_hk$dt_7    <- nona(as.numeric(mturk_hk$rg_s_dt_4) > 7)

# Most certain about correct 
mturk_hk$aca_mcc   <- most_conf(as.numeric(mturk_hk$rg_s_aca_3),  as.numeric(mturk_hk$rg_s_aca_1),  as.numeric(mturk_hk$rg_s_aca_2),  as.numeric(mturk_hk$rg_s_aca_4))
mturk_hk$aca2_mcc  <- most_conf(as.numeric(mturk_hk$rg_s_aca2_3), as.numeric(mturk_hk$rg_s_aca2_1), as.numeric(mturk_hk$rg_s_aca2_2), as.numeric(mturk_hk$rg_s_aca2_4))
mturk_hk$gg_mcc    <- most_conf(as.numeric(mturk_hk$rg_s_gg_4),   as.numeric(mturk_hk$rg_s_gg_1),   as.numeric(mturk_hk$rg_s_gg_2),   as.numeric(mturk_hk$rg_s_gg_3))
#mturk_hk$gg2_mcc   <- most_conf(as.numeric(mturk_hk$rg_s_gg2_2),  as.numeric(mturk_hk$rg_s_gg2_1),  as.numeric(mturk_hk$rg_s_gg2_3),  as.numeric(mturk_hk$rg_s_gg2_4))
mturk_hk$dt_mcc    <- most_conf(as.numeric(mturk_hk$rg_s_dt_4),   as.numeric(mturk_hk$rg_s_dt_1),   as.numeric(mturk_hk$rg_s_dt_2),   as.numeric(mturk_hk$rg_s_dt_3))

# Closed responses -  Cheating, guessing, inference, expressive
mturk_hk$oc_pc 	<- nona(mturk_hk$obama_c == "Increased")
mturk_hk$bc_pc 	<- nona(mturk_hk$bush_c == "Increased")
mturk_hk$aca2c_pc 	<- nona(mturk_hk$rgc_c_aca2 == "Limit future increases in payments to Medicare providers")
#mturk_hk$gg2c_pc	<- nona(mturk_hk$rgc_c_gg2 == "Reduced by trees and other plants")
mturk_hk$dtc_pc	<- nona(mturk_hk$rgc_c_dt == "Temporarily ban immigrants from several majority-Muslim countries")

# correct _actual knowledge
mturk_hk$oc_ak 	<- nona(mturk_hk$obama_c == "Increased" & grepl("heard that", mturk_hk$obama_c_p))
mturk_hk$bc_ak 	<- nona(mturk_hk$bush_c == "Increased"  & grepl("heard that", mturk_hk$bush_c_p))
mturk_hk$aca2c_ak 	<- nona(mturk_hk$rgc_c_aca2 == "Limit future increases in payments to Medicare providers" & grepl("heard that", mturk_hk$rgc_c_aca2_p))
#mturk_hk$gg2c_ak	<- nona(mturk_hk$rgc_c_gg2 == "Reduced by trees and other plants"  & grepl("heard that", mturk_hk$rgc_c_gg2_p))
mturk_hk$dtc_ak	<- nona(mturk_hk$rgc_c_dt == "Temporarily ban immigrants from several majority-Muslim countries" & grepl("heard that", mturk_hk$rgc_c_dt_p))

# correct _cheating
mturk_hk$oc_ch 	<- nona(mturk_hk$obama_c == "Increased" & (mturk_hk$obama_c_p == "I looked it up" | mturk_hk$obama_c_p == "I asked someone I know"))
mturk_hk$bc_ch 	<- nona(mturk_hk$bush_c == "Increased"  & (mturk_hk$bush_c_p == "I looked it up" | mturk_hk$bush_c_p == "I asked someone I know"))
mturk_hk$aca2c_ch 	<- nona(mturk_hk$rgc_c_aca2 == "Limit future increases in payments to Medicare providers" & (mturk_hk$rgc_c_aca2_p == "I looked it up" | mturk_hk$rgc_c_aca2_p == "I asked someone I know"))
#mturk_hk$gg2c_ch 	<- nona(mturk_hk$rgc_c_gg2 == "Reduced by trees and other plants" & (mturk_hk$rgc_c_gg2_p == "I looked it up" | mturk_hk$rgc_c_gg2_p == "I asked someone I know"))
mturk_hk$dtc_ch 	<- nona(mturk_hk$rgc_c_dt == "Temporarily ban immigrants from several majority-Muslim countries" & (mturk_hk$rgc_c_dt_p == "I looked it up" | mturk_hk$rgc_c_dt_p == "I asked someone I know"))

# correct _guessing
mturk_hk$oc_gu 	<- nona(mturk_hk$obama_c == "Increased"  & grepl("shot", mturk_hk$obama_c_p))
mturk_hk$bc_gu 	<- nona(mturk_hk$bush_c == "Increased"   & grepl("shot", mturk_hk$bush_c_p))
mturk_hk$aca2c_gu 	<- nona(mturk_hk$rgc_c_aca2 == "Limit future increases in payments to Medicare providers" & grepl("shot", mturk_hk$rgc_c_aca2_p))
#mturk_hk$gg2c_gu 	<- nona(mturk_hk$rgc_c_gg2 == "Reduced by trees and other plants" & grepl("shot", mturk_hk$rgc_c_gg2_p))
mturk_hk$dtc_gu 	<- nona(mturk_hk$rgc_c_dt == "Temporarily ban immigrants from several majority-Muslim countries"  & grepl("shot", mturk_hk$rgc_c_dt_p))

#correct _inference
mturk_hk$oc_in 	<- nona(mturk_hk$obama_c == "Increased" & mturk_hk$obama_c_p == "It makes sense, in view of other things I know")
mturk_hk$bc_in 	<- nona(mturk_hk$bush_c == "Increased"  & mturk_hk$bush_c_p  == "It makes sense, in view of other things I know")
mturk_hk$aca2c_in 	<- nona(mturk_hk$rgc_c_aca2 == "Limit future increases in payments to Medicare providers" & mturk_hk$rgc_c_aca2_p == "It makes sense, in view of other things I know")
#mturk_hk$gg2c_in 	<- nona(mturk_hk$rgc_c_gg2 == "Reduced by trees and other plants" & mturk_hk$rgc_c_gg2_p == "It makes sense, in view of other things I know")
mturk_hk$dtc_in 	<- nona(mturk_hk$rgc_c_dt == "Temporarily ban immigrants from several majority-Muslim countries" & mturk_hk$rgc_c_dt_p == "It makes sense, in view of other things I know")

# Obama/Bush correct _expressive
mturk_hk$oc_ex 	<- nona(mturk_hk$obama_c == "Increased" & mturk_hk$obama_c_p == "It makes me feel good to think that")
mturk_hk$bc_ex 	<- nona(mturk_hk$bush_c == "Increased" & mturk_hk$bush_c_p == "It makes me feel good to think that")
mturk_hk$aca2c_ex 	<- nona(mturk_hk$rgc_c_aca2 == "Limit future increases in payments to Medicare providers" & mturk_hk$rgc_c_aca2_p == "It makes me feel good to think that")
#mturk_hk$gg2c_ex 	<- nona(mturk_hk$rgc_c_gg2 == "Reduced by trees and other plants" & mturk_hk$rgc_c_gg2_p == "It makes me feel good to think that")
mturk_hk$dtc_ex 	<- nona(mturk_hk$rgc_c_dt == "Temporarily ban immigrants from several majority-Muslim countries" & mturk_hk$rgc_c_dt_p == "It makes me feel good to think that")

# Fugitive Knowledge Questions 
# ---------------------------------------
# Text closed
mturk_hk$ftc_am_c	<- nona(mturk_hk$ftc_am == "Chancellor of Germany") 
mturk_hk$ftc_mmc_c	<- nona(mturk_hk$ftc_mmc == "U.S. Senate Majority Leader") 

# Text scale
# If people pick correct at 100
mturk_hk$fts_am_10	  <- nona(mturk_hk$fts_am_3 == "100") 
mturk_hk$fts_mmc_10  <- nona(mturk_hk$fts_mmc_3 == "100") 

# If people pick correct > 80
mturk_hk$fts_am_8	  <- nona(as.numeric(mturk_hk$fts_am_3) > 80) 
mturk_hk$fts_mmc_8	  <- nona(as.numeric(mturk_hk$fts_mmc_3) > 80) 

# If people pick correct > 70
mturk_hk$fts_am_7	  <- nona(as.numeric(mturk_hk$fts_am_3) > 70) 
mturk_hk$fts_mmc_7	  <- nona(as.numeric(mturk_hk$fts_mmc_3) > 70) 

# Most certain about correct 
mturk_hk$fts_am_mcc   <- most_conf(mturk_hk$fts_am_3, mturk_hk$fts_am_1, mturk_hk$fts_am_2, mturk_hk$fts_am_4) 
mturk_hk$fts_mmc_mcc  <- most_conf(mturk_hk$fts_mmc_3, mturk_hk$fts_mmc_1, mturk_hk$fts_mmc_2, mturk_hk$fts_mmc_4) 

# Visual closed 
mturk_hk$fvc_am_c	  <- nona(mturk_hk$fvc_am == "Chancellor of Germany") 
mturk_hk$fvc_mmc_c	  <- nona(mturk_hk$fvc_mmc == "U.S. Senate Majority Leader")

# Visual scale 
# If people pick correct at 100
mturk_hk$fvs_am_10   <- nona(mturk_hk$fvs_am_3 == "100") 
mturk_hk$fvs_mmc_10  <- nona(mturk_hk$fvs_mmc_3 == "100") 

# If people pick correct > 80
mturk_hk$fvs_am_8	  <- nona(as.numeric(mturk_hk$fvs_am_3) > 80) 
mturk_hk$fvs_mmc_8	  <- nona(as.numeric(mturk_hk$fvs_mmc_3) > 80) 


# If people pick correct > 70
mturk_hk$fvs_am_7	  <- nona(as.numeric(mturk_hk$fvs_am_3) > 70) 
mturk_hk$fvs_mmc_7	  <- nona(as.numeric(mturk_hk$fvs_mmc_3) > 70) 

# Most certain about correct 
mturk_hk$fvs_am_mcc   <- most_conf(mturk_hk$fvs_am_3, mturk_hk$fvs_am_1, mturk_hk$fvs_am_2, mturk_hk$fvs_am_4) 
mturk_hk$fvs_mmc_mcc  <- most_conf(mturk_hk$fvs_mmc_3, mturk_hk$fvs_mmc_1, mturk_hk$fvs_mmc_2, mturk_hk$fvs_mmc_4) 

# Combine open and closed
# ------------------------------------
mturk_hk$mmc_photo_oc <- with(mturk_hk , ifelse(probe_test=="closed", fvc_mmc_c, mmcv))
mturk_hk$mmc_text_oc  <- with(mturk_hk , ifelse(probe_test=="closed", ftc_mmc_c, mmct))
mturk_hk$am_photo_oc  <- with(mturk_hk , ifelse(probe_test=="closed", fvc_am_c, amv))
mturk_hk$am_text_oc   <- with(mturk_hk , ifelse(probe_test=="closed", ftc_am_c, amt))

# Inference Obama and Bush
# ------------------------------------

# Obama 
mturk_hk$obama_cor  <- nona(mturk_hk$obama_o == "Increased" | mturk_hk$obama_c == "Increased")

# Bush
mturk_hk$bush_cor 	 <- nona(mturk_hk$bush_o == "Increased"  | mturk_hk$bush_c == "Increased")

# PID 
# ---------

# Below does not code republicans correct 
mturk_hk  <- mutate(mturk_hk , rd = as.numeric(derivedFactor(
                "Democrat" = ((pid == "Democrat") | (pid == "Independent" & pid_strength_1 >= 0 & pid_strength_1 < 5) | (pid == "Something else" & pid_strength_1 >= 0 & pid_strength_1 < 5)),
                "Republican" = ((pid == "Republican") | (pid == "Independent" & pid_strength_1 > 5 & pid_strength_1 < 11) | (pid == "Something else" & pid_strength_1 > 5 & pid_strength_1 < 11)),
                "Independent" = ((pid == "Independent" & pid_strength_1 == 5) | (pid == "Something else" & pid_strength_1 == 5)),
                .default = NA_character_)))

mturk_hk$democrat     <- recode(mturk_hk$rd, `1` = 1, .default = 0)
mturk_hk$republican   <- recode(mturk_hk$rd, `2` = 1, .default = 0)
mturk_hk$independent  <- recode(mturk_hk$rd, `3` = 1, .default = 0)

# Education 
# ------------

mturk_hk$somecollege <- recode(mturk_hk$educ, "Some college"  = 1, .default = 0)
mturk_hk$college     <- recode(mturk_hk$educ, "Four year college graduate" = 1, .default = 0)
mturk_hk$hs          <- recode(mturk_hk$educ, "No high school diploma" = 1, "High school diploma or equivalent" = 1, .default = 0)
mturk_hk$other       <- recode(mturk_hk$educ, "Other" = 1, .default = 0)
mturk_hk$postg       <- recode(mturk_hk$educ, "Post-graduate degree" = 1, .default = 0)

# Age 
# mturk_hk  based on 2017
# --------------------------

mturk_hk  <- mutate(mturk_hk , agegroup = as.character(derivedFactor(
                                "65+ years old" = (age < 1953),
                                "45-64 years old" = (age > 1952 & age < 1973),
                                "30-44 years old" = (age > 1972 & age < 1988),
                                "18-29 years old" = (age > 1987 & age < 2000),
                                .default = NA)))
      
mturk_hk$age18 <- recode(mturk_hk$agegroup, "18-29 years old"  = 1, .default = 0)
mturk_hk$age30 <- recode(mturk_hk$agegroup, "30-44 years old"  = 1, .default = 0)
mturk_hk$age45 <- recode(mturk_hk$agegroup, "45-64 years old"  = 1, .default = 0)
mturk_hk$age65 <- recode(mturk_hk$agegroup, "65+ years old"  = 1, .default = 0)

# Race
# -----------------
mturk_hk$ra <- recode(mturk_hk$race, "American Indian or Alaska Native" = "Other/Mixed" , "Asian" = "Asian", "Black or African American" = "Black",
                     "Black or African American,Other" = "Other/Mixed", "Native Hawaiian or Pacific Islander" = "Other/Mixed", "Other" = "Other/Mixed",
                     "White" = "White", "White,American Indian or Alaska Native" = "Other/Mixed", "White,Asian" = "Other/Mixed", "White,Other" = "Other/Mixed",
                     "White,Black or African American" = "Other/Mixed", "White,Black or African American,American Indian or Alaska Native" = "Other/Mixed", 
                     "White,Black or African American,American Indian or Alaska Native,Asian" = "Other/Mixed", "White,Native Hawaiian or Pacific Islander" = "Other/Mixed")

mturk_hk$asian     <- recode(mturk_hk$ra, "Asian" = 1, .default = 0)
mturk_hk$black     <- recode(mturk_hk$ra, "Black" = 1, .default = 0)
mturk_hk$other     <- recode(mturk_hk$ra, "Other/Mixed" = 1, .default = 0)  
mturk_hk$white     <- recode(mturk_hk$ra, "White" = 1, .default = 0)
mturk_hk$hisla     <- recode(mturk_hk$hisla, "Yes"  = 1, .default = 0)


write.csv(mturk_hk, "data/mturk_hk/mturk_hk_recoded.csv")
mturk_hk <- read.csv("data/mturk_hk/mturk_hk_recoded.csv")

