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