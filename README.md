# New Zealand’s Fertility Rates Unveiled: A Time Series Forecasting Approach

## 📚 Introduction

Fertility rates in New Zealand have experienced significant changes from 1960 to 2021, reflecting broader social and economic shifts. Using data from The World Bank, this project examines the total fertility rate, which represents the average number of children a woman would have during her reproductive years based on age-specific fertility rates of a given year. To forecast future fertility patterns, several time series forecasting methods are applied, with all analyses conducted using the R programming language. 

## 🗒️ Task Overview

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

<div align="center">

    Simple Exponential Smoothing Model

</div>
  
  ![Screenshot 2024-10-22 001904](https://github.com/user-attachments/assets/6a0d39d8-dce2-45ef-bdb3-6037d07924cb)

  
<div align="center">
  
    Holt's Linear Trend Model

</div>

  ![Screenshot 2024-10-22 001916](https://github.com/user-attachments/assets/c092b5d7-93d1-4eb3-ba04-ae67034abc95)
  

  <div align="center">

    Cubic Trend Model

  </div>
  
  ![Screenshot 2024-10-22 001925](https://github.com/user-attachments/assets/443187c4-eb9f-4079-85bd-ed94a77ae80d)

#### 🔶 Identify two measures of forecast errors, evaluate the statistics for each method, and justify the most appropriate forecasting method.

    The two prediction error measures used are Mean Absolute Error (MAE) and Root Mean Square Error (RMSE):

    👉 MAE: MAE averages absolute errors, making it easy for non-technical stakeholders to understand. It treats all errors equally, which is important when every forecasting error could have a significant impact, ensuring no error is over- or under-emphasized.

    👉 RMSE: RMSE is more sensitive to larger errors by squaring them, which is crucial when forecasting critical variables like fertility rates. It helps identify big mistakes that can lead to planning issues in sectors like healthcare and education.

    👉 Combining Both: MAE gives a straightforward view of overall model accuracy, while RMSE highlights large errors. Together, they provide a complete picture of model performance, balancing average accuracy with the severity of outliers.


    ∴ The Cubic Trend model was found to be the most suitable, with the lowest RMSE (0.1767227) and MAE (0.1405531) values.
      
#### 🔶 Conduct autocorrelation analysis and check for stationarity. If not stationary, transform the series and support with statistical tests.

  ![Screenshot 2024-10-22 003711](https://github.com/user-attachments/assets/091fba6b-4a20-4992-a339-e8165807b1f0)
  
  ![Screenshot 2024-10-22 003718](https://github.com/user-attachments/assets/1966d2ce-90ad-40af-8c43-36b90302124a)

    The ACF plot shows a slow decline, indicating a non-stationary time series, likely due to a trend. 

    The PACF plot reveals a significant drop after the first lag, suggesting an autoregressive component of order 1 (AR(1)). This implies that an AR(1) model may be appropriate for capturing dependencies.


    To confirm, the Unit Root and KPSS tests were performed:

    👉 Unit Root Test: The p-value (0.1401) exceeds 0.05, meaning the null hypothesis is not rejected, and there is insufficient evidence to claim the series is stationary.

    👉 KPSS Test (Trend Stationarity): The p-value (0.01) is below 0.05, leading to the rejection of the null hypothesis, indicating that the series is not trend stationary.


    Based on these results, the ndiffs() function recommended second-order differencing to achieve stationarity. First-order differencing was performed, but the time series remained non-stationary (p-values: 0.107 for Unit Root and 0.03287 for KPSS), requiring second-order differencing. After applying it, the series became stationary and trend stationary, as confirmed by p-values of 0.01 (Unit Root) and 0.1 (KPSS). 

    
    ∴ Second-order differencing was necessary to make the New Zealand fertility rate series stationary.

#### 🔶 Develop two ARIMA or SARIMA models based on the analysis and describe the behavior of ACF and PACF plots. 

  ![Screenshot 2024-10-22 015826](https://github.com/user-attachments/assets/909dd5b8-fb86-4994-b365-b4a1be6fe391)
  
  ![Screenshot 2024-10-22 015835](https://github.com/user-attachments/assets/5b8a9ac5-6106-4350-934b-fb3c5bafc187)

    The ACF and PACF plots after applying second-order differencing show an exponential decay pattern. While there is a drop after the first lag in both plots, it is not drastic, and the subsequent lags don't hover near zero, confirming an exponential pattern. Based on these findings, the Box-Jenkins Methodology suggests an ARIMA(1,2,1) model.

    To explore further, the auto.arima() function was used, identifying ARIMA(0,2,1) as the best model, with the lowest AICc value of -128.1283. The second-best model, ARIMA(1,2,1), had an AICc value of -126.8624, aligning with the earlier Box-Jenkins suggestion. 
    
    
    ∴ The two recommended models are ARIMA(1,2,1) and ARIMA(0,2,1).

#### 🔶 Provide summaries, model equations, and assess model adequacy of the two models developed.

                                            Output summary for the ARIMA (1,2,1) model
  
  ![Screenshot 2024-10-22 020014](https://github.com/user-attachments/assets/12d57c45-f46c-46d1-b560-f7fc20c0e777)


                                                Output summary for the ARIMA(0,2,1) model
  
  ![Screenshot 2024-10-22 020006](https://github.com/user-attachments/assets/861db331-ddf8-42cd-89c1-d5c9bf52cd79)


                                            Model Equation for the ARIMA (1,2,1) model

![Screenshot 2024-10-22 104823](https://github.com/user-attachments/assets/09b2b060-62b2-4583-b050-4c8b164bb5e6)


                                            Model Equation  for the ARIMA(0,2,1) model
                                            
![Screenshot 2024-10-22 104830](https://github.com/user-attachments/assets/9cffd407-65b1-48fe-aafb-ef897065a665)

    To assess the adequacy of both models, the checkresiduals() function was used, focusing on two aspects: the Ljung-Box test and the ACF plot of the residuals.

    👉 Ljung-Box Test: The null hypothesis states that the residuals are random, indicating an adequate model. With p-values of 0.3139 for ARIMA(1,2,1) and 0.09844 for ARIMA(0,2,1), both are above 0.05, meaning the null hypothesis is not rejected.
  
    ∴ There is no evidence to suggest that either model is inadequate at the 5% significance level.
    

    👉 ACF Plot of Residuals: Both models’ ACF plots show that all autocorrelations are within the confidence bounds, and no bars exceed the significance thresholds, indicating no significant autocorrelation. 
    
    ∴ This suggests that the residuals behave as white noise, further supporting the adequacy of both models.

#### 🔶 Test the significance of model parameters at a 0.05 level and justify the results.

    To assess the significance of the coefficient parameters in both models, the coeftest() function from the "lmtest" package was used.
    
    
    ARIMA(1,2,1) Model:
    
    👉 AR1 Component: The null hypothesis suggests the AR1 component equals zero. With a p-value of 0.2944 (above 0.05), the null hypothesis cannot be rejected, indicating insufficient evidence to conclude that the AR1 component plays a significant role.
    
    👉 MA1 Component: The null hypothesis is that the MA1 component equals zero. With a p-value of 9.465e-14 (below 0.05), the null hypothesis is rejected, confirming that the MA1 component is significant at the 5% level.
    
    
    ARIMA(0,2,1) Model:
    
    👉 MA1 Component: The null hypothesis suggests the MA1 component equals zero. With a p-value of 3.049e-07 (below 0.05), the null hypothesis is rejected, confirming that the MA1 component is significant at the 5% significance threshold. 

#### 🔶 Calculate forecast errors for the developed ARIMA or SARIMA models.

    The MAE and RMSE values for the ARIMA(1,2,1) model are 0.06422504 and 0.07779877, while for the ARIMA(0,2,1) model, the values are 0.06404357 and 0.0785315. Although ARIMA(1,2,1) has a slightly lower RMSE, ARIMA(0,2,1) shows a lower MAE, suggesting better performance in reducing average errors. The small difference in RMSE does not justify the added complexity of the autoregressive term in ARIMA(1,2,1).
    
    Following the principle of parsimony, which favors simpler models with fewer assumptions when performance is comparable, ARIMA(0,2,1) is preferred. Its slightly better MAE indicates a more consistent reduction in errors, making it a more practical and robust choice for forecasting, with a lower risk of overfitting. 
    
    
    ∴ ARIMA(0,2,1) is the most suitable model.

#### 🔶 Use the most appropriate ARIMA or SARIMA model to forecast fertility rates for the next 10 years.

    Given that the ARIMA(0,2,1) model was identified as the most suitable model, forecast of New Zealand’s fertility rate in the next 10 years is thereby performed using the said model. 
  
![Screenshot 2024-10-22 015652](https://github.com/user-attachments/assets/f600dcd8-4f21-4eda-ac4f-d50b5de7775d)


