prostate <- read.csv("./prostate.csv") # read the dataset

# Decision tree
# Since the prediction variable is continuous, the level of prostate specific antigen is predicted through a regression tree

library(tree)
set.seed(1) # set seed for reproducibility

tree.prostate <- tree(lpsa ~ ., prostate) # fit regression tree
plot(tree.prostate) # plot the tree
text(tree.prostate, pretty = 0) # remove variable names
title(main = 'Prostate regression tree') # add title to the plot


