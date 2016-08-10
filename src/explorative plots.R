# design matrix

sa_params <- as.matrix(NIR_data[,-c(1:3)])

Y_mat <- as.matrix(NIR_data[,1:3])

Y_hat <- X %*% solve(t(X) %*% X) %*% t(X) %*% Y_mat

Y_plot <- as.data.frame(cbind(Y_hat,Y_mat))

ggplot(data = Y_plot) +
	geom_point( aes(x = Y_plot[,1],
					y = Y_plot[,3+1])) +
	coord_equal(xlim = c(0,8), ylim = c(0,8)) +
	geom_smooth(aes(x = Y_plot[,1],
					y = Y_plot[,3+1]),
					method = "lm") +
	geom_smooth(aes(x = Y_plot[,1],
					y = Y_plot[,3+1]),
					colour = "darkgreen") +
	geom_abline(slope = 1,
				colour = "red")

ggplot(data = Y_plot) +
	geom_point( aes(x = Y_plot[,2],
					y = Y_plot[,3+2])) +
	coord_flip(xlim = c(0,.7), ylim = c(0,.7)) +
	geom_smooth(aes(x = Y_plot[,2],
					y = Y_plot[,3+2]),
					method = "lm") +
	geom_smooth(aes(x = Y_plot[,2],
					y = Y_plot[,3+2]),
					colour = "darkgreen") +
	geom_abline(slope = 1,
				colour = "red")

# spectral plot 

plot_data <- melt(cbind(NIR_data[,-c(1:3)], ID = 1:dim(NIR_data)[1]), id.vars = "ID")
plot_data <- plot_data[order(plot_data$ID),]
plot_data <- cbind(plot_data, domain = seq(1400, 2672, by = 4))
plot_data$ID <- factor(plot_data$ID)
plot_data <- plot_data[order(plot_data$value),]

plot_data$Par_Res <- levels(plot_data$variable) %in% result_MP


for (i in 1:dim(NIR_data)[1]) {

print(ggplot(data = plot_data[	(plot_data$ID==i) &
								(plot_data$variable %in% levels(plot_data$variable)[result_MP]),]) +
		scale_y_continuous(limits = c(0.16,.61)) +
		geom_point( aes( x = domain,
						y = value),
						colour = "red",
						shape = 9,
						size = 3) +
		geom_line(data = plot_data[(plot_data$ID==i),],
					aes(    x = domain,
							y = value)))
}
rm(i)

# parameter plot

SOC_idx <- unlist(read.csv(file = "../pro-files/data/gen/ms-sa-soc-idx-vec.csv", header = T))

design_mat <- cbind(1,refl_mat)

beta_SOC <- mlr.par.mat(design_mat[,SOC_idx]) %*% soc_vec

beta_plot_data <- data.frame(wl_vec[(SOC_idx-1)[-1]], beta_SOC[-1])
colnames(beta_plot_data) <- c("wave_length","parameter")

ggplot(data = beta_plot_data) +
	geom_polygon( aes(x = wave_length,
					y = parameter))
