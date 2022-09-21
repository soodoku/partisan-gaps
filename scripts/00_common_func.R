#
# Common Functions for Measure PK paper
#

# Some accidentally use of a scale of 0 to 100 than 0 to 10
# Anybody with more than 1000 to be NA 
# Convert everything to 0 to 1
# Assume 0 to 10 

conf_10 <- function(x) {
 
   x_num  <- nona(as_num(x))
   x_10   <- ifelse(x_num > 10, x_num/10, x_num)
   x_100  <- ifelse(x_10 > 10, x_10/10, x_10)
   x_100  <- ifelse(x_100 > 10, NA, x_100)

   zero1(x_100, 0, 10)

}

# Most confident about the correct ans.
# c1 must carry correct ans. 

most_conf <- function(c1, c2, c3, c4) {

	#test: c1 <- arep$rg.rg;c2 <- arep$rg.ad;c3 <- arep$rg.jc;c4 <- arep$rg.ak
	
	temp <- cbind(c1, c2, c3, c4)

	#if (any (is.na(temp))) stop("There are still NAs.")
	#if (any (temp > 10, na.rm=T))   stop("There are still numbers over 10")

	# Get max. of each row 
	max_num <- apply(temp, 1, function(x) max(x))

	# Total max. per row 
	n_max   <- rowSums(temp == max_num)

	# If max. is unique 
	# If max. is for the right answer 
	ifelse(n_max == 1, c1 == max_num, 0)

}

# Function that corrects for guessing
stnd_cor_sum <- function(variable, n_options){
    guess <- sum(variable == 0, na.rm = TRUE)/(n_options - 1)
    adjusted <- sum(variable == 1, na.rm = TRUE) - guess
    adjusted
}