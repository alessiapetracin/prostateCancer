prostate <- read.csv("./prostate.csv") # import dataset

library(randomForest) # load library

set.seed(120) # set seed for reproducibility

# prepare a matrix with nvar rows and 2 columns
# fill the first column with the average cross-validation error corresponding to each choice of m
nvar <- 8 # number of explanatory variables
k <- 10 # folds
n <- nrow(prostate)
folds <- sample(rep(1:k, length=n))
tmp <- matrix(NA, nrow=k, ncol=nvar, dimnames=list(NULL, paste(1:nvar)))
matr <- matrix(NA, nrow=nvar, ncol=2, dimnames=list(NULL, paste(1:2)))

for(i in 1:10) {
  train_fold <- prostate[folds != i, ]
  test_fold <- prostate[folds == i, ]
  for (m in 1:nvar){
    rf.prostate <- randomForest(lpsa ~ ., data=train_fold, mtry=m, importance=TRUE)
    pred <- predict(rf.prostate, newdata=test_fold)
    tmp[i, m] <- mean((test_fold$lpsa - pred)^2)
  }
}

for(i in 1:nvar) {
  matr[i, 1] <- mean(tmp[ , i])
}

matr # visualize the average cross-validation error for each choice of m

# compute out-of-bag error compared to the actual level of PSA for each value of m
# encode the results on the second column of the matrix previously created
n_pred <- ncol(prostate) - 1
for(m in 1:nvar) {
  bag.prostate <- randomForest(lpsa ~ ., data=prostate, mtry=m, importance = TRUE)
  #out-of-bag error
  matr[m, 2] <- (mean((prostate$lpsa - bag.prostate$predicted)^2))
}

matr # visualize matrix

# visualize the errors
plot(matr[,1], type = 'l', col='blue', xlab = 'Number of predictors', ylab = 'Error') # CV error
lines(matr[,2], col='red') # OOB error
legend(x = "topright",         # insert legend 
       legend = c("OOB error", "CV error"), 
       lty = 1,           
       col = c('red', 'blue'))  
title(main = 'Error for number of predictors')

# The two measures differ because the OOB error is evaluated on ensembles that have collectively seen more data. 
# However, since the OOB error ensembles are trained on overlapping training sets, the variance of the estimate can be larger.
# Neither estimator is by default better than the other, 
# but we should note that the OOB error presents computational advantages compared to the CV error

importance(rf.prostate) # view the importance of each variable in reducing the MSE and increasing node purity
varImpPlot(rf.prostate, main = 'Predictors importance') # plot results
