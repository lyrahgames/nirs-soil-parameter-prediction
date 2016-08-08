# load source files
source("utils.r")


# read spectral soil data
soil_spec_data <- read.csv("../pro-files/data/soil-spec.csv", sep=";")

# define data dimensions
# number of wavelengths
wl_count <- dim(soil_spec_data)[2] - 3
# number of samples
sample_count <- dim(soil_spec_data)[1]
# number of observables
obs_count <- 3

# construct all wavelengths (only hard coded; future: has to be read from data)
wl <- seq(1400, 2672, by = 4)
# get matrix of reflectance values
refl_mat <- as.matrix(soil_spec_data[,(obs_count+1):dim(soil_spec_data)[2]])
# get matrix of observables
obs_mat <- as.matrix(soil_spec_data[,1:obs_count])
# set vector of observables (easy to read and write)
soc_vec <- obs_mat[,1]
n_vec <- obs_mat[,2]
ph_vec <- obs_mat[,3]





# calculate mlr variance and inverse values
mlr_var = mlr.var(soc_vec, refl_mat)
inv_mlr_var = 1.0 / mlr_var



# mlr.var(n_vec, cbind(1,refl_mat))
# mlr.var(n_vec, cbind(1,log(refl_mat)))
# mlr.var(ph_vec, cbind(1,refl_mat))
# mlr.var(ph_vec, refl_mat)
# mlr.var(ph_vec, cbind(1,log(refl_mat)))

mallows.cp(soc_vec, refl_mat, 1:dim(refl_mat)[2], inv_mlr_var)
# fwd_sel_idx = ms.fwd.sel(soc_vec, refl_mat, inv_mlr_var)
# fwd_sel_idx
# mallows.cp(soc_vec, refl_mat, fwd_sel_idx, inv_mlr_var)
# sa_idx = ms.sa(soc_vec, refl_mat, inv_mlr_var)
# sort(sa_idx)
# mallows.cp(soc_vec, refl_mat, sa_idx, inv_mlr_var)

test_idx_vec = match(c(1416, 1420, 1436, 1468, 1480, 1492, 1516, 1536, 1540,
	1544, 1548, 1588, 1628, 1632, 1800, 1808, 1832, 1856, 1912, 1948, 1980,
	1984, 1988, 2012, 2052, 2064, 2072, 2088, 2104, 2132, 2144, 2148, 2168,
	2172, 2176, 2188, 2204, 2216, 2224, 2232, 2276, 2280, 2284, 2304, 2332,
	2340, 2348, 2360, 2416, 2420, 2428, 2436, 2472, 2492, 2496, 2508, 2512,
	2516, 2520, 2540, 2548, 2552, 2580, 2584, 2588, 2600, 2612, 2620, 2628,
	2632, 2648, 2672), wl)

sa_idx = ms.sa(soc_vec, refl_mat, inv_mlr_var, idx_vec = test_idx_vec)
sort(sa_idx)
mallows.cp(soc_vec, refl_mat, sa_idx, inv_mlr_var)

test_idx_vec
mallows.cp(soc_vec, refl_mat, test_idx_vec, inv_mlr_var)