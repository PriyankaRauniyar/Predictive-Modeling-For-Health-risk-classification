# Predictive Modeling for Health Risk Classification

This project builds and evaluates predictive models to classify individuals as **High Risk** vs **Low Risk** using demographic and lifestyle variables. Models include:
- Logistic Regression
- Decision Tree (rpart)

## Project Files

### Data
- `data/Cleaned_Dataset.csv`  
  Cleaned dataset used for training/testing.

### Scripts
- `scripts/SourceCode.R`  
  Main script (data processing + modeling + plots).  
- `scripts/Logistic_Regression_Model.R`  
  Logistic regression model training, prediction, confusion matrix, accuracy, sensitivity/specificity, and S-curve plots.
- `scripts/DecisionTree_Model.R`  
  Decision tree model (rpart), plotting the tree, and evaluating performance on train/test.

### Figures
- `figures/scurve_bmi.png`  
  Logistic S-curve visualization for BMI vs predicted probability of High Risk.
- `figures/scurve_age.png`  
  Logistic S-curve visualization for Age vs predicted probability of High Risk.
- `figures/scurve_sleep.png`  
  Logistic S-curve visualization for Sleep duration vs predicted probability of High Risk.
- `figures/Plot_on_Testing.png`  
  Distribution of predicted classes on the testing dataset.
- `figures/Plot_on_Training.png`  
  Distribution of predicted classes on the Training dataset.
- `figures/decision_tree.png`  
  Decision Tree for Health Risk Classification.
- `figures/Predicted_Probabilities_histogram.png`  
  Distribution of Predicted Health Risk Probabilities.

  
## Methods Summary
1. Split data into training and testing sets  
2. Train Logistic Regression (`glm(..., family="binomial")`)
3. Evaluate using confusion matrix, accuracy, sensitivity, specificity, Type I and Type II error
4. Train Decision Tree (`rpart(method="class")`)
5. Compare performance on training vs testing

## How to Run (R)
1. Open RStudio
2. Set working directory to the project folder
3. Run scripts in `scripts/`

Example:
```r
source("scripts/SourceCode.R")
source("scripts/Logistic_Regression_Model.R")
source("scripts/DecisionTree_Model.R")
