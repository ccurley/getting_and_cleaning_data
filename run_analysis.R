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
# IMPORTANT! MUST load plyr before dpylr in order for summarize to work properly. Ideally, would need logic to check the loaded
# libraries, and if dplyr is loaded and plyr is not, then unload dplyr, load plyr, then (re)load dplyr. See also:
# https://github.com/hadley/dplyr/issues/347
#
# Bugged me that I didn't use any of the syntax from earlier lessons, so read up on the CRAN file for ddply and found the
# summarize_each function. I tested with with both the lapply and the summarize_each and ended up with the same output
# see the outfiles for October 24th and October 25th. Comments from 95 to 99 reference stackoverflow and CRAN on the how-tos.
#
# Yes - this could be much more efficient, but I worked through the tables stepwise so I could debug -- and frankly -- remember
# what I did to get the result. I'm sure there is a more r-ish way to prep the column names, but I wanted to try out a bunch of
# different things. And, I did mess about with lapply(col, FUN = function(x) recode(x, '"a" = "aa"; "b" = "bb"'))) just to say
# I did it -- but recode in the car library looks for full string matches not substrings. So, r snobs are welcome to sell their
# wares elsewhere.

run_analysis <- function() {
        # need to make sure you've got the libraries loaded
        library(plyr)
        library(dplyr)
        library(data.table)
        library(stringr)
        
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
        
        # name column 1 in the subject set for ease of use in debugging. Not really necessary.
        names(s_merged) <- "subjectid"
        
        # add a column to y_merged with the labels in it. This is abstract, so remember this is what you did:
        #    where y_merged[1,1]  is 5, activity_label[5] is STANDING, making y_merged[2,2]  = STANDING
        #    where y_merged[1,28] is 4, activity label[4] is SITTING,  making y_merged[2,28] = SITTING
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
  
        # Clean up the row names to make everyone happy
        # I'll use gsub and str_replace_all from the stringr lib. I don't use the recode from the car lib
        # since it looks for complete strings to replace. This code, won't work in this case:
        # lapply(tmp, FUN = function(x) recode(x, '"Gyro" = "Gyroscope"; "Mag" = "Magnitude"'))
        # gsub examples use regular expression to isolate substrings and subsitute new substrings.
        # Start by grabbing the column names out of the data data.frame ... perform some operations...
        # then... put the news column names back into data before writing out the file of all observations.
        data_names <- names(data)
        data_names <- gsub("-", " ", data_names)                           # match -, replace with a space
        data_names <- gsub("([a-z])([A-Z])", "\\1 \\2", data_names)        # match aA pairs, split the pairs apart
        data_names <- gsub("Body Body", "Body", data_names)                # match two Bodys, make it one Body
        data_names <- gsub("^t", "Time", data_names)                       # Match t at start, replace with Time
        data_names <- gsub("^f|Freq", "Frequency", data_names)             # f at start or Freq anywhere, make Frequency
        
        data_names <- str_replace_all(data_names, "Acc", "Accelerometer")  # exmaple of str_replace_all
        data_names <- str_replace_all(data_names, "Gyro", "Gyroscope")
        data_names <- str_replace_all(data_names, "Mag", "Magnitude")
        data_names <- str_replace_all(data_names, "std", "Standard Deviation")

        data_names <- gsub("(m)(e)(a)(n)","M\\2\\3\\4", data_names)        # and because we're being stupid, we'll do this
        
        names(data) <- data_names
        
        write.table(data, t_merged, row.name=FALSE)
        
        # create a dataset average of each variable for each activity and each subject
        #   http://stackoverflow.com/questions/16513827/r-summarizing-multiple-columns-with-data-table
        #   c_data <- dt[, lapply(.SD, mean), by=c("subjectId", "activity")]
        #   dt %>% group_by(subjectId, activity) %>% summarize_each(funs(mean))
        #   https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
        # So, at this point, this block of code should more or less make sense as it is.
        
        c_merged <- paste("calculated_data_", today, ".txt", sep = "")
        dt <- data.table(data)
        c_data <- dt %>% group_by(subjectid, activity) %>% summarize_each(funs(mean))
        c_data <- c_data[order(subjectid)]
        names(c_data) <- gsub("^([A-Z].+)$", "Mean.\\1", names(c_data), perl = TRUE)  # har har har...
        write.table(c_data, c_merged, row.name=FALSE)
        
} # end of function

# str_replace_all(string, pattern, replacement)