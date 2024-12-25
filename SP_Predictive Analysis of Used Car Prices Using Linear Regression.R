# STEP1
# Load libraries
library(readr)
library(car)
library(caTools)

# Load the dataset
data <- read_csv('C:/Users/khali/Downloads/Used Car Dataset.csv')

# Display the first few rows of the data set
head(data)

# STEP2
# Check for missing values
colSums(is.na(data))

# STEP3
# Impute missing values with median
data$manufacturing_year[is.na(data$manufacturing_year)] <- median(data$manufacturing_year, na.rm = TRUE)
data$engine[is.na(data$engine)] <- median(data$engine, na.rm = TRUE)
data$price[is.na(data$price)] <- median(data$price, na.rm = TRUE)


# STEP4
# Check data types
str(data)

# Identify non-numeric values in manufacturing_year
non_numeric_years <- data[is.na(suppressWarnings(as.numeric(data$manufacturing_year))), "manufacturing_year"]
print(non_numeric_years)

# Convert manufacturing_year to numeric, keeping the original for reference
data$manufacturing_year_numeric <- suppressWarnings(as.numeric(data$manufacturing_year))

# Calculate the median of the numeric values, ignoring NA
median_year <- median(data$manufacturing_year_numeric, na.rm = TRUE)

# Replace non-numeric values with the median
data$manufacturing_year_numeric[is.na(data$manufacturing_year_numeric)] <- median_year

# Replace the original manufacturing_year column with the numeric one
data$manufacturing_year <- data$manufacturing_year_numeric
data$manufacturing_year_numeric <- NULL

# Remove outliers in the 'engine' column
data <- subset(data, data$engine > lower_bound_engine & data$engine < upper_bound_engine)

# Visualize the distribution of 'price' before cleaning
hist(data$price, main = "Distribution of Price Before Cleaning", xlab = "Price (in lakhs)", breaks = 30, col = "#FFC0CB")

# Visualize the distribution of 'manufacturing_year' and 'engine' after imputing missing values
hist(data$manufacturing_year, main = "Distribution of Manufacturing Year After Cleaning", xlab = "Manufacturing Year", breaks = 30, col = "#8F9779")

# Set options to avoid scientific notation
options(scipen=999)

# Plot the histogram for engine with proper axis labels
hist(data$engine, main = "Distribution of Engine After Cleaning", xlab = "Engine (cc)", breaks = 30, col = "#ADD8E6", xaxt='n')
axis(1, at=pretty(data$engine), labels=format(pretty(data$engine), scientific=FALSE))



# STEP5
# Verify the changes
str(data)

# STEP6
# Boxplots to detect outliers
par(mfrow = c(1, 2))
boxplot(data$manufacturing_year, main = "Manufacturing Year", col = "#FFC0CB")
boxplot(data$engine, main = "Engine (cc)", col = "#ADD8E6" )

# Treat outliers using IQR method
Q1 <- quantile(data$manufacturing_year, 0.25, na.rm = TRUE)
Q3 <- quantile(data$manufacturing_year, 0.75, na.rm = TRUE)
IQR <- Q3 - Q1
data <- subset(data, data$manufacturing_year > (Q1 - 1.5 * IQR) & data$manufacturing_year < (Q3 + 1.5 * IQR))

Q1 <- quantile(data$engine, 0.25, na.rm = TRUE)
Q3 <- quantile(data$engine, 0.75, na.rm = TRUE)
IQR <- Q3 - Q1
data <- subset(data, data$engine > (Q1 - 1.5 * IQR) & data$engine < (Q3 + 1.5 * IQR))

# STEP7
# Normalize the features
data$manufacturing_year <- scale(data$manufacturing_year)
data$engine <- scale(data$engine)

# Scatter Plot to Show Relationship Between 'Engine' and 'Price'
plot(data$engine, data$price, main = "Engine vs. Price", xlab = "Engine (cc)", ylab = "Price (in lakhs)", pch = 19, col = "#FF69B4")

# Scatter Plot to Show Relationship Between 'Manufacturing Year' and 'Price'
plot(data$manufacturing_year, data$price, main = "Manufacturing Year vs. Price", xlab = "Manufacturing Year", ylab = "Price (in lakhs)", pch = 19, col = "#4169E1")


# STEP8
# Calculate VIF
model <- lm(price ~ manufacturing_year + engine, data = data)
vif(model)

# STEP9
# Set seed for reproducibility
set.seed(123)

# Split the data into training and testing sets
split <- sample.split(data$price, SplitRatio = 0.8)
train_data <- subset(data, split == TRUE)
test_data <- subset(data, split == FALSE)

# STEP10
# Train the model
model <- lm(price ~ manufacturing_year + engine, data = train_data)

# STEP11
# Predict on the test set
predictions <- predict(model, newdata = test_data)

# Scatter Plot of Actual vs. Predicted Prices
plot(test_data$price, predictions, main = "Actual vs. Predicted Prices", xlab = "Actual Price (in lakhs)", ylab = "Predicted Price (in lakhs)", pch = 19, col = "#FFC0CB")
abline(0, 1, col = "#4169E1", lwd = 2) # Line of perfect prediction


# STEP12
# Evaluate the model
actuals <- test_data$price
r2 <- summary(model)$r.squared
mse <- mean((predictions - actuals)^2)

cat("R-squared: ", r2, "\n")
cat("Mean Squared Error: ", mse, "\n")

# STEP13
# Model summary
summary(model)

# Model equation
cat("Model equation: price = ", coef(model)[1], " + ", coef(model)[2], "*manufacturing_year + ", coef(model)[3], "*engine\n")

# STEP14
# Diagnostic plots
par(mfrow = c(2, 2))
plot(model)



