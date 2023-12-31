prostate <- read.csv("./prostate.csv") # read the dataset

# Decision tree
# Since the prediction variable is continuous, the level of prostate specific antigen is predicted through a regression tree

library(tree) # import library
set.seed(1) # set seed for reproducibility

tree.prostate <- tree(lpsa ~ ., prostate) # fit regression tree
plot(tree.prostate) # plot the tree
text(tree.prostate, pretty = 0) # remove variable names
title(main = 'Prostate regression tree') # add title to the plot

summary(tree.prostate) # check variables used in the regression tree

# perform 10-fold cross-validation
x <- as.numeric(list())

for (i in 1:1000){ # iterate the 10-fold cross validation 1000 times
set.seed(i) # set seed for riproducibility
cv.prostate <- cv.tree(object=tree.prostate) # perform cross-validation
lower <- cv.prostate$size[which.min(cv.prostate$dev)]
x <- append(x, as.numeric(lower))
}

# plot the CV error as a function of size and cost-complexity of the tree, for the last iterated cross-validation
op <- par(mfrow=c(1, 2))
plot(cv.prostate$size, cv.prostate$dev, type="b")
title(main = 'CV error by size')
plot(cv.prostate$k, cv.prostate$dev, type="b")
title(main = 'CV error by cost-complexity')
par(op)

# select size of the tree through the mode (value which gives the lowest error most frequently over 1000 iterations according to CV
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

complexity <- Mode(x)
complexity

# use this value to prune the tree
prune.prostate <- prune.tree(tree.prostate, best = complexity)
plot(prune.prostate) # plot the pruned tree
text(prune.prostate, pretty = 0) # remove variable names
title(main = 'Pruned regression tree') # add title

# compute pruned tree performance
set.seed(100)
k <- 10
nmax <- ncol(prostate) - 1
cv.errors <- matrix(NA, nrow=k, ncol=nvar, dimnames=list(NULL, paste(1:nvar)))

for(i in 1:k) {
    train_fold <- prostate[folds != i, ]
    test_fold <- prostate[folds == i, ]
    tree.prostate <- tree(lpsa ~ ., data=train_fold)
    x <- as.numeric(list())

    cv.prostate <- cv.tree(object=tree.prostate)
    lower <- cv.prostate$size[which.min(cv.prostate$dev)]
    x <- append(x, as.numeric(lower))
    
    Mode <- function(x) {
      ux <- unique(x)
      ux[which.max(tabulate(match(x, ux)))]
    }
    
    complexity <- Mode(x)
    prune.prostate <- prune.tree(tree.prostate, best = complexity)
    
    for(j in 1:nmax) {
        pred <- predict(prune.prostate, test_fold, id=j)
        cv.errors[i, j] <- mean((test_fold$lpsa - pred)^2)
    }
}

#CV error
mean.cv.errors <- apply(cv.errors, MARGIN=2, FUN = mean)
min(mean.cv.errors)
