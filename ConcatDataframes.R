
#below are a few different solutions for concatenating a list of like dataframes
#also a great technique for benchmarking

#Copying example from:
#http://www.r-bloggers.com/concatenating-a-list-of-data-frames/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+RBloggers+%28R+bloggers%29

#create dummy data
data <- list()
N <- 100000
for (n in 1:N) {
data[[n]] = data.frame(index = n, char = sample(letters, 1), z = runif(1))
}

#data[[1]]

##The Naive solution
head(do.call(rbind, data))

##Using plyr
library(plyr)
head(ldply(data, rbind))
head(rbind.fill(data))

##Using data.table
library(data.table)
head(rbindlist(data))


##benchmakring
library(rbenchmark)
benchmark(do.call(rbind, data), ldply(data, rbind), rbind.fill(data), rbindlist(data))



##Comments on Performance

"The naive solution uses the rbind.data.frame() method which is slow 
because it checks that the columns in the various data frames match by name and, 
if they don't, will re-arrange them accordingly. rbindlist(), by contrast, 
does not perform such checks and matches columns by position.

rbindlist() is implemented in C, while rbind.data.frame() is coded in R.

Both of the plyr solutions are an improvement on the naive solution. 
However, relative to all of the other solutions, rbindlist() 
is blisteringly fast."

