#   
#  Table 9: Reasons for Correct Responses
#

# Set Working dir 
setwd(basedir) 
setwd("hidden") 

# Load libaries
 
# Read in recoded data 
source("scripts/04_mturk_recode.R")

# 4. Blind Guessing, Cheating, Inference, Expressive Responding
# Exploiting the 'inference battery'
# Inference Battery ! = Inference Battery. It captures inference and other things like 'cheating', etc. 
# Columns: 
# a. Proportion correct, 
# b. cheating = proportion correct and choosing (I asked another person, I looked it up), 
# c. guessing = proportion correct and choosing I took a shot,
# d. inference = correct and infer, 
# e. expressive = correct and feel good
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# no gg2 as we screwed up
stems_inf       <- c("oc", "bc", "aca2c", "dtc")

# Proportion Correct 
inf_pc 			<- sapply(mturk[mturk$probe=='closed',  paste0(stems_inf, "_pc")], function(x) mean(x))
inf_pc_se   	<- sapply(inf_pc, function(x) se_prop(x, nrow(mturk[mturk$probe=='closed',])))

# Actual Knowledge
inf_ak 			<- sapply(mturk[mturk$probe=='closed', paste0(stems_inf, "_ak")], function(x) mean(x))
inf_ak_se   	<- sapply(inf_ak, function(x) se_prop(x, nrow(mturk[mturk$probe=='closed',])))

# Cheating
inf_ch      	<- sapply(mturk[mturk$probe=='closed', paste0(stems_inf, "_ch")], function(x) mean(x))
inf_ch_se		<- sapply(inf_ch, function(x) se_prop(x, nrow(mturk[mturk$probe=='closed',])))

# Guessing
inf_gu       	<- sapply(mturk[mturk$probe=='closed', paste0(stems_inf, "_gu")], function(x) mean(x))
inf_gu_se    	<- sapply(inf_gu, function(x) se_prop(x, nrow(mturk[mturk$probe=='closed',])))

# Inference
inf_in      	<- sapply(mturk[mturk$probe=='closed', paste0(stems_inf, "_in")], function(x) mean(x))
inf_in_se    	<- sapply(inf_in, function(x) se_prop(x, nrow(mturk[mturk$probe=='closed',])))

# Expressive			 
inf_ex     		<- sapply(mturk[mturk$probe=='closed', paste0(stems_inf, "_ex")], function(x) mean(x))
inf_ex_se    	<- sapply(inf_ex, function(x) se_prop(x, nrow(mturk[mturk$probe=='closed',])))	

inference 		<- data.frame(inf_pc, inf_pc_se, inf_ak, inf_ak_se, inf_ch, inf_ch_se, inf_gu, inf_gu_se, inf_in, inf_in_se, inf_ex, inf_ex_se)		 

# Generate csv
write.csv(inference, file = "res/tab8_mturk_inference.csv", row.names = F)
