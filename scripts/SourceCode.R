rm(list = ls())
# Install & Load libraries
library(tidyverse)
library(ggplot2) 
library(tidyr)
library(dplyr)
install.packages("psych")
library(psych)
install.packages("DescTools") # for handaling outliers
library(DescTools)

# Download latest version
# Save a full copy before any changes
#path_original <- path

#cleaned dataset path 
path = read.csv("Cleaned_Dataset.csv", header = TRUE, stringsAsFactors = F)


#save cleaned dataset after converting excercise and suger intake factor level into high and low only
#write.csv(path, "Cleaned_Dataset.csv", row.names = FALSE)

#structure of dataset
str(path)

#Dimension of the datase
dim(path)

# Summary statistics for each column
summary(path)
library(Hmisc)
describe(path)
head(path)
names(path)
#datatypes
sapply(path,class)
typeof(path$age)
library(dplyr)
glimpse(path)

#checking missing value
anyNA(path)
colSums(is.na(path))
is.null(path)
na.omit(path)

#Checking for duplicates
duplicated(path)
sum(duplicated(path))      # Count of duplicate rows
path[duplicated(path), ]     # View duplicate rows

#converting datatype into factor for dependent variable
# Convert health_risk to binary (0 = low, 1 = high)
path$health_risk <- ifelse(path$health_risk == "high", 1, 0)
path$health_risk <- factor(path$health_risk, levels = c(0,1),, labels = c("low", "high") )
path$health_risk
table(path$health_risk)
levels(path$health_risk)
unique(path$health_risk)

# Convert to factors where appropriate
path$smoking <- as.factor(path$smoking)
path$alcohol <- as.factor(path$alcohol)
path$married <- as.factor(path$married)
path$profession <- as.factor(path$profession)

#Converting medium and high as high, low and none as low for both suger_intake and excercise variable
#path$exercise[path$exercise %in% c("high", "medium")] <- "high"
#path$exercise[path$exercise %in% c("low", "none")] <- "low"
path$exercise <- factor(path$exercise)
levels(path$exercise)
table(path$exercise)

#path$sugar_intake[path$sugar_intake %in% c("medium", "low")] <- "low"
#path$sugar_intake[path$sugar_intake == "high"] <- "high"
path$sugar_intake <- factor(path$sugar_intake)
levels(path$sugar_intake)
table(path$sugar_intake)


# remove the weight and height columns 
#path <- path %>% select( -height,-weight)

#Each Variable’s Statistics and Specifications
# Numeric columns
numeric_cols <- sapply(path, is.numeric)

# Select numeric columns
numeric_vars <- path %>% select(age, bmi, sleep)
numeric_vars

# Descriptive statistics
describe(numeric_vars)
summary(numeric_vars)

# List of categorical variables
categorical_vars <- c("exercise", "sugar_intake", "smoking", "alcohol", "married", "profession")
categorical_vars

# Bin numeric variables
# path$age_group <- cut(path$age, breaks = seq(15, 85, by = 5), right = FALSE)
# path$bmi_group <- cut(path$bmi, breaks = seq(14, 45, by = 2.5), right = FALSE)
# path$sleep_group <- cut(path$sleep, breaks = seq(3, 10, by = 1), right = FALSE)

# Combine into one list of variables for frequency table
vars_for_freq <- c("age_group", "bmi_group", "sleep_group", 
                   "exercise", "sugar_intake", "smoking", 
                   "alcohol", "married", "profession")

# Loop through and print frequency tables
for (var in vars_for_freq) {
  cat("Variable:", var, "\n")
  print(table(path[[var]]))
  cat("\n-----------------------------\n")
}

#Variable Uniqueness
sapply(path, function(x) length(unique(x)))

# Correlation matrix for numeric variables
cor(numeric_vars)


# Visualize correlation
library(corrplot)
corrplot(cor(numeric_vars), method = "number")

# Set up plotting area
par(mfrow = c(1, 3))  # 1 row, 3 columns

# Create boxplots
boxplot(path$age, main = "Boxplot of Age", col = "lightblue")
boxplot(path$sleep, main = "Boxplot of Sleep", col = "lightgreen")
boxplot(path$bmi, main = "Boxplot of BMI", col = "lightcoral")

# Function to detect outlier indices
find_outliers <- function(x) {
  Q1 <- quantile(x, 0.25)
  Q3 <- quantile(x, 0.75)
  IQR <- Q3 - Q1
  which(x < (Q1 - 1.5 * IQR) | x > (Q3 + 1.5 * IQR))
}
# Detect outliers in each numeric column
outliers_age <- find_outliers(path$age)
outliers_sleep <- find_outliers(path$sleep)
outliers_bmi <- find_outliers(path$bmi)

# Print how many outliers in each
cat("Outliers in Age:", length(outliers_age), "\n")
cat("Outliers in Sleep:", length(outliers_sleep), "\n")
cat("Outliers in BMI:", length(outliers_bmi), "\n")

# Calculate IQR thresholds
Q1 <- quantile(path$bmi, 0.25)
Q3 <- quantile(path$bmi, 0.75)
IQR <- Q3 - Q1
IQR
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR
cat("Lower bound:", lower_bound, "\n")
cat("Upper bound:", upper_bound, "\n")

#Remove outliers
path_clean <- path %>%filter(bmi >= lower_bound & bmi <= upper_bound)
# Optional: Check how many rows were removed
cat("Rows before:", nrow(path), "\n")
cat("Rows after :", nrow(path_clean), "\n")
summary(path$bmi) 
#overwrite the dataset 
path <- path_clean


# Extract only the outlier values
#bmi_outliers <- path$bmi[path$bmi < lower_bound | path$bmi > upper_bound]
#bmi_outliers

# Winsorize the 'bmi' column to reduce the impact of extreme outliers
#path$bmi <- Winsorize(path$bmi)

#boxplot to show outliers after removal
boxplot(path$bmi,  main = "Boxplot of BMI",  col = "lightblue", border = "darkblue", outline = TRUE)


#Histograms for Numeric Variables
par(mfrow = c(1, 3))
hist(path$age, main = "Histogram of Age", xlab = "Age",xlim = c(10, 85), ylim = c(0, 600), breaks = seq(15, 85, by = 5),col = "skyblue",xaxs = "i",las = 1)
hist(path$sleep,main = "Histogram of Sleep",xlab = "Hours of Sleep",col = "lightgreen",xlim = c(3, 10),ylim = c(0, 800),xaxs = "i",las = 1)

range(path$bmi)
table(path$bmi)
breaks <- seq(10, 55, by = 2.5)
bmi_labels <- paste0(breaks[-length(breaks)], "–", breaks[-1])
hist(path$bmi,main = "Histogram of BMI",xlab = "BMI",col = "salmon", xlim = c(10, 45),ylim = c(0, 600),breaks = breaks,xaxs = "i",las = 1) 


#axis(1, at = hist_bmi$mids, labels = bmi_labels, cex.axis = 0.8, las = 1)

table(path$exercise)
unique(path$profession)

#Bar Plots for Categorical Variables
barplot(table(path$exercise),main = "Exercise Frequency", xlab = "Exercise Level",ylab = "Number of People", col = "orange",ylim = c(0, 3000),las = 1)  
barplot(table(path$sugar_intake), main = "Sugar Intake",ylab = "Number of People",xlab = "Sugar Intake Level", col = "red",ylim = c(0, 3000),las = 1)
barplot(table(path$smoking),main = "Smoking Status",col = "gray40",xlab = "Smoking Category",ylab = "Count",border = "white", ylim = c(0, 5000),cex.names = 1.1,las = 1)
barplot(table(path$alcohol),main = "Alcohol Consumption",col = "purple",xlab = "Alcohol Use",ylab = "Count",border = "white",ylim = c(0, 4000),cex.names = 1.1,las = 1)
barplot(table(path$married),main = "Marital Status",col = "steelblue",xlab = "Status", ylab = "Count", border = "white",ylim = c(0, 4000),cex.names = 1.1, las = 1)
barplot(table(path$profession), main = "Profession Distribution", col = "seagreen3", xlab = "Profession", ylab = "Number of People", border = "white", cex.names = 0.6,  las = 2)   

#visualize fators  Affecting Health risk
ggplot(path, aes(x = exercise, fill = health_risk)) +geom_bar(position = "fill") +labs(title = "Exercise vs Health Risk", y = "Proportion") +theme_minimal()     
ggplot(path, aes(x = health_risk, y = bmi, fill = health_risk)) +geom_boxplot() +labs(title = "BMI by Health Risk")       
ggplot(path, aes(x = smoking, fill = health_risk)) +geom_bar(position = "fill") +labs(title = "Smoking vs Health Risk", y = "Proportion")     
ggplot(path, aes(x = health_risk, y = age, fill = health_risk)) +geom_boxplot() +labs(title = "AGE by Health Risk")      
ggplot(path, aes(x = health_risk, y = sleep, fill = health_risk)) +geom_boxplot() +labs(title = "Sleep by Health Risk")      
ggplot(path, aes(x = sugar_intake, fill = health_risk)) +geom_bar(position = "fill") +labs(title = "Sugar Intake vs Health Risk", y = "Proportion")     
ggplot(path, aes(x = alcohol, fill = health_risk)) +geom_bar(position = "fill") +labs(title = "Alcohol vs Health Risk", y = "Proportion")     
ggplot(path, aes(x = married, fill = health_risk)) +geom_bar(position = "fill") +labs(title = "marriage vs Health Risk", y = "Proportion")     
ggplot(path, aes(x = profession, fill = health_risk)) +geom_bar(position = "fill") +labs(title = "Profession vs Health Risk", y = "Proportion")     

#Compare multiple categorical variables in one view, Reshape to long format for facets
long_data <- path %>%
  pivot_longer(cols = c(exercise, smoking, alcohol, sugar_intake, married, profession),
               names_to = "factor", values_to = "level")
# Faceted stacked bar plot
ggplot(long_data, aes(x = level, fill = health_risk)) +
  geom_bar(position = "fill") +
  facet_wrap(~factor, scales = "free_x") +
  labs(title = "Factors vs Health Risk", x = "", y = "Proportion")

# Step 1: Compare multiple numerical variables in one view, Select relevant numeric variables and reshape
num_var <- path %>%
  select(health_risk, age, bmi, sleep) %>%
  pivot_longer(cols = -health_risk, names_to = "variable", values_to = "value")

# Step 2: Faceted boxplot
ggplot(num_var, aes(x = health_risk, y = value, fill = health_risk)) +
  geom_boxplot(outlier.shape = 21, outlier.size = 1.5) +
  facet_wrap(~variable, scales = "free_y") +
  labs(title = "Numerical Factors by Health Risk", x = "Health Risk", y = "Value") +
  theme_minimal()

#Scatter Plot: Age vs BMI (Colored by Health Risk) and size by sleep hour
ggplot(path, aes(x = age, y = bmi, color = health_risk, size = sleep)) +
  geom_point(alpha = 0.5) +
  labs(title = "Age vs BMI by Health Risk and Sleep", x = "Age", y = "BMI") +
  theme_minimal()

#scatter Plot: Age vs BMI (Colored by Health Risk)
ggplot(path, aes(x = age, y = bmi, color = health_risk)) +
  geom_point(alpha = 0.8) +
  labs(title = "Age vs BMI by Health Risk", x = "Age", y = "BMI") +
  theme_minimal()

library(GGally)

GGally::ggpairs(path, columns = c("age", "bmi", "sleep"), 
                mapping = ggplot2::aes(color = health_risk),
                upper = list(continuous = "points"),
                lower = list(continuous = "smooth"))



ggplot(path, aes(x = age, y = bmi, color = health_risk, size = sleep)) +
  geom_point(alpha = 0.5, shape = 21, stroke = 0.2) +  # lighter, cleaner points
  scale_color_manual(values = c("Low" = "#FF6F61", "High" = "#00BFC4")) +  # custom colors
  scale_size(range = c(1, 4)) +  # control bubble size range
  scale_x_continuous(breaks = seq(10, 90, 10)) +  # tidy x-axis
  scale_y_continuous(breaks = seq(10, 50, 5)) +   # tidy y-axis
  labs(
    title = "Age vs BMI by Health Risk and Sleep",
    subtitle = "Bubble size represents hours of sleep per day",
    x = "Age (years)",
    y = "BMI",
    color = "Health Risk",
    size = "Sleep (hrs)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "right",
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "gray90")
  )


# Chi-square test
chisq.test(table(path$smoking, path$health_risk))
chisq.test(table(path$alcohol, path$health_risk))
chisq.test(table(path$married, path$health_risk))
chisq.test(table(path$profession, path$health_risk))
chisq.test(table(path$sugar_intake, path$health_risk))
chisq.test(table(path$exercise,path$health_risk))

#****************************************Logistic Regression**************************
#Load data set
#path = read.csv("cleaned_health_dataset.csv", header = TRUE, stringsAsFactors = F)

#*(1) Splitting the data into training and test data
set.seed(2) # for reproducible results
train <- sample(1:nrow(path), (0.6666)*nrow(path))
train.path <- path[train,]
test.path <- path[-train,]
summary(train.path)
summary(test.path)

# (2) Logistic regression and display the results
logit.reg <- glm(health_risk ~ age + exercise + sleep + sugar_intake + smoking +alcohol
                 + married + profession + bmi,
                 data = train.path, family = "binomial")

#(3) Interpretation of significancy and coefficient
summary(logit.reg)

# (4) Accuracy on the training & test data
test.pred <- predict(logit.reg, test.path, type = "response");logit.pred

ggplot(data.frame(prob = logit.pred), aes(x = prob)) +
  geom_histogram(bins = 30, fill = "#00BFC4", color = "white", alpha = 0.8) +
  labs(
    title = "Distribution of Predicted Probabilities",
    x = "Predicted probability of High Risk",
    y = "Count"
  ) +
  theme_minimal(base_size = 14)

#check proportion of high-risk vs low-risk
table(train.path$health_risk)
prop.table(table(train.path$health_risk))

#After applying a 0.5 threshold, probabilities are converted into classes.
# Convert probability to a classification
logit.pred_Class <- ifelse(logit.pred > 0.5, 1, 0)

ggplot(data.frame(class = logit.pred_Class), aes(x = factor(class))) +
  geom_bar(fill = "#00BFC4") +
  labs(
    title = "Distribution of Predicted Classes",
    x = "Predicted Class (0 = Low Risk, 1 = High Risk)",
    y = "Count"
  ) +
  theme_minimal(base_size = 14)

#Confusion matrix
actual <- test.path$health_risk;actual

confusion_matrix <- table(Predicted = logit.pred_Class, Actual = actual);confusion_matrix

confusion_matrix

true_pos <- confusion_matrix[2,2]
true_neg <- confusion_matrix[1,1]
false_pos <- confusion_matrix[2,1]
false_neg <- confusion_matrix[1,2]

# Accuracy
accuracy <- (true_pos + true_neg) / (true_pos + true_neg + false_pos + false_neg);accuracy

# TPR = Recall = Sensitivity
sensitivity <- (true_pos) / (true_pos + false_neg);sensitivity

# TNR = Specificity
specificity <- (true_neg) / (true_neg + false_pos);specificity

# FPR(Type-1 error)
false_pos_rate <- (false_pos) / (false_pos + true_neg);false_pos_rate

# FNR(Type-2 error)
false_neg_rate <- (false_neg) / (false_neg + true_pos);false_neg_rate




# Accuracy on Training data
train.pred <- predict(logit.reg, train.path, type = "response")
train.class <- ifelse(train.pred >= 0.5, 1, 0)
#Confusion Matrix on training data
train.cm <- table(
  Actual = train.path$health_risk,
  Predicted = train.class
)
train.cm

#Check Accuracy on training Dataset
train.accuracy <- sum(diag(train.cm)) / sum(train.cm)
train.accuracy
