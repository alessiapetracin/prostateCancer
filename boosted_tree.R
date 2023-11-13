# Boosted regression tree
prostate <- read.csv("./prostate.csv")

library(gbm) # load library
set.seed(12) # set seed for reproducibility

cv.error.b <- matrix(NA, nrow=10, ncol=500, dimnames=list(NULL, paste(1:500)))

for(i in 1:10) { # fit boosted tree
  train_fold <- prostate[folds != i, ]
  test_fold <- prostate[folds == i, ]
  for(j in 1:500) { # iterate 1500 times
  boosted <- gbm(lpsa ~ ., data=train_fold, distribution="gaussian",
              n.trees=j)
  yhat.boost <- predict(boosted, newdata=test_fold, n.trees=j)
  cv.error.b[i, j] <- mean((test_fold$lpsa - yhat.boost)^2)
      
  }
}

mean.cv.error.b <- apply(cv.error.b, MARGIN=2, FUN = mean) # calculate CV error
optimal <- which.min(mean.cv.error.b) # select optimal value to minimize error

boosted.model <- gbm(lpsa ~ ., data=prostate, distribution="gaussian",
              n.trees=optimal[1]) # refit boosted model with n.trees = optimal

plot(mean.cv.error.b, type = 'l', xlab = 'Iterations', ylab = 'CV error') # plot CV error
title('Boosting error')



