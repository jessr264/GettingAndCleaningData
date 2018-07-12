
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="activity.zip")
unzip("activity.zip")

#import activity labels and features.
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)
colnames(activity_labels) <- c("activity", "activity_name")
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)

#Extracts only the measurements on the mean and standard deviation for each measurement.
meansd <- grep(".*mean.*|.*std.*", features[,2])
meansdnames <- features[meansd,2]
meansdnames <- gsub('[-()]', '', meansdnames)

#import the datasets
#training set
train <- read.table("UCI HAR Dataset/train/X_train.txt")[meansd]
trainlabels <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubjects, trainlabels, train)
#test set
test <- read.table("UCI HAR Dataset/test/X_test.txt")[meansd]
testlabels <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testsubjects, testlabels, test)

# merge datasets
all <- rbind(train, test)
#name variables
colnames(all) <- c("subject", "activity", meansdnames)
all <- merge(all, activity_labels, "activity")
#rerorder variables
all <- all[, c(2, 1, 82, 3:81)]


#summarise
library(dplyr)
averages <- all %>% 
  select(-activity) %>%
  group_by(subject, activity_name) %>%
  summarise_all(funs(mean))

#output
write.table(averages, "tidy_averages.txt", row.names = TRUE)




