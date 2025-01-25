**Overview**

This repository contains an R script for performing predictive analysis on used car prices using Linear Regression. The goal of this project is to build a model that predicts the price of used cars based on various features like age, mileage, brand, model, and other relevant factors. Linear regression is used to model the relationship between these features and the target variable (car price).

**Files Included:**

Used Car Prices Using Linear Regression: This script contains the entire workflow for predicting car prices, starting from loading the data, performing exploratory data analysis (EDA), feature engineering, splitting the data, fitting the linear regression model, and evaluating the model performance.

**Key Features**

1. Data Loading and Preprocessing

    The script loads the used car dataset and performs necessary preprocessing, including handling missing values, encoding categorical variables, and scaling numerical features to prepare the data for modeling.

2. Exploratory Data Analysis (EDA)

    EDA is performed to understand the relationships between the features and the target variable (car price). This includes visualizing distributions, detecting outliers, and checking for multicollinearity.

3. Linear Regression Model

    The script fits a linear regression model to predict car prices using selected features. The model is evaluated based on performance metrics such as R-squared and Mean Squared Error (MSE).

4. Model Evaluation

    After training the model, performance is evaluated using various metrics, including:

    - R-squared: Measures the proportion of variance in the car price that is explained by the features.
    - Mean Squared Error (MSE): Measures the average of the squares of the errors (i.e., the difference between the predicted and actual values).
