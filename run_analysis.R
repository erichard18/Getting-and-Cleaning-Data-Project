# Peer Graded Assignment: Getting and Cleaning Data

# Read features and activities
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])
activities <- read.table("activity_labels.txt")
activities[,2]<- as.character(activities[,2])

#get the mean and std
mean_std <- grep(".*mean.*|.*std.*", features[,2])
mean_std.names <- features[mean_std,2]
mean_std.names = gsub('-mean', 'Mean', mean_std.names)
mean_std.names = gsub('-std', 'Std', mean_std.names)
mean_std.names <- gsub('[-()]', '', mean_std.names)

# test dataset
test_set <- read.table("test/x_test")[mean_std]
test_act <- read.table("test/Y_test.txt")
test_subj <- read.table("test/subject_test.txt")
test_set <- cbind(test_subj, test_act, test_set)

# training dataset
train_set <- read.table("train/x_test")[mean_std]
train_act <- read.table("train/Y_test.txt")
train_subj <- read.table("train/subject_test.txt")
train_set <-cbind(train_subj, train_act, train_set)

# merge datasets
complete_set <- rbind(test_set, train_set)
colnames(complete_set) <- c("subject", "activity", mean_std.names)

#factors
complete_set$activity <- factor(complete_set$activity, levels = activities[,1], labels = activities[,2])
complete_set$subject <- as.factor(complete_set$subject)

complete_set.melt <- melt(complete_set, id = c("subject", "activity"))
complete_set.mean <- dcast(complete_set.melt, subject + activity ~ variable, mean)

write.table(complete_set.mean, "subj_act_avg.txt", row.names = FALSe, quote = FALSE)
