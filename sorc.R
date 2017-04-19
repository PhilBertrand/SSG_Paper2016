# This function calculates the second order rate of change from a list
# 
# @x A list

sorc <- function(x){

  if (!inherits(x, "list")) 
    stop(paste("This function requires a list. You passed a", class(x)))
  
C <- rep(NA, length(x))
Ci <- rep(NA, length(x)-1)
val <- NULL

for(j in 1:length(x[[1]])){
  X <- sapply(x, "[", j)
  for (i in 2:length(X)){
    C[i] <- X[i] - X[i - 1]
  }
  for (i in 2:length(X)-1){
    Ci[i] <- abs(C[i + 1] - C[i])
  }
  val[[j]] <- c(Ci)
 }

return(val)

}