measure_t1 <- proc.time()

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

# <<<<<<< HEAD
# # sim_count <- dim(pseudo_obs_mat)[2]
# sim_count <- 1000
# =======


# # choose predictor index
# step <- 2
# pred_idx_vec <- seq(1, dim(soc_design_mat)[2], by=step)
# init.data(soc_vec, soc_design_mat[,pred_idx_vec])
# mlr.init()



# sim_count <- dim(pseudo_obs_mat)[2]
# # sim_count <- 10
# >>>>>>> 17ce59bf0c20b060fb3ef0031a40a046732b0a3a

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
	# print("sorted index vector:")
	# print(sort(tmp_idx_vec))
# <<<<<<< HEAD
	# # print("tmp spse:")
	# # print(tmp_spse)
# =======
	# print("tmp spse:")
	# print(tmp_spse)
# >>>>>>> 17ce59bf0c20b060fb3ef0031a40a046732b0a3a
	# print("tmp mallows' cp:")
	# print(ms.cp(tmp_idx_vec))
	print("tmp time:")
	print(tmp_t2-tmp_t1)
	print("status:")
	print(i)
}

t2 <- proc.time()

print("spse arithmetic mean:")
print(sum(spse_vec) / sim_count)
print("spse variance:")
print(var(spse_vec))
print("time:")
print(t2-t1)

# <<<<<<< HEAD

# # code addendum to sketch the plot I'm envisioning
# # note that I introduced the variable 'gv_spse_soc', but didn't make it global,
# # so the gv is just for easy retrieval and removal

# spse_data <- data.frame(est_spse = spse_vec)
# spse_data <- cbind(run = c("533x319"), spse_data)
# qplot(data = spse_data, y = est_spse, x = run, geom = "violin") + geom_hline(yintercept = gv_spse_soc)

# proc.time() - measure_t1
# =======
# write.table(spse_vec, "../pro-files/data/gen/sim-soc-s2-spse-vec.csv", sep="\t", col.names=F, row.names=F)
# >>>>>>> 17ce59bf0c20b060fb3ef0031a40a046732b0a3a
