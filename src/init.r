# initialize random number generator
set.seed(NULL)

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
wl_vec <- seq(1400, 2672, by = 4)
# get matrix of reflectance values
refl_mat <- as.matrix(soil_spec_data[,(obs_count+1):dim(soil_spec_data)[2]])
# get matrix of observables
obs_mat <- as.matrix(soil_spec_data[,1:obs_count])
# set vector of observables (easy to read and write)
soc_vec <- as.vector(obs_mat[,1])
n_vec <- as.vector(obs_mat[,2])
ph_vec <- as.vector(obs_mat[,3])

# design matrices
soc_design_mat <- cbind(1,refl_mat)
n_design_mat <- soc_design_mat
ph_design_mat <- cbind(1,log(refl_mat))