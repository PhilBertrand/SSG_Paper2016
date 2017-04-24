# This function aims to evaluate estimate sensitity based on a random removal of nodes
# 
# One would need the 'gstudio' and 'popgraph' packages to process this function
# @x The data.frame with locus columns formatted as a 'gstudio' object
# @column Character name characterizing your groups, e.g. Population, sampling sites, etc.
# @nTresh The maximum number of population to removed. NA could result from specific scenario if
# variability is too low from network data, corresponding to network collapse. If nothing is specified, nTresh
# is set to max(length(levels(groups)))-3, since it commonly ends up with no result.
# @nRep The number of replicates. Default is set to 99.

sens_topology <- function(x, column, nTresh = NULL, nRep = 99) {

  if (missing(x)) 
    stop("You must use a data.frame with locus columns formatted via 'gstudio' to pass data to this function")
  if (missing(column)) 
    stop("You need to specify which 'groups' need to be evaluated e.g. population?")
  if (!is.character(column))
    stop("You need to specify the name of the appropriate column (i.e. 'character') where your groups ID are indicated")
  
  groups <- factor(as.character(x[[column]]))
  
  if (missing(nTresh)) 
    nTresh <- (length(levels(groups))-3)
  
  Ce <- rep(NA, nRep)
  e <- rep(NA, nTresh)

##Loop estimating variability in topology
for (k in 1:nTresh){
  for (j in 1:nRep){
    
    dum <- x
    
    t <- as.data.frame(unique(groups))
    t[, 2] <- round(sample(length(unique(dum[[column]])), replace = FALSE))
    t[, 3] <- 1:length(unique(groups))
    colnames(t) <- c(column, "RandomPop", "Order")
    dum <- merge(t, dum, by.y = column)
    
    n <- dum[!(dum$RandomPop <= k), ]
    
    ##Creating popgraph##
    mv <- to_mv(n)
    pops <- n[[column]]
    graph <- popgraph( x = mv, groups = pops)
    
    ##Estimating eigenvector centrality via igraph package
    Ce[j] <- centralization.evcent(graph, directed = FALSE, scale = FALSE,
              options = igraph.arpack.default, normalized = TRUE)$centralization
    
  }
  
  e[k] <- list(Ce)

}

return(e)

}