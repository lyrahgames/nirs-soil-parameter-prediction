# load source files
source("utils.r")
source("init.r")


init.data(soc_vec, soc_design_mat)
mlr.init()

idx_vec <- as.vector(read.csv("../pro-files/data/gen/ms-sa-soc-idx-vec.csv", header=F)[,1])

idx_vec
length(idx_vec)

ms.init.dist(idx_vec)

# pseudo_obs_mat <- rnorm(gv_sample_size, gv_expect_vec, gv_sd)

# for (i in 2:1000){
# 	pseudo_obs_mat <- cbind(pseudo_obs_mat, rnorm(gv_sample_size, gv_expect_vec, gv_sd))
# 	print(dim(pseudo_obs_mat))
# }

# write.table(pseudo_obs_mat, "../pro-files/data/gen/pseudo-obs.csv", sep="\t", col.names=F, row.names=F)

gv_var <- gv_sd^2

print("expectation vector:")
gv_expect_vec
print("standard deviation:")
gv_sd
print("variance:")
gv_var
print("spse:")
(gv_sample_size + length(idx_vec)) * gv_var
