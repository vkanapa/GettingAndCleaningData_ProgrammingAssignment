# Set working directory to be the unzipped UCI Har Dataset 
library("reshape2")
# Load the activities and features data
activities <- read.table("activity_labels.txt")
activities[,2] <- as.character(activities[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

req_features <- grep(".*mean.*| .*std.*", features[,2])
req_features.names <- features[req_features, 2]
req_features.names = gsub('-mean', 'Mean', req_features.names)
req_features.names = gsub('-std', 'Std', req_features.names)
req_features.names <- gsub('[- () ]' , '', req_features.names)


# loading test and train datasets

train <- read.table("train/X_train.txt")[req_features]
trainActivities <- read.table("train/Y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)


test <- read.table("test/X_test.txt")[req_features]
testActivities <- read.table("test/Y_test.txt")
testSubjects <- read.table("test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

#merge train and test datasets row-wise

Data <- rbind(test, train)
colnames(Data) <- c("Subject", "Activity" , req_features.names)

#converting Activities and Subjects to factor variables
Data$Activity <- factor(Data$Activity, levels = activities[,1], labels = activities[,2])
Data$Subject <- as.factor(Data$Subject)

Melted_Data <- melt(Data, id= c("Subject", "Activity"))
Melted_Data.mean <- dcast(Melted_Data , Subject+Activity ~ variable, mean)

write.table(Melted_Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)


