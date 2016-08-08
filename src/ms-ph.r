# load source files
source("utils.r")
source("init.r")


# design matrix
design_mat <- cbind(1, log(refl_mat))

# calculate mlr variance and inverse values
mlr_var <- mlr.var(ph_vec, design_mat)
inv_mlr_var <- 1.0 / mlr_var

# use simulated annealing for model selection
# sa_idx_vec <- ms.sa(ph_vec, design_mat, inv_mlr_var, alpha = 0.9999, it_max = 100000, temp = 10, it_exit = 100000)
sa_idx_vec <- ms.sa(ph_vec, design_mat, inv_mlr_var)
sa_idx_vec <- sort(sa_idx_vec)
sa_idx_cp <- mallows.cp(ph_vec, design_mat, sa_idx_vec, inv_mlr_var)

# output
sa_idx_vec
sa_idx_cp
length(sa_idx_vec)

write.csv(sa_idx_vec, "../pro-files/data/gen/ms-sa-ph-idx-vec.csv", col.names = FALSE, row.names = FALSE)