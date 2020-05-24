library(dplyr)
filename <- "Project_data.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename,)
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
## Assigning all the data frames
features <- read.table("UCI HAR Dataset/features.txt", colnames = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", colnames = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", colnames = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", colnames = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", colnames = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", colnames = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", colnames = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", colnames = "code")

## Merging the training and test data set
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

# We take the measurements on the mean and standard deviation
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
TidyData$code <- activities[TidyData$code, 2]
## We approximately name the columns of the tidy data
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

## Finally let's make the tidy data table with the average for each variable for each activity and subject
FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "tidy_data.txt", row.name=FALSE) ## Write tidy data to a new text file

