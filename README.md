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

#### 🔶 Identify two measures of forecast errors, evaluate the statistics for each method, and justify the most appropriate forecasting method.

    The two prediction error measures used are Mean Absolute Error (MAE) and Root Mean Square Error (RMSE):

    👉 MAE:MAE averages absolute errors, making it easy for non-technical stakeholders to understand. It treats all errors equally, which is important when every forecasting error could have a significant impact, ensuring no error is over- or under-emphasized.

    👉 RMSE: RMSE is more sensitive to larger errors by squaring them, which is crucial when forecasting critical variables like fertility rates. It helps identify big mistakes that can lead to planning issues in sectors like healthcare and education.

    👉 Combining Both: MAE gives a straightforward view of overall model accuracy, while RMSE highlights large errors. Together, they provide a complete picture of model performance, balancing average accuracy with the severity of outliers.


    📌 The Cubic Trend model was found to be the most suitable, with the lowest RMSE (0.1767227) and MAE (0.1405531) values.
      
#### 🔶 Conduct autocorrelation analysis and check for stationarity. If not stationary, transform the series and support with statistical tests.

  ![Screenshot 2024-10-22 003711](https://github.com/user-attachments/assets/091fba6b-4a20-4992-a339-e8165807b1f0)
  
  ![Screenshot 2024-10-22 003718](https://github.com/user-attachments/assets/1966d2ce-90ad-40af-8c43-36b90302124a)

    The ACF plot shows a slow decline, indicating a non-stationary time series, likely due to a trend. 

    The PACF plot reveals a significant drop after the first lag, suggesting an autoregressive component of order 1 (AR(1)). This implies that an AR(1) model may be appropriate for capturing dependencies.


    To confirm, the Unit Root and KPSS tests were performed:

    👉 Unit Root Test: The p-value (0.1401) exceeds 0.05, meaning the null hypothesis is not rejected, and there is insufficient evidence to claim the series is stationary.

    👉 KPSS Test (Trend Stationarity): The p-value (0.01) is below 0.05, leading to the rejection of the null hypothesis, indicating that the series is not trend stationary.


    Based on these results, the ndiffs() function recommended second-order differencing to achieve stationarity. First-order differencing was performed, but the time series remained non-stationary (p-values: 0.107 for Unit Root and 0.03287 for KPSS), requiring second-order differencing. After applying it, the series became stationary and trend stationary, as confirmed by p-values of 0.01 (Unit Root) and 0.1 (KPSS). 

    
    📌 Thus, second-order differencing was necessary to make the New Zealand fertility rate series stationary.

#### 🔶 Develop two ARIMA or SARIMA models based on the analysis and describe the behavior of ACF and PACF plots. 

  ![Screenshot 2024-10-22 010752](https://github.com/user-attachments/assets/b03c337e-f42d-4568-83fd-8bcd2cfabfe0)

    The ACF and PACF plots after applying second-order differencing show an exponential decay pattern. While there is a drop after the first lag in both plots, it is not drastic, and the subsequent lags don't hover near zero, confirming an exponential pattern. Based on these findings, the Box-Jenkins Methodology suggests an ARIMA(1,2,1) model.

    To explore further, the auto.arima() function was used, identifying ARIMA(0,2,1) as the best model, with the lowest AICc value of -128.1283. The second-best model, ARIMA(1,2,1), had an AICc value of -126.8624, aligning with the earlier Box-Jenkins suggestion. 
    
    
    📌 Therefore, the two recommended models are ARIMA(1,2,1) and ARIMA(0,2,1).

#### 🔶 Provide summaries, model equations, and assess model adequacy of the two models developed.

                                            Output summary for the ARIMA (1,2,1) model
  
  ![Screenshot 2024-10-22 011218](https://github.com/user-attachments/assets/9747e2b1-4248-4e23-99ce-d40e58dda185)

                                                Output summary for the ARIMA(0,2,1) model
  
  ![Screenshot 2024-10-22 011226](https://github.com/user-attachments/assets/0f8693be-ad51-4fab-bbe4-88c32f0e68c3)



















Test the significance of model parameters at a 0.05 level and justify the results.
Calculate forecast errors for the developed ARIMA or SARIMA models.
Use the most appropriate ARIMA or SARIMA model to forecast fertility rates for the next 10 years.
