library(dplyr)

features <- read.table("features.txt")
colnames(features) <- c("Sno", "Feature")

activity <- read.table("activity_labels.txt")
colnames(activity) <- c("Identifier", "Activity")

subject_test <- read.table("./test/subject_test.txt")
colnames(subject_test) <- "Subject"

subject_train <- read.table("./train/subject_train.txt")
colnames(subject_train) <- "Subject"

x_test <- read.table("./test/X_test.txt")
colnames(x_test) <- features$Feature

x_train <- read.table("./train/X_train.txt")
colnames(x_train) <- features$Feature

y_test <- read.table("./test/y_test.txt")
colnames(y_test) <- "Identifier"

y_train <- read.table("./train/y_train.txt")
colnames(y_train) <- "Identifier"

#merging training and test data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
data <- cbind(subject, y_data, x_data)

#extracting mean and std for each 
data <- data %>%
  select(Subject, Identifier, contains("mean"), contains("std"))

#adding descriptive names to name the activities
data$Identifier <- activity[data$Identifier, 2]

#labeling the data set
names(data)[2] <- "Activity"
names(data) <- gsub("^t", "Time", names(data))
names(data) <- gsub("^f", "Frequency", names(data))
names(data) <- gsub("Acc", "Acceleration", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))
names(data) <- gsub("mean()", "Mean", names(data), ignore.case = TRUE)
names(data) <- gsub("std()", "StandardDeviation", names(data), ignore.case = TRUE)
names(data) <- gsub("freq()", "Frequency", names(data), ignore.case = TRUE)

#creating independent data set
output <- data %>% 
  group_by(Subject, Activity) %>%
  summarise_all(funs(mean))

write.table(output, "TidyData.txt", row.names = FALSE)
