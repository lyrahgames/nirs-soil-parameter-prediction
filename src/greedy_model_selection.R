# greedy search

# initialise with 1
# add first column w/ 1

idx <- 1

res_full <- Y - (X %*% solve(t(X) %*% X) %*% t(X) %*% Y)

inv_sigma_2 <- (length(Y) - dim(X)[2])/(t(res_full) %*% res_full)


cp_idx <- cp.raw(idx = idx, X_par = X, Y_obs = Y, inv_sigma_2 = inv_sigma_2)
complete_idx <- 1:dim(X)[2]

repeat {
	
	search_vec <- setdiff(complete_idx,idx)
	
	if (length(search_vec) == 0) {break}
	
	print(idx_tmp <- c(idx, search_vec[1]))
	print(cp_tmp <- cp.raw(idx = idx_tmp, X_par = X, Y_obs = Y, inv_sigma_2 = inv_sigma_2))
	
	for (i in 2:length(search_vec)) {
		
		tmp_idx_tmp <- c(idx, search_vec[i])
		print(tmp_cp_tmp <- cp.raw(idx = tmp_idx_tmp, X_par = X, Y_obs = Y, inv_sigma_2 = inv_sigma_2))
		
		print(tmp_idx_tmp)
		
		if (tmp_cp_tmp < cp_tmp) {
			
			cp_tmp <- tmp_cp_tmp
			idx_tmp <- tmp_idx_tmp
			
		}
	}
	
	print(idx_tmp)
	
	if (cp_tmp >= cp_idx) {break}
	else {
		cp_idx <- cp_tmp
		idx <- idx_tmp
	}
}