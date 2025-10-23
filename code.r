#1. load data
trafficdata_raw = read.table("aadt.txt", header = FALSE) #must place the csv file same level as this working file
View(trafficdata_raw)
dim(trafficdata_raw) #121   8

#2. Graphic display of the observed data
trafficdata = data.frame(
  y = trafficdata_raw$V1,
  X1 = trafficdata_raw$V2,
  X2 = trafficdata_raw$V3,
  X3 = trafficdata_raw$V4,
  X4 = trafficdata_raw$V5
)
#scatter plot matrix
plot(trafficdata)

#3. Modeling multiple linear regression with R
mlr = lm(y~X1+X2+X3+X4, data = trafficdata)
summary(mlr)


#4. Adequacy checking (From the viewpoint of the fitted model)

#4.1 Statistical tests for model adequacy

#extract summary statistics
mlr_summary <- summary(mlr)
cat("F-statistic and R-squared:\n")
cat("F-statistic:", mlr_summary$fstatistic[1], "on", 
    mlr_summary$fstatistic[2], "and", mlr_summary$fstatistic[3], "DF\n")
cat("p-value:", pf(mlr_summary$fstatistic[1], 
                   mlr_summary$fstatistic[2], 
                   mlr_summary$fstatistic[3], 
                   lower.tail = FALSE), "\n")
cat("Multiple R-squared:", mlr_summary$r.squared, "\n")
cat("Adjusted R-squared:", mlr_summary$adj.r.squared, "\n\n")

# t-tests for individual coefficients
cat("t-tests for individual coefficients:\n")
coefficients_table <- mlr_summary$coefficients
print(coefficients_table)

#interpretation of t-tests
cat("\nInterpretation of t-tests:\n")
for(i in 1:nrow(coefficients_table)) {
  predictor_name <- rownames(coefficients_table)[i]
  t_value <- coefficients_table[i, "t value"]
  p_value <- coefficients_table[i, "Pr(>|t|)"]
  
  significance <- ifelse(p_value < 0.001, "***",
                        ifelse(p_value < 0.01, "**",
                              ifelse(p_value < 0.05, "*",
                                    ifelse(p_value < 0.1, ".", " "))))
  
  cat(sprintf("H0: β_%s = 0: t = %.3f, p-value = %.4f %s\n", 
              ifelse(i==1, "0 (Intercept)", 
                     ifelse(predictor_name=="X1", "1", 
                            ifelse(predictor_name=="X2", "2", 
                                   ifelse(predictor_name=="X3", "3", "4")))), 
              t_value, p_value, significance))
}

#F-test for overall model significance
cat("\nOverall Model F-test:\n")
cat("H0: β1 = β2 = β3 = β4 = 0\n")
cat("H1: At least one βj ≠ 0\n")
f_pvalue <- pf(mlr_summary$fstatistic[1], 
               mlr_summary$fstatistic[2], 
               mlr_summary$fstatistic[3], 
               lower.tail = FALSE)
cat("F-statistic:", round(mlr_summary$fstatistic[1], 3), "\n")
cat("p-value:", format.pval(f_pvalue), "\n")

if(f_pvalue < 0.05) {
  cat("Conclusion: Reject H0 - The model is statistically significant.\n")
} else {
  cat("Conclusion: Fail to reject H0 - The model is not statistically significant.\n")
}

#R-squared interpretation
cat("\nR-squared Interpretation:\n")
cat("The model explains", round(mlr_summary$r.squared * 100, 1), 
    "% of the variance in AADT.\n")
cat("Adjusted R-squared (penalized for number of predictors):", 
    round(mlr_summary$adj.r.squared * 100, 1), "%\n")

#check if model simplification is needed
cat("\n=== Variable Significance Assessment ===\n")
significant_vars <- rownames(coefficients_table)[coefficients_table[, "Pr(>|t|)"] < 0.05]
non_significant_vars <- rownames(coefficients_table)[coefficients_table[, "Pr(>|t|)"] >= 0.05 & 
                                                     rownames(coefficients_table) != "(Intercept)"]

if(length(non_significant_vars) > 0) {
  cat("Potentially non-significant predictors (p ≥ 0.05):", 
      paste(non_significant_vars, collapse = ", "), "\n")
  cat("Consider removing these variables to simplify the model.\n")
} else {
  cat("All predictors are statistically significant at α = 0.05 level.\n")
}

if(length(significant_vars) > 1) { #excluding the intercept
  cat("Significant predictors:", 
      paste(significant_vars[significant_vars != "(Intercept)"], collapse = ", "), "\n")
}

#from the viewpoint of residuals 
#4.2.1
qqnorm(residuals(mlr),ylab ='Residuals',col="purple")
qqline(residuals(mlr))

#4.2.2
par(mfrow=c(1, 1))

# Plot residuals vs Time
plot(residuals(mlr), ylab='Residuals', xlab='Time')

# Plot residuals vs Fitted values
plot(residuals(mlr), fitted(mlr), ylab='Residuals', xlab='Fitted values')

# Plot residuals vs X1
plot(residuals(mlr), trafficdata$X1, ylab='Residuals', xlab='X1')

# Plot residuals vs X2
plot(residuals(mlr), trafficdata$X2, ylab='Residuals', xlab='X2')

# Plot residuals vs X3
plot(residuals(mlr), trafficdata$X3, ylab='Residuals', xlab='X3')


