# setting up session

setwd("~/Desktop/soil-nirs")

# packages

require(ggplot2)
require(reshape2)

# data import

NIR_data <- read.csv(	file = "./data/NIR.csv",
						header = TRUE,
						sep = ";")
						
dim(NIR_data)
str(NIR_data)
summary(NIR_data)