Run Analysis Code Book
=========

This code book includes information about the source data, the transformations performed after collecting the data and some information about the variables of the resulting data sets.

Study Design
------------

The source data https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Subjects
--------
Coded by number substitution

Activities
----------

- 1 : WALKING
- 2 : WALKING_UPSTAIRS
- 3 : WALKING_DOWNSTAIRS
- 4 : SITTING
- 5 : STANDING
- 6 : LAYING

Features
--------

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

- mean(): Mean value
- std(): Standard deviation

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean

Variables
---------
These variables are used in the merged_data_YYYY-MM-DD.txt output file. The calculated_data_YYYY-MM-DD.txt prepends the varialble names with Mean., which is the function used to summarize the activities by subject. Time replaces t and Frequency replaces f from var names in the original raw data set.

- subjectid: 1 to 30 each representing a participant in the study
- activity: the activity that the subject was doing at the time of the measurement
- "Time.Body.Accelerometer.Mean.X" 
- "Time.Body.Accelerometer.Mean.Y"                                
- "Time.Body.Accelerometer.Mean.Z"
- "Time.Body.Accelerometer.Standard.Deviation.X"                  
- "Time.Body.Accelerometer.Standard.Deviation.Y" 
- "Time.Body.Accelerometer.Standard.Deviation.Z"                  
- "Time.Gravity.Accelerometer.Mean.X"
- "Time.Gravity.Accelerometer.Mean.Y"                             
- "Time.Gravity.Accelerometer.Mean.Z"
- "Time.Gravity.Accelerometer.Standard.Deviation.X"               
- "Time.Gravity.Accelerometer.Standard.Deviation.Y"
- "Time.Gravity.Accelerometer.Standard.Deviation.Z"               
- "Time.Body.Accelerometer.Jerk.Mean.X"
- "Time.Body.Accelerometer.Jerk.Mean.Y"                           
- "Time.Body.Accelerometer.Jerk.Mean.Z"
- "Time.Body.Accelerometer.Jerk.Standard.Deviation.X"             
- "Time.Body.Accelerometer.Jerk.Standard.Deviation.Y"
- "Time.Body.Accelerometer.Jerk.Standard.Deviation.Z"             
- "Time.Body.Gyroscope.Mean.X"
- "Time.Body.Gyroscope.Mean.Y"                                    
- "Time.Body.Gyroscope.Mean.Z"
- "Time.Body.Gyroscope.Standard.Deviation.X"
- "Time.Body.Gyroscope.Standard.Deviation.Y"
- "Time.Body.Gyroscope.Standard.Deviation.Z"                      
- "Time.Body.Gyroscope.Jerk.Mean.X"
- "Time.Body.Gyroscope.Jerk.Mean.Y"                               
- "Time.Body.Gyroscope.Jerk.Mean.Z"
- "Time.Body.Gyroscope.Jerk.Standard.Deviation.X"
- "Time.Body.Gyroscope.Jerk.Standard.Deviation.Y"
- "Time.Body.Gyroscope.Jerk.Standard.Deviation.Z"                 
- "Time.Body.Accelerometer.Magnitude.Mean"
- "Time.Body.Accelerometer.Magnitude.Standard.Deviation"          
- "Time.Gravity.Accelerometer.Magnitude.Mean"
- "Time.Gravity.Accelerometer.Magnitude.Standard.Deviation"       
- "Time.Body.Accelerometer.Jerk.Magnitude.Mean"
- "Time.Body.Accelerometer.Jerk.Magnitude.Standard.Deviation"     
- "Time.Body.Gyroscope.Magnitude.Mean"
- "Time.Body.Gyroscope.Magnitude.Standard.Deviation"              
- "Time.Body.Gyroscope.Jerk.Magnitude.Mean"
- "Time.Body.Gyroscope.Jerk.Magnitude.Standard.Deviation"         
- "Frequency.Body.Accelerometer.Mean.X"
- "Frequency.Body.Accelerometer.Mean.Y"                           
- "Frequency.Body.Accelerometer.Mean.Z"
- "Frequency.Body.Accelerometer.Standard.Deviation.X"             
- "Frequency.Body.Accelerometer.Standard.Deviation.Y"
- "Frequency.Body.Accelerometer.Standard.Deviation.Z"             
- "Frequency.Body.Accelerometer.Mean.Frequency.X"
- "Frequency.Body.Accelerometer.Mean.Frequency.Y"                 
- "Frequency.Body.Accelerometer.Mean.Frequency.Z"
- "Frequency.Body.Accelerometer.Jerk.Mean.X"                      
- "Frequency.Body.Accelerometer.Jerk.Mean.Y"
- "Frequency.Body.Accelerometer.Jerk.Mean.Z"
- "Frequency.Body.Accelerometer.Jerk.Standard.Deviation.X"
- "Frequency.Body.Accelerometer.Jerk.Standard.Deviation.Y"        
- "Frequency.Body.Accelerometer.Jerk.Standard.Deviation.Z"
- "Frequency.Body.Accelerometer.Jerk.Mean.Frequency.X"            
- "Frequency.Body.Accelerometer.Jerk.Mean.Frequency.Y"
- "Frequency.Body.Accelerometer.Jerk.Mean.Frequency.Z"            
- "Frequency.Body.Gyroscope.Mean.X"
- "Frequency.Body.Gyroscope.Mean.Y"                               
- "Frequency.Body.Gyroscope.Mean.Z"
- "Frequency.Body.Gyroscope.Standard.Deviation.X"                 
- "Frequency.Body.Gyroscope.Standard.Deviation.Y"
- "Frequency.Body.Gyroscope.Standard.Deviation.Z"                 
- "Frequency.Body.Gyroscope.Mean.Frequency.X"
- "Frequency.Body.Gyroscope.Mean.Frequency.Y"                     
- "Frequency.Body.Gyroscope.Mean.Frequency.Z"
- "Frequency.Body.Accelerometer.Magnitude.Mean"                   
- "Frequency.Body.Accelerometer.Magnitude.Standard.Deviation"
- "Frequency.Body.Accelerometer.Magnitude.Mean.Frequency"         
- "Frequency.Body.Accelerometer.Jerk.Magnitude.Mean"
- "Frequency.Body.Accelerometer.Jerk.Magnitude.Standard.Deviation"
- "Frequency.Body.Accelerometer.Jerk.Magnitude.Mean.Frequency"
- "Frequency.Body.Gyroscope.Magnitude.Mean"                       
- "Frequency.Body.Gyroscope.Magnitude.Standard.Deviation"
- "Frequency.Body.Gyroscope.Magnitude.Mean.Frequency"             
- "Frequency.Body.Gyroscope.Jerk.Magnitude.Mean"
- "Frequency.Body.Gyroscope.Jerk.Magnitude.Standard.Deviation"    
- "Frequency.Body.Gyroscope.Jerk.Magnitude.Mean.Frequency"  