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
#
# Yes - this could be much more efficient, but I worked through the tables stepwise so I could debug -- and frankly -- remember
# what I did to get the result.

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
        
        ## load files into tables that will be merged into data sets - don't need to use data frames
        # get the activities, and strip out the labels into a factor for later use
        #   this step can be shorted by read.table(...)[,2]. Using two steps to make it easier to follow.
        activity <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
        activity_label <- activity[, 2]
        
        # get the features, label the columnes for easy use later
        # put the features into a factor
        #   this step can be shorted by read.table(...)[,2]. Using two steps to make it easier to follow.
        features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureid", "featurelabel"))
        feature_label <- features[, 2]
 
        # get the subject index values train and test data       
        s_test  <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
        s_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

        # get the measures for train and test        
        x_test  <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
        x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
        
        # get the feature index values for train and test              
        y_test  <- read.table("UCI HAR Dataset/test/Y_test.txt", header = FALSE)
        y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
        
        # merge the tables for subject, x, and y -- we'll cbind them later.
        s_merged <- rbind(s_train, s_test)
        x_merged <- rbind(x_train, x_test)
        y_merged <- rbind(y_train, y_test)
        
        # name column 1 in the subject set for ease of use later
        names(s_merged) <- "subjectid"
        
        # add a column to y_merged with the labels in it. This is abstract, so remember this is what you did:
        #    if y_merged[1,1]  is 5, activity_label[5] is STANDING, making y_merged[1,2]  = STANDING
        #    if y_merged[1,28] is 4, activity label[4] is SITTING,  making y_merged[1,28] = SITTING
        #    row by row, find the value of the first observation, match it to the corresponding value in the factor
        #    and write that value in the new column.
        # when finished, name the columns for easy use, and strip out the codes -- since we only left them there for 
        #    debugging anyway.
        y_merged[,2]=activity_label[y_merged[,1]]
        names(y_merged) <- c("id","activity")
        y_merged <- select(y_merged, activity)
        
        # Before we label the names in x_merged, lets redcue the 561 obs down to 79 obs using grep
        #    we only need mean and std
        #    grep will return a int vector of only the columnes where "mean" or "std" are hit
        included_features <- grep("mean|std", feature_label)
 
        # now we can subset x_merged with the vector of ints where "mean" or "std" are located
        x_merged <- x_merged[, included_features]
        
        # and finally, now that we've got the x_merged set reduce, we can label it with only the label strings
        # for those columns where grep found "mean" or "std", and we'll take out the "()"s for good measure
        names(x_merged) <- gsub("\\(|\\)", "", features$featurelabel[included_features])
        
        # get today's date, so we can use it later when creating file names.
        today <- Sys.Date()
        
        # merge data frames of different columns to form one data table
        t_merged <- paste("merged_data_", today, ".txt", sep = "")
        data <- cbind(s_merged, y_merged, x_merged)
        write.table(data, t_merged, row.name=FALSE)
        
        # create a dataset average of each variable for each activity and each subject
        #   http://stackoverflow.com/questions/16513827/r-summarizing-multiple-columns-with-data-table
        #   c_data <- dt[, lapply(.SD, mean), by=c("subjectId", "activity")]
        #   dt %>% group_by(subjectId, activity) %>% summarize_each(funs(mean))
        #   https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
        # I could have done that more economcially, but the data tables are incremented for debugging and
        
        c_merged <- paste("calculated_data_", today, ".txt", sep = "")
        dt <- data.table(data)
        c_data <- dt %>% group_by(subjectid, activity) %>% summarize_each(funs(mean))
        c_data <- c_data[order(subjectid)]
        write.table(c_data, c_merged, row.name=FALSE)
        
} # end of function