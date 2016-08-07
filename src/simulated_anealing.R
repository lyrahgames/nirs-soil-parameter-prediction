# simulated annealing algorithm

#preamble containing functions
# neighbour function

idx.neighbour <- function(idx, s) {
	i_mod <- sample(2:s, size = 1)
	if (i_mod %in% idx) {
		idx_new <- idx[idx != i_mod]
	}
	else {
		idx_new <- c(idx, i_mod)
	}
	
	return(idx_new)
}

idx <- 1

# for (i in 2:20) {
	# print(
	# idx <- idx.neighbour(idx, i)
	# )
	# print(idx)
# }

boltzmann.bose <- function(s_1, s_2, Tau) {
	P <- exp((s_2-s_1)/Tau)
}

# algorithm

idx <- 1
Tau <- 1
alpha <- .99
maxIter <- 10000
s <- dim(X)[2]
s_1 <- cp.raw(idx, X, Y, inv_sigma_2)

for (i in 1:maxIter) {
	idx_new <- idx.neighbour(idx, s)
	s_2 <- cp.raw(idx_new, X, Y, inv_sigma_2)
	BBE_criterion <- boltzmann.bose(s_1, s_2, Tau)
	if (sum(BBE_criterion) < runif(1)) {
		idx <- idx_new
		s_1 <- s_2
	}
	Tau <- Tau * alpha
	print(idx)
	print(s_2)
}
