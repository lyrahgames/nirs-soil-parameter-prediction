# calculate the gram matrix of a given matrix
# gram.mat <- function(mat){
# 	#return
# 	t(mat) %*% mat
# }

# mlr.transf.obs.vec <- function(obs_vec, design_mat){

# }

# get matrix for calculating parameters
# mlr.par.mat = function(design_mat){
# 	transp_design_mat <- t(design_mat)

# 	# return
# 	solve(transp_design_mat %*% design_mat) %*% transp_design_mat
# }

# calculate parameters
# mlr.par = function(obs_vec, design_mat){
# 	# return
# 	as.vector(mlr.par.mat(design_mat) %*% obs_vec)
# }

# initialize observables and design matrix (needed for fast calculation)
init.data = function(obs_vec, design_mat){
	gv_obs_vec <<- obs_vec
	gv_design_mat <<- design_mat
	gv_sample_size <<- length(gv_obs_vec)
	gv_par_size <<- dim(gv_design_mat)[2]

	# preprocessing
	gv_gram_design_mat <<- t(gv_design_mat) %*% gv_design_mat
	gv_transf_obs_vec <<- t(gv_design_mat) %*% gv_obs_vec
}

# generate pseudo observables (needs init.data; first use another function to calculate global variables: gv_expect_vec, gv_sd)
# gen.pseudo.obs.vec = function(){
# 	# return
# 	rnorm(gv_sample_size, gv_expect_vec, gv_sd)
# }

# initialize global variables for given observables and design matrix (needed for fast calculation of multiple linear regression and model selection)
mlr.init = function(){
	# transp_design_mat <- t(design_mat)

	# global variables
	# gv_mlr_design_mat <<- design_mat
	# gv_mlr_par_size <<- dim(design_mat)[2]
	# gv_mlr_gram_design_mat <<- transp_design_mat %*% design_mat

	# gv_mlr_obs_vec <<- obs_vec
	# gv_mlr_sample_size <<- length(obs_vec)
	# gv_mlr_transf_obs_vec <<- transp_design_mat %*% obs_vec
	# gv_mlr_expect_vec <<- gv_design_mat %*% gv_mlr_par_vec

	gv_mlr_par_vec <<- solve(gv_gram_design_mat, gv_transf_obs_vec)
	res_vec <- gv_obs_vec - (gv_design_mat %*% gv_mlr_par_vec)
	gv_mlr_var <<- ( as.numeric( t(res_vec)%*%res_vec) ) / (gv_sample_size - gv_par_size)
	gv_mlr_inv_var <<- 1.0 / gv_mlr_var
	
	# gv_mlr_var <<- gv_mlr_rss  / (gv_mlr_sample_size - gv_mlr_par_size)
}

#
ms.init.dist = function(idx_vec){
	par_vec <- solve(gv_gram_design_mat[idx_vec,idx_vec], gv_transf_obs_vec[idx_vec])

	# global: model selection expectation vector
	gv_expect_vec <<- as.matrix(gv_design_mat[,idx_vec]) %*% par_vec

	res_vec <- gv_obs_vec - gv_expect_vec

	# global: model selection standard deviation 
	gv_sd <<- sqrt( as.numeric( t(res_vec) %*% res_vec ) / (gv_sample_size - length(idx_vec)) )
}

# initialize new observable with the same length (needs mlr.init)
# mlr.init.obs.vec = function(obs_vec){
# 	gv_mlr_obs_vec <<- obs_vec
# 	# gv_mlr_sample_size <<- length(obs_vec)
# 	gv_mlr_transf_obs_vec <<- t(gv_mlr_design_mat) %*% obs_vec
# 	gv_mlr_par_vec <<- solve(gv_mlr_gram_design_mat, gv_mlr_transf_obs_vec)
# 	gv_mlr_expect_vec <<- gv_mlr_design_mat %*% gv_mlr_par_vec
# 	gv_mlr_res_vec <<- obs_vec - gv_mlr_expect_vec
# 	gv_mlr_rss <<- as.numeric(t(gv_mlr_res_vec)%*%gv_mlr_res_vec)
# 	gv_mlr_var <<- gv_mlr_rss  / (gv_mlr_sample_size - gv_mlr_par_size)
# 	gv_mlr_inv_var <<- 1.0 / gv_mlr_var
# }

# mlr.init.design.mat = function(design_mat){

# }

# get hat-matrix of a given design-matrix
# design_mat must have full rank
# mlr.hat.mat = function(design_mat){
# 	# return
# 	design_mat %*% mlr.par.mat(design_mat)
# }

# multiple linear regression residual sum of squares (rss)
# mlr.rss = function(obs_vec, design_mat){
# 	hat_mat <- mlr.hat.mat(design_mat)
# 	res <- obs_vec - (hat_mat %*% obs_vec)

# 	# return
# 	as.numeric(t(res) %*% res)
# }

# multiple linear regression variance estimator
# mlr.var = function(obs_vec, design_mat){
# 	# return
# 	(mlr.rss(obs_vec, design_mat)) / (length(obs_vec) - dim(design_mat)[2])
# }

ms.par.vec = function(idx_vec){
	#return
	solve(gv_gram_design_mat[idx_vec,idx_vec], gv_transf_obs_vec[idx_vec])
}

ms.expect.vec = function(idx_vec){
	par_vec <- ms.par.vec(idx_vec)

	# return
	as.matrix(gv_design_mat[,idx_vec]) %*% par_vec
}

# get residual sum of squares for given model (needs mlr.init)
ms.rss = function(idx_vec){
	par_vec <- solve(gv_gram_design_mat[idx_vec,idx_vec], gv_transf_obs_vec[idx_vec])
	res_vec <- gv_obs_vec - ( as.matrix(gv_design_mat[,idx_vec]) %*% par_vec )

	# return
	as.numeric( t(res_vec) %*% res_vec )
}

ms.spse.est = function(idx_vec){
	# return
	ms.rss(idx_vec) + (2 * gv_mlr_var * length(idx_vec))
}

# get mallows cp for certain model
ms.cp = function(idx_vec){
	# return
	(ms.rss(idx_vec) * gv_mlr_inv_var) + (2*length(idx_vec)) - gv_sample_size
}

# model selection: forward selection method
# ms.fwd.sel = function(obs_vec, design_mat, invgv_mlr_var){
# 	full_idx_vec <- seq(1, dim(design_mat)[2])
# 	# first column will be used every time
# 	idx_vec <- 1
# 	cp <- mallows.cp(obs_vec, design_mat, idx_vec, invgv_mlr_var)

# 	repeat{
# 		# vector of selection
# 		sel_vec = setdiff(full_idx_vec, idx_vec)

# 		if (length(sel_vec) == 0){
# 			break
# 		}

# 		tmp_idx_vec_1 <- c(idx_vec, sel_vec[1])
# 		tmp_cp_1 <- mallows.cp(obs_vec, design_mat, tmp_idx_vec_1, invgv_mlr_var)

# 		for (i in 2:length(sel_vec)){
# 			tmp_idx_vec_2 <- c(idx_vec, sel_vec[i])
# 			tmp_cp_2 <- mallows.cp(obs_vec, design_mat, tmp_idx_vec_2, invgv_mlr_var)

# 			if (tmp_cp_2 <= tmp_cp_1){
# 				tmp_cp_1 <- tmp_cp_2
# 				tmp_idx_vec_1 <- tmp_idx_vec_2
# 			}
# 		}

# 		if (cp >= tmp_cp_1){
# 			cp <- tmp_cp_1
# 			idx_vec <- tmp_idx_vec_1
# 		}else{
# 			break
# 		}

# 		# debug information
# 		print(idx_vec)
# 		print(cp)
# 	}

# 	# return
# 	idx_vec
# }

# model selection: simulated annealing: neighbour function
ms.sa.nbr = function(idx_vec){
	# get random index (1 is not used)
	rand_idx <- sample(2:gv_par_size, size = 1)

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
ms.sa.prob <- function(old_cost, new_cost, temp){
	# return
	exp( (old_cost - new_cost) / temp )
}

# model selection: simulated annealing
ms.sa = function(idx_vec = c(1), temp = 100, alpha = 0.99, it_max = 10000, it_exit = 1200){
	old_cost <- ms.cp(idx_vec);
	it_same <- 0

	for (i in 1:it_max){
		nbr_idx_vec <- ms.sa.nbr(idx_vec);
		new_cost <- ms.cp(nbr_idx_vec)

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

		# debug
		# print(idx_vec)
		# print(old_cost)
		# print(temp)
	}

	# return
	idx_vec
}

#
ms.sim = function(expect_vec, var, sim_count = 10){
	sd <- sqrt(var)
	spse <- 0

	for (i in 1:sim_count){
		# generate and init pseudo observables
		gv_obs_vec <<- rnorm(gv_sample_size, expect_vec, sd)
		gv_transf_obs_vec <<- t(gv_design_mat) %*% gv_obs_vec
		mlr.init()

		# select model
		idx_vec <- ms.sa()
		tmp_spse <- ms.rss(idx_vec) + (2 * gv_mlr_var * length(idx_vec))

		# calculate spse
		spse <- spse + tmp_spse

		# debug
		print("sorted index vector:")
		print(sort(idx_vec))
		print("tmp spse:")
		print(tmp_spse)
		print("tmp mallows' cp:")
		print(ms.cp(idx_vec))
	}

	spse <- spse / sim_count

	# return
	spse
}