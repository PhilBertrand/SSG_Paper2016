koen_centrality <- function (graph) 
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