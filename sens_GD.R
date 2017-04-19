# This function aims to evaluate the sensitivity of genetic diversity estimate based on a 
# random increment of individuals
# 
# For meaningfull comparison among scenarios, one should choose a minimum number of individuals
# that is comparable within all compared groups. This function is standardizing the number of
# individuals in each scenario, but not the number of groups. 
#
# Furthermore, the 'gstudio' package is necessary to process this function
# @x The data.frame with locus columns formatted as a 'gstudio' object
# @column Character object characterizing your groups, e.g. "Population", "SiteID", etc.
# @nTresh The maximum number of individuals to add. If nothing is supplied, then the minimum number
# of individuals across sites will be taken.
# @nRep The number of replicates. Default is 99.

sens_GD <- function(x, column, nTresh = NULL, nRep = 99) {

  if (missing(x))
    stop("You must use a data.frame with locus columns formatted via 'gstudio' to pass data to this function")
  if (missing(column))
    stop("You need to specify which 'groups' need to be evaluated e.g. population?")
  if (!is.character(column))
    stop("You need to specify the name of the appropriate column (i.e. 'character') where your groups ID are indicated")
    if (missing(nTresh)) 
    nTresh <- min(table(x[[column]]))
  
groups <- factor(as.character(x[[column]]))
w <- rep(NA, length(levels(groups)))
s <- rep(NA, nRep)
SMs <- rep(NA, nTresh)
SSs <- rep(NA, nTresh)

##Loop estimating variability##
for (k in 1:nTresh){
  for (j in 1:nRep){
    
    dum <- x 
    
    t <- as.data.frame(unique(groups))
    t[, 2] <- 1:length(unique(groups))
    colnames(t) <- c(column, "Order")
    dum <- merge(t, dum, by.y = column)
    t <- as.data.frame(dum[1:4])
    
    for (i in 1:length(unique(dum$Order))) {                    ##Loop assigning random number to each individual
      u <- t[(t$Order == i), ]
      v <- round(sample(length(u$Order), replace = FALSE))
      u[, 5] <- c(v)
      colnames(u) <- c(column, "Order", "Sex", "ID", "Random")
      w[i] <- list(u)
    }
    
    random.df <- data.frame()
    for (i in 1:length(w)) {
      n.rows <- sapply(w, nrow)
      if (length(w[[i]])>1) {
        temp.df <- cbind(w[[i]], rep(i, n.rows[i]))
        names(temp.df) <- c(column, "Order", "Sex", "Sample", "Random")
        random.df <- rbind(random.df, temp.df)
      }
    }
    
    rm <- random.df[, -c(1, 2, 3, 6)]
    dum <- merge(rm, dum, by.y = "Sample")
    n <- dum[!(dum$Random > k), ]                             ##Removing individuals according to scenario k
    
    d <- data.frame(table(n[[column]]))
    names(d) <- c(column, "Freq")
    n <- merge(d, n, by.y = column)
    N <- n[! (n$Freq < k), ]                                  ##Standardized to a minimum number of individuals per sites
    N[[column]] <- factor(N[[column]])
    
    GD <- rep(NA, length(unique(N$Order)))
    for (i in 1:length(unique(N$Order))) {
      U <- N[(N$Order == i), ]
      bgd <- genetic_diversity(U, mode="Ae")$Ae               ##Estimating genetic diversity
      bgd[!is.finite(bgd)] <- NA
      gd <- mean(bgd, na.rm = TRUE)
      GD[i] <- gd
    }
    
    s[j] <- list(GD) 
    
  }
  
  Ms <- rep(NA, length(s[[1]]))
  Ss <- rep(NA, length(s[[1]]))
  
  for(i in 1:length(s[[1]])){
    Ms[i] <- mean(sapply(s, "[", i), na.rm = TRUE)            ##Averaging across replicates
    Ss[i] <- sd(sapply(s, "[", i), na.rm = TRUE)              ##Standard deviation across replicates
  }
  
  SMs[k] <- list(Ms)
  SSs[k] <- list(Ss)
  
}

results <- list("SMs" = SMs, "SSs" = SSs)
return(results)

}