#+ setup, include=FALSE
library(knitr)
library(DAAG)
library(MASS)
library(leaps)
library(car)
opts_chunk$set(fig.path='figure/silk-')

#'
# Fetch Data
qb_stats <- read.csv("../data/qb_stats.csv")

# Grab the college predictors
predictors <- c('height', 'weight', 'age', 'c_avg_cmpp', 'c_rate', 'c_pct', 'c_avg_inter', 'c_avg_tds', 'c_avg_yds', 'c_numyrs', 'c_avg_att')
college_stats = qb_stats[,predictors]

# Set the resopnse variables
cpct = qb_stats['completion_percentage']

# Generate clean data set
data.log.no_combine.for_cpct = data.frame(log(na.omit(cbind(cpct, college_stats)) + 0.1))

# Generate the linear model
lm.log.no_combine.cpct <- lm(formula = completion_percentage ~. ,data = data.log.no_combine.for_cpct)

# Find optimum linear regression model for cpct
step_reg.log.no_combine.cpct <- stepAIC(lm.log.no_combine.cpct, direction="both")
summary(step_reg.log.no_combine.cpct)
plot(step_reg.log.no_combine.cpct)
leaps.log.no_combine.cpct <- regsubsets(completion_percentage ~. ,data = data.log.no_combine.for_cpct, nbest=10)
subsets(leaps.log.no_combine.cpct, statistic="rsq")
cv.lm(df=data.log.no_combine.for_cpct, step_reg.log.no_combine.cpct, m=5) # 5 fold cross-validation