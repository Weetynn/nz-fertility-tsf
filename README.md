# New Zealand’s Fertility Rates Unveiled: A Time Series Forecasting Approach

## 📚 Introduction

Fertility rates in New Zealand have experienced significant changes from 1960 to 2021, reflecting broader social and economic shifts. Using data from The World Bank, this project examines the total fertility rate, which represents the average number of children a woman would have during her reproductive years based on age-specific fertility rates of a given year. To forecast future fertility patterns, several time series forecasting methods are applied, with all analyses conducted using the R programming language. 

## 🗒️ Project Tasks and their Respective Deliverables 

#### 🔶 Construct a time series plot for the chosen fertility rate data and comment on the pattern, identifying its components using statistical tests.

  ![Screenshot 2024-10-22 000027](https://github.com/user-attachments/assets/7d4d24d3-63a2-41f9-b171-0783758b8916)

    The time series plot shows a clear decline in the number of children born per woman in New Zealand from 1960 to 2021. Initially high in the 1960s, the rate drops sharply in earlier decades, then stabilizes to a lower, more variable pattern after the 1980s.

    The dominant feature is the long-term decreasing trend, with no evidence of cyclical patterns or seasonality due to the annual data frequency.

    The Mann-Kendall Trend test confirms the trend component, rejecting the null hypothesis with a p-value of 3.4338e-12, proving a significant trend at the 5% level.

#### 🔶 Choose three forecasting methods and provide detailed descriptions with reasons for your selection.

    The three forecasting methods chosen are Simple Exponential Smoothing (SES), Holt’s Linear Trend model, and the Cubic Trend model.

    👉 SES smooths the data and is best for series without significant trends or seasonality. Although the data has a trend, SES was chosen for its simplicity as a baseline to compare against more complex models.

    👉 Holt’s Linear Trend model builds on SES by incorporating both level and trend components, making it suitable for data with trends. Given the trend in the fertility data, Holt’s model was chosen to handle both level and trend adjustments in the forecast.

    👉 A polynomial regression model, the Cubic Trend model captures non-linear trends using quadratic and cubic terms. Its ability to handle complex patterns makes it ideal for forecasting New Zealand’s fertility rates, which follow a cubic trajectory.

#### 🔶 Split the data into training (70%) and testing (30%) sets, calculate forecasts using the selected methods, and optimize parameters if necessary. Compare observed and forecast values.

      Simple Exponential Smoothing model
  
  ![Screenshot 2024-10-22 001904](https://github.com/user-attachments/assets/6a0d39d8-dce2-45ef-bdb3-6037d07924cb)
  
      Holt's Linear Trend model

  ![Screenshot 2024-10-22 001916](https://github.com/user-attachments/assets/c092b5d7-93d1-4eb3-ba04-ae67034abc95)

      Cubic Trend model
  
  ![Screenshot 2024-10-22 001925](https://github.com/user-attachments/assets/443187c4-eb9f-4079-85bd-ed94a77ae80d)






  


Identify two measures of forecast errors, evaluate the statistics for each method, and justify the most appropriate forecasting method.
Conduct autocorrelation analysis and check for stationarity. If not stationary, transform the series and support with statistical tests.
Develop two ARIMA or SARIMA models based on the analysis and describe the behavior of ACF and PACF plots. Provide summaries, model equations, and assess model adequacy.
Test the significance of model parameters at a 0.05 level and justify the results.
Calculate forecast errors for the developed ARIMA or SARIMA models.
Use the most appropriate ARIMA or SARIMA model to forecast fertility rates for the next 10 years.
