sens_topology <- function (x, groups, nTresh = NULL, nRep = 99) {

  if (missing(x)) 
    stop("You must use a data.frame with locus columns formatted via 'gstudio' to pass data to this function")
  if (missing(groups)) 
    stop("You need to specify which 'groups' need to be evaluated e.g. population?")
  
  groups <- factor(as.character(groups))
  if (missing(nTresh)) 
    nTresh <- (length(levels(groups))-3)
  
  Ce <- rep(NA, nRep)
  e <- rep(NA, nTresh)

##Loop estimating variability in topology
for (k in 1:nTresh){
  for (j in 1:nRep){
    
    dum <- x
    
    t <- as.data.frame(unique(dum[1]))
    t[, 2] <- round(sample(length(unique(dum$Population)), replace = FALSE))
    t[, 3] <- 1:length(unique(dum$Population))
    colnames(t) <- c("Population", "RandomPop", "Order")
    dum <- merge(t, dum, by.y = "Population")
    
    n <- dum[!(dum$RandomPop <= k), ]
    
    ##Creating popgraph##
    mv <- to_mv(n)
    pops <- n$Population
    graph <- popgraph( x = mv, groups = pops)
    
    ##Estimating eigenvector centrality via igraph package
    Ce[j] <- centralization.evcent(graph, directed = FALSE, scale = FALSE,
              options = igraph.arpack.default, normalized = TRUE)$centralization
    
  }
  
  e[k] <- list(Ce)

}

return(e)

}