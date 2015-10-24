# Getting and Cleaning Data

This repo contains R scripts, code books, outputs, and notes for the Getting and Cleaning Data sets course project.

This is a public repo, but I strongly caution cribbers to NOT use anything you find in the repo as a basis for submitting assignments. I'm rubbish at using R -- which I seem to think is PERL. 

It's better to think, "huh, if he did it this way, and I'm doing it the same way, then I must be doing it wrong."

You've been warned.

Contents
--------

- run_analysis.R
- codebook.md
- calculated_data_2015-10-24.txt
- merged_data_2015-10-24.txt

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

Use read.table to view the output files. Note, being an idito and extracting the text files with excel, then peforming text-to-data, may result in misaligned descriptive column names -- use read.table unless you also want to waste as much time as I did debugging a function that did not need to be debugged.