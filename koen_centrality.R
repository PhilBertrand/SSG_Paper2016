# This function calculates the average inverse edge weight, or Koen's centrality, 
# described in: Koen EL, Bowman J, Wilson PJ (2016) Node-based measures of connectivity 
# in genetic networks. Molecular Ecology Resources, 16, 69-79.
#
# Furthermore, the 'popgraph' package is necessary to process this function
# 
# @graph A popgraph object

koen_centrality <- function(graph) 
{
  if (!inherits(graph, "popgraph")) 
    stop(paste("This function requires a popgraph object to function. You passed a", 
               class(graph)))
  ret <- NULL
  
  sp <- 1/(popgraph::to_matrix(graph, mode = "shortest path"))
  diag(sp) = NA
  ret <- colMeans(sp, na.rm = TRUE)
  
  return(ret)
  
}