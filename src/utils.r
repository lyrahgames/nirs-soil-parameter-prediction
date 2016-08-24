# initialize observables and design matrix (needed for fast calculation)
init.data = function(obs_vec, design_mat){
	# global, initialize
	gv_obs_vec <<- obs_vec
	gv_design_mat <<- design_mat
	gv_sample_size <<- length(gv_obs_vec)
	gv_par_size <<- dim(gv_design_mat)[2]

	# global, preprocessing
	gv_gram_design_mat <<- t(gv_design_mat) %*% gv_design_mat
	gv_transf_obs_vec <<- t(gv_design_mat) %*% gv_obs_vec
}

# precompute (estimate) parameter vector, variance and inverse variance of full model (needed for fast calculation)
mlr.init = function(){
	# global
	gv_mlr_par_vec <<- solve(gv_gram_design_mat, gv_transf_obs_vec)
	res_vec <- gv_obs_vec - (gv_design_mat %*% gv_mlr_par_vec)
	gv_mlr_var <<- ( as.numeric( t(res_vec)%*%res_vec) ) / (gv_sample_size - gv_par_size)
	gv_mlr_inv_var <<- 1.0 / gv_mlr_var
}

# initialize expectation vector and standard deviation for pseudo observations (as global variables: maybe faster)
ms.init.dist = function(idx_vec){
	par_vec <- solve(gv_gram_design_mat[idx_vec,idx_vec], gv_transf_obs_vec[idx_vec])

	# global: model selection expectation vector
	gv_expect_vec <<- as.matrix(gv_design_mat[,idx_vec]) %*% par_vec

	res_vec <- gv_obs_vec - gv_expect_vec

	# global: model selection standard deviation 
	gv_sd <<- sqrt( as.numeric( t(res_vec) %*% res_vec ) / (gv_sample_size - length(idx_vec)) )
}

# estimate parameter vector for a certain model given through index vector (needs init, mlr.init)
ms.par.vec = function(idx_vec){
	#return
	solve(gv_gram_design_mat[idx_vec,idx_vec], gv_transf_obs_vec[idx_vec])
}

# estimate expectation vector for a certain model (needs init, mlr.init)
ms.expect.vec = function(idx_vec){
	par_vec <- ms.par.vec(idx_vec)

	# return
	as.matrix(gv_design_mat[,idx_vec]) %*% par_vec
}

# get residual sum of squares for given model (needs init, mlr.init)
ms.rss = function(idx_vec){
	par_vec <- solve(gv_gram_design_mat[idx_vec,idx_vec], gv_transf_obs_vec[idx_vec])
	res_vec <- gv_obs_vec - ( as.matrix(gv_design_mat[,idx_vec]) %*% par_vec )

	# return
	as.numeric( t(res_vec) %*% res_vec )
}

# estimate spse for given model (needs init, mlr.init)
ms.spse.est = function(idx_vec){
	# return
	ms.rss(idx_vec) + (2 * gv_mlr_var * length(idx_vec))
}

# get mallows cp for certain model (needs init, mlr.init)
ms.cp = function(idx_vec){
	# return
	(ms.rss(idx_vec) * gv_mlr_inv_var) + (2*length(idx_vec)) - gv_sample_size
}

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

# old variant
# ms.sim = function(expect_vec, var, sim_count = 10){
# 	sd <- sqrt(var)
# 	spse <- 0

# 	for (i in 1:sim_count){
# 		# generate and init pseudo observables
# 		gv_obs_vec <<- rnorm(gv_sample_size, expect_vec, sd)
# 		gv_transf_obs_vec <<- t(gv_design_mat) %*% gv_obs_vec
# 		mlr.init()

# 		# select model
# 		idx_vec <- ms.sa()
# 		tmp_spse <- ms.rss(idx_vec) + (2 * gv_mlr_var * length(idx_vec))

# 		# calculate spse
# 		spse <- spse + tmp_spse

# 		# debug
# 		print("sorted index vector:")
# 		print(sort(idx_vec))
# 		print("tmp spse:")
# 		print(tmp_spse)
# 		print("tmp mallows' cp:")
# 		print(ms.cp(idx_vec))
# 	}

# 	spse <- spse / sim_count

# 	# return
# 	spse
# }