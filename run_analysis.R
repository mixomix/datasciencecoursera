# this script requires you to be in the working directory of the data - via set.wd() command.
# That is the one where README.txt of the dataset is
library(dplyr)

#initial load of files
feature_names <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

train <- read.table("train/x_train.txt")
train_labels <- read.table("train/y_train.txt")
train_subject <- read.table("train/subject_train.txt")

test <- read.table("test/x_test.txt")
test_labels <- read.table("test/y_test.txt")
test_subject <- read.table("test/subject_test.txt")


# naming
names(train) <- name_list$V2
names(test) <- name_list$V2

names(train_subject) <- "Subject"
names(test_subject) <- "Subject"

names(train_labels) <- "Activity_Id"
names(test_labels) <- "Activity_Id"

names(activity_labels) <- c("Activity_Id","Activity_Label")

# joining of data
train_whole <- cbind(train,train_subject,train_labels)
test_whole <- cbind(test,test_subject,test_labels)

all_data <- rbind(train_whole,test_whole)

# mean and standard deviation data
md_data <- all_data[, grepl( "std\\(\\)|mean\\(\\)|Activity_Id|Subject" , names( all_data )) ]

# add activity names
final_data1 <- inner_join(md_data,activity_labels)

# drop Activity_Id column
final_data1<- final_data1[,!(names(final_data1) %in% "Activity_Id")]

# average of each variable for each activity and each subject
avg_groups <- group_by(final_data1, Activity_Label,Subject )
avgs <- summarise_each(avg_groups, funs(mean))

#prefix averaged columns names with "Average_"
colnames(avgs)[3:ncol(avgs)] <- paste0("Average_",colnames(avgs[3:ncol(avgs)]))

final_data2 <- avgs
