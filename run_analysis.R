# Christopher Curley
# Getting and Cleaning Data
# UID ******97
# 
#  run_analysis.R does the following: 
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names. 
#   5 From the data set in step 4, creates a second, independent tidy data set with the average of 
#     each variable for each activity and each subject.

# Source file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

run_analysis <- function() {
        # need to make sure you've got the libraries loaded
        library(plyr)
        library(data.table)
        
        # GET THE REMOTE DATA
        # don't waste time and bandwidth - if the chk_dir value IS in the wkdir(), don't get it.
        # - if the unzipped chk_dir IS NOT in the wkdir(), then download it
        
        wk_files <- list.files()
        chk_dir  <- "UCI HAR Dataset"
        
        if (!chk_dir %in% wk_files) {

                # create place to put a temp file after download, a location to unzip the temp file
                # and the location of the remote file for download
                tmp_file <- tempfile()
                dest_dir <- getwd()
                dl_file  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                
                # now, download the tempfile and stick it in the temp dir, and specify a binary download
                download.file(dl_file, tmp_file, mode = "wb")
                
                # finally, unzip the file from the temp location to the 
                my_file <- unzip(tmp_file, exdir = dest_dir)
        } # end if
        
        # get and merge the subject data sets
        # from 1 to 7532 they were used for training, from 7533 to 10299 they were used for testing
        s_test  <- read.table("UCI HAR Dataset/test/subject_test.txt")
        s_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
        
        x_test  <- read.table("UCI HAR Dataset/test/X_test.txt")
        x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
                       
        y_test  <- read.table("UCI HAR Dataset/test/Y_test.txt")
        y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
        
        # Merge the training and the test sets to create one data set
        s_merged <- rbind(s_test, s_train)
        x_merged <- rbind(x_test, x_train)
        y_merged <- rbind(y_test, y_train)
        
        # repace generic column names with descripive column names
        # activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activity_id", "activity_label"))
        # features <- read.table("UCI HAR Dataset/features.txt", col.names=c("feature_id", "feature_label"))
        # colnames(x_merged) <- features[,2]
        
        # load lookup information
        features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel"))
        activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel"))
        # activities$activityLabel <- gsub("_", "", as.character(activities$activityLabel))
        includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)
        
        # merge test and training data and then name them
        # subject <- rbind(subject_test, subject_train)
        names(s_merged) <- "subjectId"

        # X <- rbind(X_test, X_train)
        x_merged <- x_merged[, includedFeatures]
        names(x_merged) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures])
        
        # y_merged <- rbind(Y_test, Y_train)
        names(y_merged) = "activityId"
        activity <- merge(y_merged, activities, by="activityId")$activityLabel
        
        # get today's date
        today <- Sys.Date()
        
        # merge data frames of different columns to form one data table
        t_merged <- paste("merged_data_", today, ".txt", sep = "")
        data <- cbind(s_merged, x_merged, activity)
        write.table(data, t_merged)
        
        # create a dataset grouped by subject and activity after applying standard deviation and average calculations
        c_merged <- paste("calculated_data_", today, ".txt", sep = "")
        dataDT <- data.table(data)
        calculatedData<- dataDT[, lapply(.SD, mean), by=c("subjectId", "activity")]
        write.table(calculatedData, c_merged)
        
} # end of function