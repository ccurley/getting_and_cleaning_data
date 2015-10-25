# Getting and Cleaning Data

This repo contains R scripts, code books, outputs, and notes for the Getting and Cleaning Data sets course project.

This is a public repo, but I strongly caution cribbers to NOT use anything you find in the repo as a basis for submitting assignments. I'm rubbish at using R -- which I seem to think is PERL. 

It's better to think, "huh, if he did it this way, and I'm doing it the same way, then I must be doing it wrong."

You've been warned.

Contents
--------

- run_analysis.R
- codebook.md
- calculated_data_2015-10-24.txt, calculated_data_2015-10-25.txt
- merged_data_2015-10-24.txt, merged_data_2015-10-25.txt

run_analysis.R
--------------

Source run_analysis.R to call the function run_analysis(), without args. The function merges multiple tables collected by UCI Human Activity Recognition Using Smartphones program, and it performs calculations on that merged data.

The function checks first to see if the unzipped data is located in the default working directory. If not, the function will download and unzip the data.

With the data in the working directory, the function: 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The function will output two files:

1. merged_data_YYYY-MM-DD.txt, containing the merged training and test sets, with descriptive column names and activities.
2. calculated_data_YYYY-MM-DD.txt, a tidy data table with the average of each variable for each activity and each subject.

If the function is called multiple times daily, it will over-write the daily file. If it is called on subsequent days, it will write to a new file.

There are two outfiles in the repository for reference. The first one was generated using lapply:

      dt[, lapply(.SD, mean), by=c("subjectId", "activity")]
      
Reference: http://stackoverflow.com/questions/16513827/r-summarizing-multiple-columns-with-data-table
      
I was bothered, however, that during the project I didn't use ddply from the lectures or the swirl exercises to solve this problem. I struggled a bit with 'summarize' and 'group-by' until I found 'summarize_each' in the CRAN documenation on ddply. I refactored for this line using summarize_each:

      dt %>% group_by(subjectId, activity) %>% summarize_each(funs(mean))
      
Reference: https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
      
I produced a second set of outfiles (the 25th outfiles) and diff'd them to determine if they were identical. They are. So, I'm either
repeating the same error twice, or each method works.

(I would point out to people who know me that I didn't use a for statement. Small victories.)

Use read.table with header flaged true to view the output files. Note, being an idiot and extracting the text files with excel, then peforming text-to-data, may result in misaligned descriptive column names -- use read.table unless you also want to waste as much time as I did debugging a function that did not need to be debugged.

Finally, note that plyr and ddply behave oddly with summarize when the ddply library is called first and the plyr library is called
second. Order of operations is vital if you are using both libraries. Reference: https://github.com/hadley/dplyr/issues/347