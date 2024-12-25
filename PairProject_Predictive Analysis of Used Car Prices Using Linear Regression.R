# Load necessary libraries
library(readr)
library(dplyr)
library(caret)
library(ggplot2)
library(randomForest)

# Load the dataset
car <- read_csv('C:/Users/khali/Downloads/Used Car Dataset.csv')

# Check the structure of the dataset
dim(car)
names(car)
summary(car)
str(car)

# Perform data preprocessing
# Convert manufacturing_year to numeric (handle NAs if any)
car$manufacturing_year <- as.numeric(as.character(car$manufacturing_year))

# Remove rows with NA in manufacturing_year
car <- car[!is.na(car$manufacturing_year), ]

# Select features and target variable
features <- car[, c("manufacturing_year", "engine(cc)")]
target <- car$`price(in lakhs)`

# Split data into training and testing sets
set.seed(42)
trainIndex <- createDataPartition(target, p = .8, list = FALSE)
X_train <- features[trainIndex, ]
X_test <- features[-trainIndex, ]
y_train <- target[trainIndex]
y_test <- target[-trainIndex]

# Convert manufacturing_year to numeric, handling NAs
car$manufacturing_year <- as.numeric(car$manufacturing_year)

# Check for NA values in X_train and X_test
if (anyNA(X_train) || anyNA(X_test)) {
  stop("NA values still present in predictors. Check preprocessing.")
}

# Train Linear Regression model
lm_model <- lm(y_train ~ ., data = cbind(X_train, y_train))

# Predict on test set
y_pred <- predict(lm_model, newdata = X_test)

# Evaluate model
mse <- mean((y_test - y_pred)^2)
r2 <- 1 - (sum((y_test - y_pred)^2) / sum((y_test - mean(y_test))^2))

# Print evaluation metrics
print(paste('Linear Regression - MSE:', mse, ', R-squared:', r2))

# Summary of the model
summary(lm_model)

# Visualize relationship between manufacturing year and price
ggplot(car, aes(x = manufacturing_year, y = `price(in lakhs)`)) +
  geom_point(na.rm = TRUE) +  # Remove points with NA values
  geom_smooth(method = "lm", se = FALSE, color = "blue", na.rm = TRUE) +
  labs(x = "Manufacturing Year", y = "Price (in lakhs)", 
       title = "Relationship between Manufacturing Year and Used Car Price")

# Visualize relationship between engine capacity and price
ggplot(car, aes(x = `engine(cc)`, y = `price(in lakhs)`)) +
  geom_point(na.rm = TRUE) +  # Remove points with NA values
  geom_smooth(method = "lm", se = FALSE, color = "blue", na.rm = TRUE) +
  labs(x = "Engine Capacity (cc)", y = "Price (in lakhs)", 
       title = "Relationship between Engine Capacity and Used Car Price")


# Further exploratory plots and analysis as needed

# Discuss findings and model equation in your report

