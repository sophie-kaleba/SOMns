#!/usr/bin/env Rscript
install.packages("ggplot2", repos="http://cran.uk.r-project.org")

library(ggplot2)

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

csvfilepath = args[1]
print(csvfilepath)
plotoutput = args[2]
print(plotoutput)

sd.data <- read.csv(file=csvfilepath)
# sd.data <- read.csv(file="./results/Havlak/stack-depth.csv") 
names(sd.data) <- c("depth","loc")
image=ggplot(data=sd.data, aes(x=as.numeric(row.names(sd.data)), y=depth)) + geom_line() +labs(y= "stack depth", x="time")#  + coord_cartesian(xlim =c(0, 1000))
ggsave(file=plotoutput, plot=image, units = c("cm"), dpi = 400)

