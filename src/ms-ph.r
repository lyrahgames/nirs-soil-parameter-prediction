# load source files
source("utils.r")
source("init.r")



init.data(ph_vec, ph_design_mat)
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
print("time:")
t2-t1

wl_idx_vec <- (idx_vec-1)[-1]

rnd_spec_data <- read.csv("../pro-files/data/soil-spec-rnd.csv", sep="\t", header=F)
write.table(rnd_spec_data[wl_idx_vec,], "../pro-files/data/gen/ms-sa-ph-spec-rnd.csv", sep="\t", col.names=F, row.names=F)

expect_vec <- ms.expect.vec(idx_vec)
corr_data <- cbind(ph_vec, expect_vec)
write.table(corr_data, "../pro-files/data/gen/ms-sa-ph-corr.csv", sep="\t", col.names=F, row.names=F)

# simulation
# ms.init.dist(idx_vec)

# t1 <- proc.time()
# sim_spse <- ms.sim(gv_expect_vec, gv_sd, sim_count=10)
# t2 <- proc.time()

# print("simulated spse:")
# sim_spse
# print("time:")
# t2-t1
