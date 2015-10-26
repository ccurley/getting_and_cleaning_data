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
#
# Source file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# In sum, get the files, merge them, clean up the row names and labels, and write a tidy file and a calc by SD and mean file
# Assume that there is an operation to remove legacy downloads (because I rean out of time to code that in) and assume that the
# file names and locations in the zip are know (also because I ran out of time to code that in)
#
# Improvements -- optimize to shorten runtime, output files are delimted by space, change to csv and add the commas, because
# when unpacking the text file in excel to validate the results, the column headers not align properly even though the output
# file is correctly formated.
#
# IMPORTANT! MUST load plyr before dpylr in order for summarize to work properly. Ideally, would need logic to check the loaded
# libraries, and if dplyr is loaded and plyr is not, then unload dplyr, load plyr, then (re)load dplyr. See also:
# https://github.com/hadley/dplyr/issues/347
#
# Bugged me that I didn't use any of the syntax from earlier lessons, so read up on the CRAN file for ddply and found the
# summarize_each function. I tested with with both the lapply and the summarize_each and ended up with the same output
# see the outfiles for October 24th and October 25th. Comments from 95 to 99 reference stackoverflow and CRAN on the how-tos.

run_analysis <- function() {
        # need to make sure you've got the libraries loaded
        library(plyr)
        library(dplyr)
        library(data.table)
        
        # get the file from the remote location
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
        
        # load files into tables that will be merged into data sets - don't need to use data frames
        s_test  <- read.table("UCI HAR Dataset/test/subject_test.txt")
        s_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
        
        x_test  <- read.table("UCI HAR Dataset/test/X_test.txt")
        x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
                       
        y_test  <- read.table("UCI HAR Dataset/test/Y_test.txt")
        y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
        
        # merge the tables for subject, x, and y
        s_merged <- rbind(s_test, s_train)
        x_merged <- rbind(x_test, x_train)
        y_merged <- rbind(y_test, y_train)[, 1]
        
        # construct column names and row labels -- strip out unwanted chars (h/t rwstang for the tip on using grep)
        features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel"))
        included_features <- grep("-mean|-std", features$featureLabel)
 
        names(s_merged) <- "subjectId"

        x_merged <- x_merged[, included_features]
        names(x_merged) <- gsub("\\(|\\)", "", features$featureLabel[included_features])
        
        activity_names <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
        activities <- activity_names[y_merged]
        
        # get today's date
        today <- Sys.Date()
        
        # merge data frames of different columns to form one data table
        t_merged <- paste("merged_data_", today, ".txt", sep = "")
        data <- cbind(s_merged, activities, x_merged)
        write.table(data, t_merged, row.name=FALSE)
        
        # create a dataset average of each variable for each activity and each subject
        # http://stackoverflow.com/questions/16513827/r-summarizing-multiple-columns-with-data-table
        # c_data <- dt[, lapply(.SD, mean), by=c("subjectId", "activity")]
        # dt %>% group_by(subjectId, activity) %>% summarize_each(funs(mean))
        # https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
        
        c_merged <- paste("calculated_data_", today, ".txt", sep = "")
        dt <- data.table(data)
        c_data <- dt %>% group_by(subjectId, activities) %>% summarize_each(funs(mean))
        write.table(c_data, c_merged, row.name=FALSE)
        
} # end of function