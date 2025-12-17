
#****************************************Logistic Regression**************************
#Load data set
path = read.csv("Cleaned_Dataset.csv", header = TRUE, stringsAsFactors = F)
#*(1) Splitting the data into training and test data
set.seed(2) # for reproducible results
train <- sample(1:nrow(path), (0.6666)*nrow(path))
train.path <- path[train,]
test.path <- path[-train,]
summary(train.path)
summary(test.path)

# Logistic regression and display the results
logit.reg <- glm(health_risk ~ age + exercise + sleep + sugar_intake + smoking +alcohol
                 + married + profession + bmi,
                 data = train.path, family = "binomial")

#Interpretation of significancy and coefficient
summary(logit.reg)

#check proportion of high-risk vs low-risk on training and testing
table(train.path$health_risk)
table(test.path$health_risk)
prop.table(table(train.path$health_risk))
prop.table(table(test.path$health_risk))

# Accuracy on Training data
train.pred <- predict(logit.reg, train.path, type = "response")
train.class <- ifelse(train.pred >= 0.5, 1, 0)
#Confusion Matrix on training data
train.cm <- table(Actual = train.path$health_risk,Predicted = train.class)
train.cm

tp <- train.cm[2,2]
tn <- train.cm[1,1]
fp <- train.cm[2,1]
fn <- train.cm[1,2]
# FNR(Type-2 error)
fnr<-(fn)/(fn+tp);fnr


#Check Accuracy on training Dataset
train.accuracy <- sum(diag(train.cm)) / sum(train.cm)
train.accuracy

# Accuracy on the test data
test.pred <- predict(logit.reg, test.path, type = "response")

#After applying a 0.5 threshold, probabilities are converted into classes.
# Convert probability to a classification
test.Class <- ifelse(logit.pred >0.35, 1, 0)
#Confusion matrix
actual <- test.path$health_risk;actual
test.confusion_matrix <- table(Predicted = test.Class, Actual = actual);confusion_matrix
test.confusion_matrix

true_pos <- test.confusion_matrix[2,2]
true_neg <- test.confusion_matrix[1,1]
false_pos <- test.confusion_matrix[2,1]
false_neg <- test.confusion_matrix[1,2]

# Accuracy on testing dataset
test.accuracy <- (true_pos + true_neg) / (true_pos + true_neg + false_pos + false_neg);accuracy

# TPR = Recall = Sensitivity
sensitivity <- (true_pos) / (true_pos + false_neg);sensitivity
ssv <- (tp) / (tp + fn);ssv
# TNR = Specificity
specificity <- (true_neg) / (true_neg + false_pos);specificity

# FPR(Type-1 error)
false_pos_rate <- (false_pos) / (false_pos + true_neg);false_pos_rate

# FNR(Type-2 error)
false_neg_rate <- (false_neg) / (false_neg + true_pos);false_neg_rate


#plot to see the probability of High risk 
ggplot(data.frame(prob = logit.pred), aes(x = prob)) +
  geom_histogram(bins = 30, fill = "#00BFC4", color = "white", alpha = 0.8) +
  labs(
    title = "Distribution of Predicted Probabilities",
    x = "Predicted probability of High Risk",
    y = "Count"
  ) +
  theme_minimal(base_size = 14)

Hi#bar plot for training predicted class
ggplot(data.frame(class = train.class), aes(x = factor(class))) +
  geom_bar(fill = "#00BFC4") +
  labs(
    title = "Distribution of Predicted on Training Classes",
    x = "Predicted Class (0 = Low Risk, 1 = High Risk)",
    y = "Count"
  ) +
  theme_minimal(base_size = 14)
#bar plot for testing predicted class
ggplot(data.frame(class = test.Class), aes(x = factor(class))) +
  geom_bar(fill = "#00BFC4") +
  labs(
    title = "Distribution of Predicted on Testing Classes",
    x = "Predicted Class (0 = Low Risk, 1 = High Risk)",
    y = "Count"
  ) +
  theme_minimal(base_size = 14)






curve.data$prob <- predict(logit.reg, curve.data, type = "response")
library(ggplot2)

ggplot(train.path, aes(x = bmi, y = pred_prob, color = health_risk)) +
  
  geom_jitter(
    width = 0.4,
    height = 0.03,
    alpha = 0.6,
    size = 2
  ) +
  
  geom_line(
    data = curve.data,
    aes(x = bmi, y = prob),
    inherit.aes = FALSE,
    color = "#8B0000",
    linewidth = 1.5
  ) +
  
  labs(
    title = "BMI vs Probability of High Risk",
    x = "BMI",
    y = "Predicted Probability of High Risk",
    color = "Actual Class"
  ) +
  
  scale_color_manual(
    values = c("low" = "#4FC3C7", "high" = "#E57373")
  ) +
  
  scale_y_continuous(
    limits = c(0, 1),
    breaks = c(0, 0.25, 0.5, 0.75, 1)
  ) +
  
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))
