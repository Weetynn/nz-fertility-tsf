# New Zealand’s Fertility Rates Unveiled: A Time Series Forecasting Approach

## 📚 Introduction

Fertility rates in New Zealand have experienced significant changes from 1960 to 2021, reflecting broader social and economic shifts. Using data from The World Bank, this project examines the total fertility rate, which represents the average number of children a woman would have during her reproductive years based on age-specific fertility rates of a given year. To forecast future fertility patterns, several time series forecasting methods are applied, with all analyses conducted using the R programming language. 

## 🗒️ Project Tasks and their Respective Deliverables 

#### 🔶 Construct a time series plot for the chosen fertility rate data and comment on the pattern, identifying its components using statistical tests.

  ![Screenshot 2024-10-22 000027](https://github.com/user-attachments/assets/7d4d24d3-63a2-41f9-b171-0783758b8916)

    The time series plot shows a clear decline in the number of children born per woman in New Zealand from 1960 to 2021. Initially high in the 1960s, the rate drops sharply in earlier decades, then stabilizes to a lower, more variable pattern after the 1980s.

    The dominant feature is the long-term decreasing trend, with no evidence of cyclical patterns or seasonality due to the annual data frequency.

    The Mann-Kendall Trend test confirms the trend component, rejecting the null hypothesis with a p-value of 3.4338e-12, proving a significant trend at the 5% level.

- Choose three forecasting methods and provide detailed descriptions with reasons for your selection.

  

- Split the data into training (70%) and testing (30%) sets, calculate forecasts using the selected methods, and optimize parameters if necessary. Compare observed and forecast values.
Identify two measures of forecast errors, evaluate the statistics for each method, and justify the most appropriate forecasting method.
Conduct autocorrelation analysis and check for stationarity. If not stationary, transform the series and support with statistical tests.
Develop two ARIMA or SARIMA models based on the analysis and describe the behavior of ACF and PACF plots. Provide summaries, model equations, and assess model adequacy.
Test the significance of model parameters at a 0.05 level and justify the results.
Calculate forecast errors for the developed ARIMA or SARIMA models.
Use the most appropriate ARIMA or SARIMA model to forecast fertility rates for the next 10 years.
