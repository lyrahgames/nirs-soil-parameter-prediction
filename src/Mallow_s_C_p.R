# Mallows Cp

cp.raw <- function(idx, X_par, Y_obs, inv_sigma_2) {
	
	D <- X[,idx]
	
	Y_hat <- D %*% solve(t(D) %*% D) %*% t(D) %*% Y_obs
	
	res <- (Y_obs - Y_hat)
	
	(t(res) %*% res) * inv_sigma_2 + 2 * length(idx)

}