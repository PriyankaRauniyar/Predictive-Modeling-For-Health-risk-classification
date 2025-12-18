# Predictive Modeling for Health Risk Classification

This project builds and evaluates predictive models to classify individuals as **High Risk** vs **Low Risk** using demographic and lifestyle variables. Models include:
- Logistic Regression
- Decision Tree (rpart)

# Predictive Modeling for Health Risk Classification
*Using Logistic Regression and Decision Tree Models*

---

## Project Overview

This project focuses on predicting **health risk levels (Low vs High)** using interpretable machine learning models based on demographic and lifestyle factors. The objective is not only to achieve high predictive accuracy but also to understand how variables such as **age, BMI, sleep duration, exercise, smoking, alcohol consumption, and sugar intake** influence health risk.

Two models are developed and compared:
- **Logistic Regression** for probabilistic interpretation
- **Decision Tree** for rule-based, explainable classification

---

## Dataset Description

The dataset contains individual-level health and lifestyle information, including:

- **Demographics:** Age, marital status, profession  
- **Lifestyle factors:** Exercise level, sleep duration, sugar intake, smoking, alcohol consumption  
- **Health indicator:** Body Mass Index (BMI)  
- **Target variable:** `health_risk` (Low / High)

### Data Preparation
- Missing values were handled appropriately  
- Categorical variables were encoded  
- Data was split into **training** and **testing** sets  

---

## Methodology

### Exploratory Data Analysis (EDA)
- Summary statistics and distribution analysis  
- Boxplots for outlier detection  
- Class balance analysis  

### Modeling
- **Logistic Regression**
  - Estimates probability of high health risk
  - Enables interpretation using S-curves
- **Decision Tree**
  - Captures nonlinear interactions
  - Produces interpretable decision rules

### Evaluation Metrics
- Training and testing accuracy  
- Confusion matrix
- sensitivity, specificity
- Type I and Type II error analysis  

---

## Model Performance Evaluation

### Logistic Regression
- **Training Accuracy:** 88.3%  
- **Testing Accuracy:** 87.8%  
- **Type I Error (False Positive Rate):** 32.25%  
- **Type II Error (False Negative Rate):** 4.3%  

*The model shows strong generalization and high sensitivity in detecting high-risk individuals, which is desirable for health screening applications.*

---

### Decision Tree
- **Training Accuracy:** 97.1%  
- **Testing Accuracy:** 97.4%  
- **Type I Error (False Positive Rate):** 4.6%  
- **Type II Error (False Negative Rate):** 1.8%  

*The decision tree achieves superior accuracy with low error rates and offers highly interpretable decision rules.*

---

## Key Visualizations

- Distribution of predicted classes (training & testing)  
- Distribution of predicted probabilities  
- Logistic regression S-curves:
  - Age vs Health Risk  
  - Sleep Duration vs Health Risk  
  - BMI vs Health Risk  
- Decision Tree visualization showing key splits  

---

## Results Summary

- **BMI, age, and sleep duration** are the strongest predictors of health risk  
- Logistic regression provides smooth probability trends  
- Decision tree offers intuitive, rule-based explanations  
- Both models generalize well to unseen data  

---
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

---
## How to Run (R)
1. Open RStudio
2. Set working directory to the project folder
3. Run scripts in `scripts/`

Example:
```r
source("scripts/SourceCode.R")
source("scripts/Logistic_Regression_Model.R")
source("scripts/DecisionTree_Model.R")


















