#-----------------------------------------Preparation of Data-------------------------------------------#

# Install and load packages
install.packages("stats")
install.packages("tidyverse")
install.packages("Kendall")
install.packages("forecast")
install.packages("tseries")
install.packages("lmtest")

library(stats)
library(tidyverse)
library(Kendall)
library(forecast)
library(tseries)
library(lmtest)

# Extract rows for "New Zealand" and exclude columns for Country Name, Country Code, and Indicator Code
fertility_ds <- Assignment_Dataset[Assignment_Dataset$`Country Name` == "New Zealand", ]

# Exclude unnecessary columns
fertility_ds <- fertility_ds[, -c(1, 2, 4)]  

# Print the extracted and modified data to verify
print(fertility_ds)

# Pivot the data from wide to long format
fertility_fds <- fertility_ds %>%
  pivot_longer(
    cols = -`Indicator Name`,  # Exclude the Indicator Name from the pivoting process
    names_to = "Year",
    values_to = "Fertility_Rate"
  ) %>%
  select(-`Indicator Name`)  # Remove the Indicator Name column from the final output

# Print the reshaped data to check
print(fertility_fds)

# Remove rows where Year is 2022 or 2023
fertility_fds <- fertility_fds[!(fertility_fds$Year %in% c(2022, 2023)), ]

# Print the updated dataset to verify the changes
print(fertility_fds)

# Convert the data into a time series
fertility <- ts(fertility_fds$Fertility_Rate, start=1960, frequency=1)

#-----------------------------------------Plot Time Series Plot-----------------------------------------#

# Plot the time series
plot(fertility, xlab="Year", ylab="Fertility Rate (Total Births per Woman)",
     main="Fertility Rates in New Zealand from 1960 to 2021", type='l')

# Adding a custom x-axis to the time series plot 
axis(1, at = seq(0, length(fertility_fds$Year)-1, by = 10),
     labels = seq(1960, 2021, by = 10))

#---------------------------------Statistical test for Trend Component----------------------------------#

# Perform the Mann-Kendall Trend Test to check for the presence of the trend component
# H0: Trend component is not present in the series 
# H1: Trend component is present in the series 
# Reject H0 if the p-value is less than 0.05

# Perform Mann-Kendall test
MannKendall(fertility)

# Since the p-value (3.4338e-12) is less than 0.05, we reject the null hypothesis. There is 
# sufficient evidence to conclude that the trend component is present in the time series
# at 5% level of significance. 

#---------------------------------------------Split Dataset-----------------------------------------------#

# Split the dataset into training and testing dataset 
train_fertility <- fertility[1:(0.7*length(fertility))]
test_fertility <- fertility[-c(1:(0.7*length(fertility)))]

# Convert the training and testing dataset into time series again 
train_fertility <- ts(train_fertility)
test_fertility <- ts(test_fertility)

# Check iif the conversion was successful 
print(train_fertility)
print(test_fertility)

#---------------------------------------Holt's Linear Trend Method----------------------------------------#

# Fit the Holt's linear trend model to the training data
holt_model <- holt(train_fertility, h = length(test_fertility))

# Generate forecasts for the length of the test set
holt_forecast <- forecast(holt_model, h = length(test_fertility))

# Print the model summary
summary(holt_model)

# Determine the range of fertility rates to set the y-axis limits
y_limits <- range(c(fertility, holt_forecast$mean), na.rm = TRUE)

# Adjust the plot to show years starting from 1960 instead of 0
years <- 1960 + seq_along(fertility) - 1
plot(holt_forecast, ylim = y_limits, main="Fertility Rates in New Zealand (Holt's Model)", xlab="Year", 
     ylab="Fertility Rate (Births per Woman)", xaxt='n')
lines(fertility, col="black", lwd=2)  # Overlay the complete historical data
lines(fitted(holt_model), col="red", lwd=2)  # Overlay the fitted values from the training data

# Add a legend to differentiate the data
legend("bottomleft", legend=c("Historical Data", "Fitted Values", "Forecasted Values"), 
       col=c("black", "red", "blue"), lty=1, lwd=2, cex=0.8)

# Specify x-axis ticks to reflect every decade starting from 1960
axis(1, at=seq(1, length(fertility), by=10), labels=years[seq(1, length(fertility), by=10)])

#----------------------------------Simple Exponential Smoothing (SES)-----------------------------------#

# Fit the Simple Exponential Smoothing model to the training data
ses_model <- ses(train_fertility, h = length(test_fertility))

# Print the model summary
print(summary(ses_model))

# Generate forecasts
ses_forecast <- forecast(ses_model)

# Determine the range of fertility rates to set the y-axis limits
y_limits_ses <- range(c(fertility, ses_forecast$mean), na.rm = TRUE)

# Adjust the plot to show years starting from 1960 instead of 0
years <- 1960 + seq_along(fertility) - 1
plot(ses_forecast, ylim = y_limits_ses, main="Fertility Rates in New Zealand (SES Method)", xlab="Year", 
     ylab="Fertility Rate (Births per Woman)", xaxt='n')
lines(fertility, col="black", lwd=2) # Overlay the complete historical data
lines(fitted(ses_model), col="red", lwd=2) # Overlay the fitted values from the training data

# Add a legend to differentiate the data
legend("topright", legend=c("Historical Data", "Fitted Values", "Forecasted Values"), 
       col=c("black", "red", "dodgerblue"), lty=1, lwd=2, cex=0.8)

# Specify x-axis ticks to reflect every decade starting from 1960
axis(1, at=seq(1, length(fertility), by=10), labels=years[seq(1, length(fertility), by=10)])

#----------------------------------------------Cubic Model----------------------------------------------#

# Prepare the training data with both squared and cubic terms
train_data <- data.frame(year = 1960:(1960 + length(train_fertility) - 1), fertility = train_fertility)
train_data$year_squared <- train_data$year^2
train_data$year_cubed <- train_data$year^3

# Fit a cubic model to the training data
cubic_model <- lm(fertility ~ year + I(year^2) + I(year^3), data=train_data)

# Generate fitted values for the training data
train_data$fitted_values <- predict(cubic_model, newdata=train_data)

# Prepare test data for forecasting, include squared and cubic terms
test_data <- data.frame(year = (1960 + length(train_fertility)):(1960 + length(fertility) - 1))
test_data$year_squared <- test_data$year^2
test_data$year_cubed <- test_data$year^3

# Generate forecasted values and prediction intervals for the testing data
pred_80 <- predict(cubic_model, newdata=test_data, interval="prediction", level=0.80)
pred_95 <- predict(cubic_model, newdata=test_data, interval="prediction", level=0.95)

# Extract forecasted values and intervals
test_data$forecasted_values <- pred_95[, "fit"]
test_data$lwr_80 <- pred_80[, "lwr"]
test_data$upr_80 <- pred_80[, "upr"]
test_data$lwr_95 <- pred_95[, "lwr"]
test_data$upr_95 <- pred_95[, "upr"]

# Plot the fitted and forecasted results with prediction intervals for the testing data
plot(1960:(1960 + length(fertility) - 1), fertility, type='l', col='black', 
     main="Fertility Rates in New Zealand (Cubic Model)", xlab="Year", 
     ylab="Fertility Rate (Births per Woman)", 
     ylim=range(c(fertility, train_data$fitted_values, test_data$forecasted_values, 
                  test_data$lwr_95, test_data$upr_95)), xaxt='n')
lines(train_data$year, train_data$fitted_values, col='red', lwd=2)  # Fitted values in red
lines(test_data$year, test_data$forecasted_values, col='blue', lwd=2, lty=2)  # Forecasted values in blue

# Add 95% prediction intervals
polygon(c(test_data$year, rev(test_data$year)), c(test_data$upr_95, rev(test_data$lwr_95)), 
        col=adjustcolor("grey", alpha.f=0.5), border=NA)

# Add 80% prediction intervals
polygon(c(test_data$year, rev(test_data$year)), c(test_data$upr_80, rev(test_data$lwr_80)), 
        col=adjustcolor("lightblue", alpha.f=0.5), border=NA)

# Add a legend to differentiate the data
legend("topright", legend=c("Historical Data", "Fitted Values", "Forecasted Values"), 
       col=c("black", "red", "blue"), lty=c(1, 1, 2, NA, NA), lwd=2, pch=c(NA, NA, NA, 15, 15), cex=0.8)

# Specify x-axis ticks to reflect every decade starting from 1960
axis(1, at=seq(1960, 2021, by=10), labels=seq(1960, 2021, by=10))

# Double check to see if the plots are accurate and informative
print(train_data)
print(test_data)

#---------------------------------Accuracy for Holt's Linear Trend Model---------------------------------#
# Calculate accuracy metrics
holt_accuracy <- accuracy(holt_forecast, test_fertility)
print(holt_accuracy)

#--------------------------------------------Accuracy for SES--------------------------------------------#
# Calculate accuracy metrics
ses_accuracy <- accuracy(ses_forecast, test_fertility)
print(ses_accuracy)

#-----------------------------------------Accuracy for Cubic Model---------------------------------------#
# Calculate accuracy metrics manually for the cubic model
cubic_mae <- mean(abs(test_fertility - test_data$forecasted_values))
cubic_rmse <- sqrt(mean((test_fertility - test_data$forecasted_values)^2))

# Print the accuracy metrics
cat("Cubic Model Accuracy:\n")
cat("MAE:", cubic_mae, "\n")
cat("RMSE:", cubic_rmse, "\n")

#------------------------------------------Check for Stationarity----------------------------------------#

# Plot the ACF plot with title
acf(fertility, main="ACF Plot (Initial Data)")

# Plot the PACF plot with title 
pacf(fertility, main="PACF Plot (Initial Data)")

#--------------------------------------Unit Root Test (Initial Data)------------------------------------#

# Using the adf.test function to identify if the fertility data is stationary or non-stationary on the 
# initial data
adf.test(fertility)
# H0: The time series is not stationary
# H1: The time series is stationary 
# Reject H0 if the p-value is less than 0.05
# Since the p-value in the ADF test (0.1401) is greater than 0.05, we do not reject the null hypothesis, 
# hence we conclude that the data is not stationary.

#----------------------Kwiatkowski–Phillips–Schmidt–Shin (KPSS) test (Initial Data)---------------------#

# Perform KPSS test for trend stationarity on the initial data 
kpss_result <- kpss.test(fertility, null = "Trend")

# Print the results
print(kpss_result)
# H0: The time series is trend stationary
# H1: The time series is not trend stationary
# Reject H0 if the p-value is less than 0.05
# Since the p-value is less than 0.05, we reject the null hypothesis and conclude that the series is 
# likely not trend stationary, meaning that it exhibits characteristics of a unit root or some form 
# of non-stationarity in the presence of a deterministic trend.

#----------------------------------------------ndiffs Function--------------------------------------------#
# To check what is the recommended differencing order. 
ndiffs(fertility)
# 2 

#---------------------------------------After First Order Differencing-------------------------------------#

# Unit Root Test 
# Check the ADF test by performing the first order differencing to the dataset. 
adf.test(diff(fertility,1))
# H0: The time series is not stationary
# H1: The time series is stationary 
# Reject H0 if the p-value is less than 0.05
# Since the p-value in the ADF test (0.107) is greater than 0.05, we do not reject the null hypothesis, 
# hence we conclude that the data is not stationary. The second order differencing is required. 

# KPSS Test 
# Check the KPSS test by performing the first order differencing to the dataset.
kpss.test(diff(fertility, 1), null = "Trend")
# H0: The time series is trend stationary
# H1: The time series is not trend stationary
# Reject H0 if the p-value is less than 0.05
# Since the p-value is less than 0.05, we reject the null hypothesis and conclude that the series is 
# likely not trend stationary, meaning that it exhibits characteristics of a unit root or some form 
# of non-stationarity in the presence of a deterministic trend.

#---------------------------------------After Second Order Differencing-------------------------------------#

# Unit Root Test
# Second order differencing
adf.test(diff(diff(fertility,1),1))
# H0: The time series is not stationary
# H1: The time series is stationary 
# Reject H0 if the p-value is less than 0.05
# Now, the p-value is less than 0.05. Hence we reject the null hypothesis and conclude that the time 
# series data is now stationary. 

# KPSS
# Check the KPSS test by performing the second order differencing to the dataset.
kpss.test(diff(diff(fertility, 1), 1), null = "Trend")
# H0: The time series is trend stationary
# H1: The time series is not trend stationary
# Reject H0 if the p-value is less than 0.05
# Since the p-value is 0.1, which is greater than 0.05, we do not reject the null hypothesis and conclude 
# that the series is now trend stationary. 

#---------------------------------------------Model Suggestion-------------------------------------------#

# Model suggestion based on Box-Jenkins Methodology
# Show the data patterns in ACF plot for the second order differencing with title
acf(diff(diff(fertility,1),1), main="ACF Plot (Second Order Differencing)")

# Show the data patterns in PACF plot for the second order differencing with title
pacf(diff(diff(fertility,1),1), main="PACF Plot (Second Order Differencing)")
# Both plots suggests the ARIMA(1,2,1) model

# Check the suggestion by auto.arima() 
auto.arima(fertility, trace=TRUE)
# ARIMA(0,2,1)

#---------------------------------------Summary Outputs of ARIMA models------------------------------------#

# Estimate the ARIMA(1,2,1) model 
arima_fertility_121 <-Arima(fertility,order=c(1,2,1))

# Summary output of ARIMA(1,2,1) model 
summary(arima_fertility_121)

# Estimate the ARIMA(0,2,1)
arima_fertility_021 <-Arima(fertility,order=c(0,2,1))

# Summary output of ARIMA(0,2,1) model 
summary(arima_fertility_021)

#-----------------------------------------------Model Adequacy---------------------------------------------#

# Model adequacy of ARIMA(1,2,1) model
checkresiduals(arima_fertility_121)
# H0: The model is adequate
# H1: The model is inadequate 
# Reject H0 if p-value is less than 0.05
# Since the p-value(0.3139) is greater than 0.05, we do not reject the null hypothesis. There is 
# insufficient evidence to conclude that the model is inadequate at 5% level of significance. 

# Model adequacy of ARIMA(0,2,1) model
checkresiduals(arima_fertility_021)
# H0: The model is adequate
# H1: The model is inadequate 
# Reject H0 if p-value is less than 0.05
# Since the p-value(0.09844) is greater than 0.05, we do not reject the null hypothesis. There is 
# insufficient evidence to conclude that the model is inadequate at 5% level of significance.

#----------------------------------------Significance of Coefficients--------------------------------------#

# Coefficient significance of ARIMA(1,2,1) model
coeftest(arima_fertility_121)
# From the summary output, the ar1 parameter is the only parameter that is insignificant. ma1 on the other 
# hand was found to be a significant parameter. 

# Coefficient significance of ARIMA(0,2,1) model
coeftest(arima_fertility_021)
# From the summary output, the ma1 parameter was found to be a significant parameter. 

#-----------------------------------------------Model Accuracy---------------------------------------------#

# Model accuracy of ARIMA(1,2,1) model
accuracy(arima_fertility_121)
# MAE: 0.06422504
# RMSE: 0.07779877

# Model accuracy of ARIMA(0,2,1) model
accuracy(arima_fertility_021)
# MAE: 0.06404357
# RMSE: 0.0785315

#-----------------------------------------------Generate Forecast-------------------------------------------#

# Generate the forecast for the next 10 years
forecast_fertility <- forecast(arima_fertility_021, h=10)
forecast_fertility

plot(forecast_fertility, main="Forecast of New Zealand's Fertility Rate in the Next 10 Years", xlab="Year", 
     ylab="Fertility Rate")
lines(forecast_fertility$fitted, col=2, lwd=2)
legend("topright", c("Actual", "ARIMA(0,2,1)", "Forecast"), col=c(1,2,4), lwd=2, cex=0.8)
