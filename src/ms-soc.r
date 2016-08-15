# load source files
source("utils.r")
source("init.r")


# design matrix
# soc_design_mat <- cbind(1, refl_mat)

# calculate mlr variance and inverse values
# mlr_var <- mlr.var(soc_vec, soc_design_mat)
# inv_mlr_var <- 1.0 / mlr_var

# use simulated annealing for model selection
# time_1 <- proc.time()
# sa_idx_vec <- ms.sa(soc_vec, soc_design_mat, inv_mlr_var)
# time_2 <- proc.time()
# sa_idx_vec <- sort(sa_idx_vec)
# sa_idx_cp <- mallows.cp(soc_vec, soc_design_mat, sa_idx_vec, inv_mlr_var)

# output
# sa_idx_vec
# sa_idx_cp
# length(sa_idx_vec)
# time_2-time_1

# write.csv(sa_idx_vec, "../pro-files/data/gen/ms-sa-soc-idx-vec.csv", col.names = FALSE, row.names = FALSE)

init.data(soc_vec, soc_design_mat)
mlr.init()

t1 <- proc.time()
idx_vec <- sort(ms.sa())
t2 <- proc.time()

print("index vector:")
idx_vec
print("mallows' cp:")
ms.cp(idx_vec)
print("estimated spse:")
ms.spse(idx_vec)
rint("time:")
t2-t1

ms.init.dist(idx_vec)

t1 <- proc.time()
sim_spse <- ms.sim(gv_expect_vec, gv_sd, sim_count=10)
t2 <- proc.time()

print("simulated spse:")
sim_spse
print("time:")
t2-t1
