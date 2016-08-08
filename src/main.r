# load source files
source("utils.r")
source("init.r")







# calculate mlr variance and inverse values




# mlr.var(n_vec, cbind(1,refl_mat))
# mlr.var(n_vec, cbind(1,log(refl_mat)))
# mlr.var(ph_vec, cbind(1,refl_mat))
# mlr.var(ph_vec, refl_mat)
# mlr.var(ph_vec, cbind(1,log(refl_mat)))

# mallows.cp(soc_vec, refl_mat, 1:dim(refl_mat)[2], inv_mlr_var)
# fwd_sel_idx = ms.fwd.sel(soc_vec, refl_mat, inv_mlr_var)
# fwd_sel_idx
# mallows.cp(soc_vec, refl_mat, fwd_sel_idx, inv_mlr_var)
# sa_idx = ms.sa(soc_vec, refl_mat, inv_mlr_var)
# sort(sa_idx)
# mallows.cp(soc_vec, refl_mat, sa_idx, inv_mlr_var)

test_soc_idx_vec = match(c(
		1416, 1420, 1436, 1468, 1480, 1492, 1516, 1536, 1540,
		1544, 1548, 1588, 1628, 1632, 1800, 1808, 1832, 1856, 1912, 1948, 1980,
		1984, 1988, 2012, 2052, 2064, 2072, 2088, 2104, 2132, 2144, 2148, 2168,
		2172, 2176, 2188, 2204, 2216, 2224, 2232, 2276, 2280, 2284, 2304, 2332,
		2340, 2348, 2360, 2416, 2420, 2428, 2436, 2472, 2492, 2496, 2508, 2512,
		2516, 2520, 2540, 2548, 2552, 2580, 2584, 2588, 2600, 2612, 2620, 2628,
		2632, 2648, 2672
	), wl_vec)

test_soc_idx_vec_2 = c(
		1, 7, 11, 19, 22, 25, 32, 35, 40, 41, 42, 47, 55, 58, 59, 60, 61, 68, 85,
		88, 99, 100, 103, 104, 105, 110, 111, 116, 130, 135, 139, 148, 149, 155,
		165, 170, 175, 179,	180, 185, 188, 190, 191, 194, 195, 199, 204, 205, 217,
		221, 228, 235, 237, 239, 241, 244, 257, 259, 261, 263, 264, 265, 266, 273, 
		274, 276, 279, 280, 283, 288, 290, 296, 301, 308, 310, 314, 320
	)

test_n_idx_vec = match(c(
		1424, 1480, 1524, 1532, 1552, 1564, 1580, 1584, 1608, 1788, 1800,
		1808, 1816, 1832, 1860, 1912, 1948, 1984, 1988, 2012, 2052, 2060,
		2072, 2092, 2108, 2140, 2148, 2152, 2156, 2196, 2208, 2216, 2276,
		2296, 2300, 2332, 2340, 2348, 2356, 2364, 2412, 2420, 2432, 2436,
		2448, 2452, 2456, 2480, 2488, 2496, 2508, 2512, 2532, 2544, 2556,
		2560, 2588, 2596, 2600, 2624, 2632, 2644, 2652, 2664, 2672
	),wl_vec)

test_ph_idx_vec = match(c(
		1500, 1540, 1584, 1588, 1624, 1640, 1660, 1680, 1732, 1760, 1800,
		1860, 1864, 1896, 1928, 1932, 2152, 2160, 2172, 2176, 2216, 2220,
		2328, 2336, 2344, 2368, 2380, 2420, 2428, 2444, 2448, 2452, 2456,
		2468, 2488, 2532, 2568, 2584, 2612, 2624, 2636, 2640, 2660, 2668,
		2672
	), wl_vec)

# sa_idx = ms.sa(soc_vec, refl_mat, inv_mlr_var, idx_vec = test_idx_vec)
# sort(sa_idx)
# mallows.cp(soc_vec, refl_mat, sa_idx, inv_mlr_var)

# soc test
soc_design_mat <- cbind(1,refl_mat)
mlr_var_soc <- mlr.var(soc_vec, soc_design_mat)
inv_mlr_var_soc <- 1.0 / mlr_var_soc
test_soc_idx_vec <- c(1,test_soc_idx_vec + 1)
mallows.cp(soc_vec, soc_design_mat, test_soc_idx_vec, inv_mlr_var_soc)

data_soc <- read.csv("../pro-files/data/gen/ms-sa-soc-idx-vec.csv")
mallows.cp(soc_vec, soc_design_mat, as.vector(data_soc[,1]), inv_mlr_var_soc)

# mallows.cp(soc_vec, cbind(1,refl_mat), test_soc_idx_vec_2, inv_mlr_var_soc)
# mallows.cp(soc_vec, cbind(1,refl_mat), sort(test_soc_idx_vec_2), inv_mlr_var_soc)

# n test
n_design_mat <- soc_design_mat
mlr_var_n <- mlr.var(n_vec, n_design_mat)
inv_mlr_var_n <- 1.0 / mlr_var_n
test_n_idx_vec <- c(1,test_n_idx_vec + 1)
mallows.cp(n_vec, n_design_mat, test_n_idx_vec, inv_mlr_var_n)

data_n <- read.csv("../pro-files/data/gen/ms-sa-n-idx-vec.csv")
mallows.cp(n_vec, n_design_mat, as.vector(data_n[,1]), inv_mlr_var_n)

# ph test
ph_design_mat <- cbind(1,log(refl_mat))
mlr_var_ph <- mlr.var(ph_vec, ph_design_mat)
inv_mlr_var_ph <- 1.0 / mlr_var_ph
test_ph_idx_vec <- c(1,test_ph_idx_vec + 1)
mallows.cp(ph_vec, ph_design_mat, test_ph_idx_vec, inv_mlr_var_ph)

data_ph <- read.csv("../pro-files/data/gen/ms-sa-ph-idx-vec.csv")
mallows.cp(ph_vec, ph_design_mat, as.vector(data_ph[,1]), inv_mlr_var_ph)


