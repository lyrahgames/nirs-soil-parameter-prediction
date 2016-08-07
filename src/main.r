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
refl_mat <- as.matrix(soil_spec_data[,(obs_count+1):wl_count])
# get matrix of observables
obs_mat <- as.matrix(soil_spec_data[,1:obs_count])
# set vector of observables (easy to read and write)
soc_vec <- obs_mat[,1]
n_vec <- obs_mat[,2]
ph_vec <- obs_mat[,3]


mlr.var(n_vec, cbind(1,refl_mat))
mlr.var(n_vec, cbind(1,log(refl_mat)))
mlr.var(ph_vec, cbind(1,refl_mat))
mlr.var(ph_vec, refl_mat)
mlr.var(ph_vec, cbind(1,log(refl_mat)))