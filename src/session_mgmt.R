# setting up session

setwd("~/Desktop/Projekt_4_NIR")

# packages

library(ggplot2)
library(reshape2)

# data import

NIR_data <- read.csv(	file = "./data/NIR.csv",
						header = TRUE,
						sep = ";")
						
dim(NIR_data)
str(NIR_data)
summary(NIR_data)