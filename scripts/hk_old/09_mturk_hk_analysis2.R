#   
#  Table 7: MC Vs. Prob.
#

# Set Working dir 
setwd(basedir)   # Gaurav's path
setwd("partisan-gaps")  # folder

setwd(githubdir) # Daniel's path
setwd("partisan-gaps")  # folder


# Load libaries
library(plyr)
library(broom)
library(lme4)
library(lmerTest) #masks lmer; Satterthwaite approximation


# Source Recode Files
source("scripts/07_mturk_hk_recode.R")

## MTurk
## ----------
# no gg2 as we screwed up 

# Convenient subsets
mturk_hk_clsd  <- subset(mturk_hk, rg_test == 'closed')
mturk_hk_scale <- subset(mturk_hk, rg_test == 'scale')

# Var. names
stems_1      <- c("aca", "aca2", "gg", "dt") 
stems_2a     <- c("ftc_am", "ftc_mmc", "fvc_am", "fvc_mmc")
stems_2b     <- c("fts_am", "fts_mmc", "fvs_am", "fvs_mmc")

# Labels
labs        <- c("ACA", "ACA2", "Global Warming", "Immigration Order", "Merkel, Text", "McConnell, Text", "Merkel, Photo",
                 "McConnell, Photo", "Avg.")

clsd_1      <- sapply(mturk_hk_clsd[, stems_1], function(x) mean(x))
clsd_2      <- sapply(mturk_hk[, paste0(stems_2a, "_c")], function(x) mean(x))
closed      <- c(clsd_1, clsd_2)

mean_10_1   <- sapply(mturk_hk_scale[, paste0(stems_1, "_10")], function(x) mean(x))
mean_10_2   <- sapply(mturk_hk[, paste0(stems_2b, "_10")], function(x) mean(x))

# Guessing corrected
mturk_hk_aca_gc  <- with(mturk_hk_clsd, stnd_cor_sum(rgc_o_aca[!str_detect(rgc_o_aca, "know") & rgc_o_aca != ""] == "Increase the Medicare payroll tax for upper-income Americans", 4) + stnd_cor_sum(rgc_c_aca[!str_detect(rgc_c_aca, "know") & rgc_c_aca != ""] == "Increase the Medicare payroll tax for upper-income Americans", 4))

mturk_hk_aca2_gc <- with(mturk_hk_clsd, stnd_cor_sum(rgc_o_aca2[!str_detect(rgc_o_aca2, "know") & rgc_o_aca2 != ""] == "Limit future increases in payments to Medicare providers", 4) + stnd_cor_sum(rgc_c_aca2[!str_detect(rgc_c_aca2, "know") & rgc_c_aca2 != ""] == "Limit future increases in payments to Medicare providers", 4))

mturk_hk_gg_gc   <- with(mturk_hk_clsd, stnd_cor_sum(rgc_o_gg[!str_detect(rgc_o_gg, "know") & rgc_o_gg != ""] == "A cause of rising sea levels", 4) + stnd_cor_sum(rgc_c_gg[!str_detect(rgc_c_gg, "know") & rgc_c_gg != ""] == "A cause of rising sea levels", 4))

mturk_hk_dt_gc   <- with(mturk_hk_clsd, stnd_cor_sum(rgc_o_dt[!str_detect(rgc_o_dt, "know") & rgc_o_dt != ""] == "Temporarily ban immigrants from several majority-Muslim countries", 4) + stnd_cor_sum(rgc_c_dt[!str_detect(rgc_c_dt, "know") & rgc_c_aca != ""] == "Temporarily ban immigrants from several majority-Muslim countries", 4))

mturk_hk_gc_1     <- c(mturk_hk_aca_gc, mturk_hk_aca2_gc, mturk_hk_gg_gc, mturk_hk_dt_gc)/nrow(mturk_hk_clsd)

mturk_hk_tam_gc   <- with(mturk_hk, stnd_cor_sum(ftc_am[!str_detect(ftc_am, "know") & ftc_am != ""] == "Chancellor of Germany", 4))
mturk_hk_tmm_gc   <- with(mturk_hk, stnd_cor_sum(ftc_mmc[!str_detect(ftc_mmc, "know") & ftc_mmc != ""] == "U.S. Senate Majority Leader", 4))
mturk_hk_vam_gc   <- with(mturk_hk, stnd_cor_sum(fvc_am[!str_detect(fvc_am, "know") & fvc_am != ""] == "Chancellor of Germany", 4))
mturk_hk_vmm_gc   <- with(mturk_hk, stnd_cor_sum(fvc_mmc[!str_detect(fvc_mmc, "know") & fvc_mmc != ""] == "U.S. Senate Majority Leader", 4))

mturk_hk_gc_2     <- c(mturk_hk_tam_gc, mturk_hk_tmm_gc, mturk_hk_vam_gc, mturk_hk_vmm_gc)/nrow(mturk_hk)
mturk_hk_gc       <- c(mturk_hk_gc_1, mturk_hk_gc_2)

# Prop.test
# With correct
aca_p  <- tidy(prop.test(c(sum(mturk_hk_clsd$aca),  sum(mturk_hk_scale$aca_10)), n = c(nrow(mturk_hk_clsd), nrow(mturk_hk_scale))))$p.value
aca2_p <- tidy(prop.test(c(sum(mturk_hk_clsd$aca2), sum(mturk_hk_scale$aca2_10)), n = c(nrow(mturk_hk_clsd), nrow(mturk_hk_scale))))$p.value
gg_p   <- tidy(prop.test(c(sum(mturk_hk_clsd$gg),   sum(mturk_hk_scale$gg_10)), n = c(nrow(mturk_hk_clsd), nrow(mturk_hk_scale))))$p.value
dt_p   <- tidy(prop.test(c(sum(mturk_hk_clsd$dt),   sum(mturk_hk_scale$dt_10)), n = c(nrow(mturk_hk_clsd), nrow(mturk_hk_scale))))$p.value
amt_p  <- tidy(prop.test(c(sum(mturk_hk$ftc_am_c),  sum(mturk_hk$fts_am_10)), n = rep(nrow(mturk_hk), 2)))$p.value
mmt_p  <- tidy(prop.test(c(sum(mturk_hk$ftc_mmc_c), sum(mturk_hk$fts_mmc_10)), n = rep(nrow(mturk_hk), 2)))$p.value
amv_p  <- tidy(prop.test(c(sum(mturk_hk$fvc_am_c),  sum(mturk_hk$fvs_am_10)), n = rep(nrow(mturk_hk), 2)))$p.value
mmv_p  <- tidy(prop.test(c(sum(mturk_hk$fvc_mmc_c), sum(mturk_hk$fvs_mmc_10)), n = rep(nrow(mturk_hk), 2)))$p.value

peas_1 <- c(aca_p, aca2_p, gg_p, dt_p, amt_p, mmt_p, amv_p, mmv_p)

# With Guessing corrected
aca_p  <- tidy(prop.test(c(mturk_hk_aca_gc,  sum(mturk_hk_scale$aca_10)), n = c(nrow(mturk_hk_clsd), nrow(mturk_hk_scale))))$p.value
aca2_p <- tidy(prop.test(c(mturk_hk_aca2_gc, sum(mturk_hk_scale$aca2_10)), n = c(nrow(mturk_hk_clsd), nrow(mturk_hk_scale))))$p.value
gg_p   <- tidy(prop.test(c(mturk_hk_gg_gc,   sum(mturk_hk_scale$gg_10)), n = c(nrow(mturk_hk_clsd), nrow(mturk_hk_scale))))$p.value
dt_p   <- tidy(prop.test(c(mturk_hk_dt_gc ,  sum(mturk_hk_scale$dt_10)), n = c(nrow(mturk_hk_clsd), nrow(mturk_hk_scale))))$p.value
amt_p  <- tidy(prop.test(c(mturk_hk_tam_gc,  sum(mturk_hk$fts_am_10)), n = rep(nrow(mturk_hk), 2)))$p.value
mmt_p  <- tidy(prop.test(c(mturk_hk_tmm_gc,  sum(mturk_hk$fts_mmc_10)), n = rep(nrow(mturk_hk), 2)))$p.value
amv_p  <- tidy(prop.test(c(mturk_hk_vam_gc,  sum(mturk_hk$fvs_am_10)), n = rep(nrow(mturk_hk), 2)))$p.value
mmv_p  <- tidy(prop.test(c(mturk_hk_vmm_gc,  sum(mturk_hk$fvs_mmc_10)), n = rep(nrow(mturk_hk), 2)))$p.value

peas_2   <- c(aca_p, aca2_p, gg_p, dt_p, amt_p, mmt_p, amv_p, mmv_p)

# Combine
res_conf_clsd <- data.frame(closed, mean_10_1, gc = mturk_hk_gc, p_c_10 = peas_1, p_gc_10 = peas_2)

# Diff. cols
res_conf_clsd$diff_c_10   <-  res_conf_clsd$closed - res_conf_clsd$mean_10
res_conf_clsd$diff_gc_10  <-  res_conf_clsd$gc - res_conf_clsd$mean_10

## Averages
res_conf_clsd[nrow(res_conf_clsd) + 1, ]  <- colMeans(res_conf_clsd)

# Labels
res_conf_clsd$labs <- labs

# Write out to CSV 
write.csv(res_conf_clsd, file = "res/tab7_mturk_hk_conf_mc.csv", row.names = F)

nrow(mturk_hk)
