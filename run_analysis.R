library(dplyr)

#Read in features and activites data
features <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")

#Read in training data
x_train <- read.table("./x_train.txt")
y_train <- read.table("./y_train.txt")
subject_train <- read.table("./subject_train.txt")

#Read in test data
x_test <- read.table("./x_test.txt")
y_test <- read.table("./y_test.txt")
subject_test <- read.table("./subject_test.txt")


#rename variables
y_train <- rename(y_train, activityid = V1)
y_test <- rename(y_test, activityid = V1)
subject_train <- rename(subject_train, subjectID = V1)
subject_test <- rename(subject_test, subjectID = V1)

#add acivity variable
y_train$activity <- factor(y_train$activityid, levels=activity_labels$V1,
                                labels=activity_labels$V2)

y_test$activity <- factor(y_test$activityid, levels=activity_labels$V1,
                           labels=activity_labels$V2)

#rename X variables
names(x_train) <- features[,2]
names(x_test) <- features[,2]

#add Train or Test variable
x_train$datatype <- "Train"
x_test$datatype <- "Test"

#cbind y and subject
y_train <- cbind(y_train, subject_train)
y_test <- cbind(y_test, subject_test)

#cbind y and x
tidy_data_train <- cbind(y_train, x_train)
tidy_data_test <- cbind(y_test, x_test)

#rbind train and test
tidy_data <- rbind(tidy_data_train, tidy_data_test)


head(tidy_data$activity, n = 100)

#grep mean and std variables
formatted_tidy_data <- grep("activity|subject|mean|std", names(tidy_data), value = TRUE)
formatted_tidy_data
tidy_data <- tidy_data[,formatted_tidy_data]
tidy_data

write.table(tidy_data, "./tidy_data.txt", row.name=FALSE)

#group_by subject, activity. average remaining variables.
activity_subject_data <- tidy_data %>% 
        group_by(subjectID, activity) %>%
        summarise_each(funs(overallmean = mean))
write.table(activity_subject_data, "./activity_subject_data.txt", row.name=FALSE)


#########################################################