path = read.csv("Cleaned_Dataset.csv", header = TRUE, stringsAsFactors = F)

#****************************************Decission Tree**************************

library(rpart)
library(rpart.plot)

#Train the decision tree on TRAINING data
tree.model <- rpart(
  health_risk ~ age + exercise + sleep + sugar_intake + smoking +
    alcohol + married + profession + bmi,
  data = train.path,
  method = "class",
  control = rpart.control(cp = 0.01)
)

rpart.plot(tree.model, type = 1, extra = 1)

#Use this trained tree on TESTING data
test.tree.pred <- predict(tree.model, test.path, type = "class")
test.cm.tree <- table(
  Actual = test.path$health_risk,
  Predicted = test.tree.pred
);test.cm.tree

# Testing accuracy
#Confusion matrix (testing)
test.cm.tree <- table( Actual = test.path$health_risk,Predicted = test.tree.pred);test.cm.tree
test.acc.tree <- sum(diag(test.cm.tree)) / sum(test.cm.tree);test.acc.tree

#Training accuracy (Decision Tree)
train.tree.pred <- predict(tree.model, train.path, type = "class")
#Confusion matrix (testing)
train.cm.tree <- table(Actual = train.path$health_risk,Predicted = train.tree.pred);train.cm.tree
train.acc.tree <- sum(diag(train.cm.tree)) / sum(train.cm.tree)
train.acc.tree

cat("Training Accuracy:", round(train.acc.tree, 3), "\n")
cat("Testing Accuracy :", round(test.acc.tree, 3), "\n")

#Type 1 Error
type1_error <- test.cm.tree["low", "high"] / sum(test.cm.tree["low", ]);type1_error
#Typer 2 Error
type2_error <- test.cm.tree["high", "low"] / sum(test.cm.tree["high", ]);type2_error
