# README: MH3510 Regression Analysis Group Project

## Project Overview

This project analyzes traffic monitoring data to build a multiple linear regression model predicting Average Annual Daily Traffic (AADT) using road and demographic characteristics. The analysis follows comprehensive regression modeling procedures with thorough diagnostic checking and model refinement.

## Data Description

The dataset `aadt.txt` contains traffic monitoring data with 121 observations and 8 variables (using first 5 columns):

- **y (AADT)**: Average Annual Daily Traffic (response variable)
- **X1**: Population of county where road section is located
- **X2**: Number of lanes in road section
- **X3**: Width of road section (in feet)
- **X4**: Access control (categorical: 1=access control, 2=no access control)

## Analysis Workflow

### 1. Initial Data Exploration

- Scatter plot matrix revealed no strong linear relationships between individual predictors and response
- Variables X2 and X4 are discrete, X3 shows "stepped" patterns due to standard engineering widths
- Data exhibits clustering due to limited distinct values in predictors

### 2. Initial Multiple Linear Regression

**Model:** `y ~ X1 + X2 + X3 + X4`

**Key Results from PDF:**

- R-squared: 0.7527 (75.3% variance explained)
- Adjusted R-squared: 0.7442
- F-statistic: 88.29, p-value: < 2.2e-16 (model statistically significant)
- Significant predictors: X1 (p < 0.0001), X2 (p < 0.0001), X4 (p < 0.0001)
- Non-significant predictor: X3 (p = 0.4213)

### 3. Model Adequacy Checking

#### Residual Diagnostics Identified Issues:

- **Non-normality**: S-shaped Q-Q plot with heavy right tail
- **Heteroscedasticity**: Cone-shaped pattern in residuals vs fitted values
- **Autocorrelation**: Durbin-Watson test (DW = 1.3137, p = 3.101e-05)
- **Time-dependent structure**: Residual spike around observations 60-70

#### Variable Transformations Tested:

1. **Model 1**: `log(y) ~ X1 + X2 + log(X3) + factor(X4)` - R² = 0.741
2. **Model 2**: `log(y) ~ X1 + X2 + poly(X3,2) + factor(X4)` - R² = 0.741
3. **Model 3**: `log(y) ~ X1 + X2 + X3 + factor(X4)` - R² = 0.7411
4. **Model 4**: `log(y) ~ log(X1) + X2 + X3 + factor(X4)` - R² = 0.7982 ✓

### 4. Final Model Selection

**Selected Model:** `log(y) ~ log(X1) + X2 + factor(X4)`

**Justification from PDF:**

- Highest explanatory power (R² = 0.7982, Adj. R² = 0.793)
- X3 found statistically insignificant (p = 0.7905) and removed via F-test
- F-test for X3 removal: F = 0.0709, p-value = 0.7905
- Principle of parsimony: Simpler model with better adjusted R²

**Final Model Statistics from PDF:**

- Residual standard error: 0.723 on 117 degrees of freedom
- Multiple R-squared: 0.7982
- Adjusted R-squared: 0.793
- F-statistic: 154.2, p-value: < 2.2e-16

### 5. Robust Inference

Due to residual autocorrelation and heteroscedasticity, used Heteroscedasticity and Autocorrelation Consistent (HAC) Robust Standard Errors for valid inference.

**Final Coefficient Estimates with HAC Robust SE from PDF:**

- Intercept: 2.155 (p = 0.002776)
- log(X1): 0.463 (p < 0.001)
- X2: 0.586 (p < 0.001)
- X4_factorControl: -0.651 (p < 0.001)

### 6. Prediction

For specified values: X1 = 50,000, X2 = 3, X4 = 2 (no access control)

**Prediction Results:**

- Point estimate: 7,509 vehicles/day
- 95% Prediction interval: [1,714, 32,891] vehicles/day

## Key Findings

1. **Population Effect**: 1% increase in county population → 0.46% increase in AADT
2. **Lane Effect**: Each additional lane → ~80% increase in AADT (e^0.586 ≈ 1.80)
3. **Access Control**: Roads with access control have ~48% lower AADT than uncontrolled roads
4. **Road Width**: Not statistically significant predictor of AADT

## Model Validation

### Influence Analysis:

- Cook's distance identified 4 influential points (rows 18, 58, 92, 93)
- Sensitivity analysis showed model robustness - core conclusions unchanged
- Decision to retain all data points for comprehensive representation

### Residual Diagnostics:

- Q-Q plot showed good normality in middle quantiles with minor heavy-tailed behavior
- Residual vs fitted values plot showed no fanning pattern (heteroscedasticity resolved)
- Durbin-Watson test still indicated mild autocorrelation (DW = 1.6277, p = 0.01139)

## R Packages Required

- `lmtest` - for Durbin-Watson test
- `moments` - for skewness calculation
- `ggplot2` - for enhanced visualization
- `sandwich` - for robust standard errors

## File Structure

- `aadt.txt` - Raw data file
- Complete R code provided at the end of the submitted document
- Project follows structured regression analysis methodology

This project demonstrates a comprehensive regression modeling approach with thorough diagnostic checking, appropriate variable transformations, and robust statistical inference to address real-world traffic prediction challenges.
