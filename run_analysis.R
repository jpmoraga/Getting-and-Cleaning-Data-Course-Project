setwd("C:/Users/JP/Desktop/Data Science Cert/3.- Getting and Cleaning Data/WD")

train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
## Activities
train[,562] <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
## Subjects selected for training
train[,563] <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
## Activities
test[,562] <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
## Subjects selected for testing
test[,563] <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

activity <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

## Merge training and test sets together
Total <- rbind(train,test)

## Getting only the columns of mean and std
cols <- grep(".*Mean.*|.*-mean.*|.*Std.*|.*-std.*", features[,2])

## Subseting the features we want
features <- features[cols,]

## Adding the subject and activity columns
cols <- c(cols, 562, 563)

## Removing the rest of the columns from the Total
Total <- Total[,cols]

## Add the column names
colnames(Total) <- c(as.vector(features$V2), "Id_Activity", "Subject")

## Adding the activity names
colnames(activity) <- c("Id_Activity","Activity")
Total <- merge(x = Total, y = activity, by = "Id_Activity", all.x = TRUE)

Total$Subject <- as.factor(Total$Subject)

## Aggregating by activity and subject
tidy <- aggregate(Total, by=list(activity = Total$Activity, subject = Total$Subject), mean)

# Remove the Subject and Activity column
tidy[,89] = NULL
tidy[,90] = NULL

write.table(tidy, "tidy.txt", sep="\t")