# get hat-matrix of a given design-matrix
# design_mat must have full rank
hat.mat = function(design_mat){
	transp_design_mat <- t(design_mat)

	# return
	design_mat %*% solve(transp_design_mat %*% design_mat) %*% transp_design_mat
}


# multiple linear regression variance estimator
mlr.var = function(obs, design_mat){
	hat_mat <- hat.mat(design_mat)
	res <- obs - (hat_mat %*% obs)

	# return
	(t(res) %*% res) / (length(obs) - dim(design_mat)[2])
}

# mallows cp for 