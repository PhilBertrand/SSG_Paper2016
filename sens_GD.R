sens_GD <- function (x, groups, nTresh = NULL, nRep = 99) {

  if (missing(x)) 
    stop("You must use a data.frame with locus columns formatted via 'gstudio' to pass data to this function")
  if (missing(groups)) 
    stop("You need to specify which 'groups' need to be evaluated e.g. population?")
  
groups <- factor(as.character(groups))
w <- rep(NA, length(levels(groups)))
s <- rep(NA, nRep)
SMs <- rep(NA, nTresh)
SSs <- rep(NA, nTresh)

##Loop estimating variability##
for (k in 1:nTresh){
  for (j in 1:nRep){
    
    dum <- x 
    
    t <- as.data.frame(unique(dum[1]))
    t[, 2] <- 1:length(unique(dum$Population))
    colnames(t) <- c("Population", "Order")
    dum <- merge(t, dum, by.y = "Population")
    t <- as.data.frame(dum[1:4])
    
    for (i in 1:length(unique(dum$Order))) {                    ##Loop assigning random number to each individual
      u <- t[(t$Order == i), ]
      v <- round(sample(length(u$Order), replace = FALSE))
      u[, 5] <- c(v)
      colnames(u) <- c("Population", "Order", "Sex", "ID", "Random")
      w[i] <- list(u)
    }
    
    random.df <- data.frame()
    for (i in 1:length(w)) {
      n.rows <- sapply(w, nrow)
      if (length(w[[i]])>1) {
        temp.df <- cbind(w[[i]], rep(i, n.rows[i]))
        names(temp.df) <- c("Population", "Order", "Sex", "Sample", "Random")
        random.df <- rbind(random.df, temp.df)
      }
    }
    
    rm <- random.df[, -c(1, 2, 3, 6)]
    dum <- merge(rm, dum, by.y = "Sample")
    n <- dum[!(dum$Random > k), ]                             ##Removing individuals according to scenario k
    
    d <- data.frame(table(n$Population))
    names(d) <- c("Population", "Freq")
    n <- merge(d, n, by.y = "Population")
    N <- n[! (n$Freq < k), ]                                  ##Standardized to a minimum number of individuals per pops
    N$Population <- factor(N$Population)
    
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