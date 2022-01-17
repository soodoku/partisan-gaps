##--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~---++
##   											##
##      Misinformation/MisQs
##		Last Edited: 8.28.13   	
##   	Gaurav Sood	(with Joshua Blank)			##		
##--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~---++

# Set Working dir to C:/Users/Gaurav/Desktop/R/
	setwd(basedir)

# Sourcing Common Functions
	source("func/func.R")
	source("func/reg.R")
	
# Load data
	lyc <- foreign::read.dta("misinformation/misqs/data/Texas Lyceum 2012 Data.dta")
	names(lyc) <- tolower(names(lyc))

	# Random var
		lyc$rand <- NA
		lyc$rand[is.na(lyc$q45b) & is.na(lyc$q45c)] <- 1 # Neutral
		lyc$rand[is.na(lyc$q45a) & is.na(lyc$q45c)] <- 2 # Republican 
		lyc$rand[is.na(lyc$q45a) & is.na(lyc$q45b)] <- 3 # Obama

	# Recode to numeric
		from.vars <- paste0("q", gl(46,3), letters[1:3])[133:138]
		to.vars   <- paste0(from.vars, "r")
		
		lyc[,to.vars] <- sapply(lyc[,from.vars], function(x) car::recode(x, "'Gone up'=1; 'Gone down'=0; 'Stayed the same'=.5;else=NA"))
	
	# Combine all
		lyc$q45r <- NA
		lyc$q45r[is.na(lyc$q45b) & is.na(lyc$q45c)] <- lyc$q45ar[is.na(lyc$q45b) & is.na(lyc$q45c)]
		lyc$q45r[is.na(lyc$q45a) & is.na(lyc$q45c)] <- lyc$q45br[is.na(lyc$q45a) & is.na(lyc$q45c)] 
		lyc$q45r[is.na(lyc$q45a) & is.na(lyc$q45b)] <- lyc$q45cr[is.na(lyc$q45a) & is.na(lyc$q45b)]
		lyc$q45r <- as.numeric(lyc$q45r)

		lyc$q46r <- NA
		lyc$q46r[is.na(lyc$q46b) & is.na(lyc$q46c)] <- lyc$q46ar[is.na(lyc$q46b) & is.na(lyc$q46c)]
		lyc$q46r[is.na(lyc$q46a) & is.na(lyc$q46c)] <- lyc$q46br[is.na(lyc$q46a) & is.na(lyc$q46c)] 
		lyc$q46r[is.na(lyc$q46a) & is.na(lyc$q46b)] <- lyc$q46cr[is.na(lyc$q46a) & is.na(lyc$q46b)]
		lyc$q46r <- as.numeric(lyc$q46r)
		
	# PID
		lyc$pid3 <- car::recode(as.numeric(lyc$pid.1),"1:3='Democrat';5:7='Republican';else='Independent'",as.factor=T)
		lyc$pid3 <- factor(lyc$pid3, levels=c("Independent", "Democrat", "Republican"))
		
		lyc$pid2 <- car::recode(as.numeric(lyc$pid.1),"1:3='Democrat';5:7='Republican';else=NA",as.factor=T)
		
		lyc$pidfolded		 <- zero1(as.numeric(lyc$pid.1)-4)
		lyc$strongpartisan <- car::recode(as.numeric(lyc$pid.1),"1=1;7=1;else=0")
		
	# Main effect of Manipulation
		xtabs( ~ lyc$rand + lyc$q45r)
		xtabs( ~ lyc$rand + lyc$q46r)
		MASS::polr(as.factor(lyc$q45r) ~ lyc$rand)
		MASS::polr(as.factor(lyc$q46r) ~ lyc$rand)
	
	# Best understood via within party effect
		# Some convenient subsets
			lycr  <- lyc[as.numeric(lyc$pid.1) > 4,]
			lycd  <- lyc[as.numeric(lyc$pid.1) < 4,]
			lycrd <- lyc[as.numeric(lyc$pid.1) != 4,]
		
		# Logits (work as expected)
			summary(with(lyc[as.numeric(lyc$pid.1) > 4,], glm(q45r > .5 ~ as.factor(rand), family=binomial)))
			summary(with(lyc[as.numeric(lyc$pid.1) < 4,], glm(q45r > .5 ~ as.factor(rand), family=binomial)))
		
		# Ordered logits (work as expected)
		summary(MASS::polr(as.factor(lycr$q45r) ~ as.factor(lycr$rand)))
		summary(MASS::polr(as.factor(lycd$q45r) ~ as.factor(lycd$rand)))
		
		summary(MASS::polr(as.factor(lycr$q46r) ~ as.factor(lycr$rand)))
		summary(MASS::polr(as.factor(lycd$q46r) ~ as.factor(lycd$rand)))
		
		# Full interaction model
			summary(MASS::polr(as.factor(lyc$q45r) ~ as.factor(lyc$rand)*as.numeric(lyc$pid.1)))
			summary(MASS::polr(as.factor(lycrd$q45r) ~ as.factor(lycrd$rand)*as.numeric(lycrd$pid.1)))
			summary(MASS::polr(as.factor(lycrd$q46r) ~ as.factor(lycrd$rand)*as.numeric(lycrd$pid.1)))
		
			with(lyc[lyc$rand!=1,], summary(MASS::polr(as.factor(q45r) ~ as.factor(rand)*pid2)))
			with(lyc[lyc$rand!=1,], summary(MASS::polr(as.factor(a$q45r) ~ as.factor(a$rand)*a$pid2)))
			
			
		# GLM
			a <- with(lyc, glm(I(q45r==0) ~ as.factor(rand)*pid3, family="binomial"))
			b <- with(lyc, glm(I(q46r==0) ~ as.factor(rand)*pid3, family="binomial"))
			
			a <- with(lyc, glm(I(q45r==0) ~ as.factor(rand)*pid3, family="binomial"))
			b <- with(lyc, glm(I(q46r==0) ~ as.factor(rand)*pid3, family="binomial"))
			
			
			ng(a)
			ng(b)
			texreg::texreg(a)
			texreg::texreg(b)
			
			c <- cbind(round(summary(a)$coef[,c(1,4)],3), round(summary(b)$coef[,c(1,4)],3))
			
			write.csv(c, file="misinformation/c.csv")
			
			summary(with(lyc, glm(I(!is.na(q45r)) ~ as.factor(rand)*pid3, family="binomial")))
			summary(with(lyc, glm(I(!is.na(q45r)) ~ as.factor(rand)*pid2, family="binomial")))
			
		 	summary(MASS::polr(as.factor(lyc$q45r)   ~ as.factor(lyc$rand)*as.numeric(lyc$pid.1)))
			summary(MASS::polr(as.factor(lycrd$q45r) ~ as.factor(lycrd$rand)*as.numeric(lycrd$pid.1)))
			summary(MASS::polr(as.factor(lycrd$q46r) ~ as.factor(lycrd$rand)*as.numeric(lycrd$pid.1)))
		