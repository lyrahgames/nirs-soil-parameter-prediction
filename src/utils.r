# get hat-matrix of a given design-matrix
# design_mat must have full rank
hat.mat = function(design_mat){
	transp_design_mat <- t(design_mat)

	# return
	design_mat %*% solve(transp_design_mat %*% design_mat) %*% transp_design_mat
}

# multiple linear regression residual sum of squares (rss)
mlr.rss = function(obs, design_mat){
	hat_mat <- hat.mat(design_mat)
	res <- obs - (hat_mat %*% obs)

	# return
	t(res) %*% res
}

# multiple linear regression variance estimator
mlr.var = function(obs, design_mat){
	# return
	(mlr.rss(obs, design_mat)) / (length(obs) - dim(design_mat)[2])
}

# mallows cp
# idx_vec describes given model
# inv_mlr_var is the inverse variance of the given full model
mallows.cp = function(obs, design_mat, idx_vec, inv_mlr_var){
	# construct design matrix of given model
	design_mat_mod <- design_mat[,idx_vec]

	# return (will be returned as matrix; do not know why)
	(mlr.rss(obs, design_mat_mod) * inv_mlr_var) + (2*length(idx_vec)) - length(obs)
}

# model selection: forward selection method
ms.fwd.sel = function(obs, design_mat, inv_mlr_var){
	full_idx_vec <- seq(1, dim(design_mat)[2])
	# first column will be used every time
	idx_vec <- 1
	cp <- mallows.cp(obs, design_mat, idx_vec, inv_mlr_var)

	repeat{
		# vector of selection
		sel_vec = setdiff(full_idx_vec, idx_vec)

		if (length(sel_vec) == 0){
			break
		}

		tmp_idx_vec_1 <- c(idx_vec, sel_vec[1])
		tmp_cp_1 <- mallows.cp(obs, design_mat, tmp_idx_vec_1, inv_mlr_var)

		for (i in 2:length(sel_vec)){
			tmp_idx_vec_2 <- c(idx_vec, sel_vec[i])
			tmp_cp_2 <- mallows.cp(obs, design_mat, tmp_idx_vec_2, inv_mlr_var)

			if (tmp_cp_2 <= tmp_cp_1){
				tmp_cp_1 <- tmp_cp_2
				tmp_idx_vec_1 <- tmp_idx_vec_2
			}
		}

		if (cp >= tmp_cp_1){
			cp <- tmp_cp_1
			idx_vec <- tmp_idx_vec_1
		}else{
			break
		}

		# debug information
		print(idx_vec)
		print(cp)
	}

	# return
	idx_vec
}

# model selection: simulated annealing: neighbour function
ms.sa.nbr = function(idx_vec, max_idx){
	# get random index (1 is not used)
	rand_idx <- sample(2:max_idx, size = 1)

	if (rand_idx %in% idx_vec){
		# delete rand_idx in idx_vec
		nbr_idx_vec <- idx_vec[idx_vec != rand_idx]
	}else{
		# add rand_idx to idx_vec
		nbr_idx_vec <- c(idx_vec, rand_idx)
	}

	# return
	nbr_idx_vec
}

# model selection: simulated annealing: probability function
# costs will be minimized 
ms.sa.prob = function(old_cost, new_cost, temp){
	# return
	exp( (old_cost - new_cost) / temp )
}

# model selection: simulated annealing
ms.sa = function(obs, design_mat, inv_mlr_var, idx_vec = c(1), temp = 100, alpha = 0.99, it_max = 10000, it_exit = 1200){
	max_idx <- dim(design_mat)[2]
	old_cost <- mallows.cp(obs, design_mat, idx_vec, inv_mlr_var);
	it_same <- 0

	for (i in 1:it_max){
		nbr_idx_vec <- ms.sa.nbr(idx_vec, max_idx);
		new_cost <- mallows.cp(obs, design_mat, nbr_idx_vec, inv_mlr_var)

		if ( ms.sa.prob(old_cost, new_cost, temp) >= runif(1) ){
			idx_vec <- nbr_idx_vec
			old_cost <- new_cost
			it_same <- 0
		}else{
			it_same <- it_same + 1
			if (it_same >= it_exit){
				break
			}
		}

		temp <- alpha * temp

		# debug information
		print(idx_vec)
		print(old_cost)
	}

	# return
	idx_vec
}