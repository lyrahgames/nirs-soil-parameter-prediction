# load source files
source("utils.r")
source("init.r")


init.data(ph_vec, ph_design_mat)
mlr.init()

t1 <- proc.time()

idx_vec <- sort(ms.sa(it_max=100000,it_exit=12000,temp=10,alpha=0.995))

t2 <- proc.time()

# save relevant data 
write.table(idx_vec, "../pro-files/data/gen/ms-sa-ph-idx-vec.csv", sep="\t", col.names=F, row.names=F)

wl_const_vec <- c(0, wl_vec)
par_vec <- ms.par.vec(idx_vec)
par_mat <- cbind(wl_const_vec[idx_vec], par_vec)
write.table(par_mat, "../pro-files/data/gen/ms-sa-ph-par.csv", sep="\t", col.names=F, row.names=F)

wl_idx_vec <- (idx_vec-1)[-1]
rnd_spec_data <- read.csv("../pro-files/data/soil-spec-rnd.csv", sep="\t", header=F)
write.table(rnd_spec_data[wl_idx_vec,], "../pro-files/data/gen/ms-sa-ph-spec-rnd.csv", sep="\t", col.names=F, row.names=F)

expect_vec <- ms.expect.vec(idx_vec)
corr_data <- cbind(gv_obs_vec, expect_vec)
write.table(corr_data, "../pro-files/data/gen/ms-sa-ph-corr.csv", sep="\t", col.names=F, row.names=F)

# arithmetic mean of obsevables
obs_mean <- sum(gv_obs_vec)/length(gv_obs_vec)
# total sum of squares
tss <- as.numeric( t(gv_obs_vec - obs_mean) %*% (gv_obs_vec - obs_mean) )
# reidual sum of squares
rss <- as.numeric( t(gv_obs_vec - expect_vec) %*% (gv_obs_vec - expect_vec) )
# explained sum of squares
ess <- as.numeric( t(expect_vec - obs_mean) %*% (expect_vec - obs_mean) )
# compute r² value 
r2 <- 1-(rss/tss)

# output
print("index vector:")
idx_vec
print("index size:")
length(idx_vec)
print("mallows' cp:")
ms.cp(idx_vec)
print("estimated spse:")
ms.spse.est(idx_vec)
print("computed spse:")
rss * ( (length(idx_vec) + gv_sample_size)/(gv_sample_size - length(idx_vec)) )
print("r²")
c( r2, ess/tss )
print("time:")
t2-t1

# simulation
# ms.init.dist(idx_vec)

# t1 <- proc.time()
# sim_spse <- ms.sim(gv_expect_vec, gv_sd, sim_count=10)
# t2 <- proc.time()

# print("simulated spse:")
# sim_spse
# print("time:")
# t2-t1
