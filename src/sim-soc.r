# load source files
source("utils.r")
source("init.r")


pseudo_obs_mat <- as.matrix(read.csv("../pro-files/data/gen/pseudo-obs.csv", header=F, sep = "\t"))
idx_vec <- as.vector(read.csv("../pro-files/data/gen/ms-sa-soc-idx-vec.csv", header=F)[,1])

# # pseudo_obs_mat
# dim(pseudo_obs_mat)
# idx_vec
# length(idx_vec)

init.data(soc_vec, soc_design_mat)
mlr.init()


ms.init.dist(idx_vec)

# sim_count <- dim(pseudo_obs_mat)[2]
sim_count <- 10

spse_vec <- numeric()

t1 <- proc.time()

for (i in 1:sim_count){
	tmp_t1 <- proc.time()

	# generate and init pseudo observables
	gv_obs_vec <<- as.vector(pseudo_obs_mat[,i])
	gv_transf_obs_vec <<- t(gv_design_mat) %*% gv_obs_vec
	mlr.init()

	# select model and estimate spse
	tmp_idx_vec <- ms.sa()
	tmp_spse <- ms.rss(tmp_idx_vec) + (2 * gv_mlr_var * length(tmp_idx_vec))
	spse_vec <- c(spse_vec, tmp_spse)

	tmp_t2 <- proc.time()

	# debug
	print("sorted index vector:")
	print(sort(tmp_idx_vec))
	print("tmp spse:")
	print(tmp_spse)
	print("tmp mallows' cp:")
	print(ms.cp(tmp_idx_vec))
	print("tmp time:")
	print(tmp_t2-tmp_t1)
}

t2 <- proc.time()

print("spse arithmetic mean:")
print(sum(spse_vec) / sim_count)
print("spse variance:")
print(var(spse_vec))
print("time:")
print(t2-t1)