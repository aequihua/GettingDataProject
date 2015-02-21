---
title: "CodeBook - Getting and Cleaning Data Course Project"
author: "Arturo Equihua"
date: "Saturday, February 21, 2015"
output: html_document
---
#Introduction
As mentioned by the instructors of the Data Science Specialization program, one of the most exciting fields for data scientists nowadays is wearable computing. Several companies, particularly in the sports industry, are analyzing data in order to develop algorithms and products that attract more users. In particular, a project led by the University of California (UCI) generated a set of human activity data obtained from Samsung smartphone devices. This data, in short, describes how is the movement of the human body while doing certain activities such as walking, taking stairs or sitting.

In this document, it is described how the data of the Human Activity project is processed in order to generate a more focused dataset (tidy dataset) that contains the average indicators of body acceleration and gravity measurements associated to specific activities. 

#Software requirements
The following are the software products that were used to produce the tidy data set:
 
+ RStudio  0.98.1091
+ R version 3.1.2 (2014-10-31)
+ R packages: data.table

#Source data description
The source data (raw) is taken from the "Human Activity Recognition Using Smartphones Dataset" publication (see Bibliography). It was retrieved from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> . 

The full information about the data set (variables, units and so on) can be found in the README.txt and features_info.txt that come in the data set. This description will not be repeated here, but it is relevant to list the files that were selected for the production of the tidy data set:

* 'features.txt': List of all features (variables) available in the Training and Test set files.

* 'activity_labels.txt': Links the class labels with their activity name, that is, it is a catalog to translate the activity ID to the activity name.

* 'train/X_train.txt': Training set, that contains records, each of which is a vector of 561 metrics (features) obtained from the activities done by the volunteers (subjects) who did the experiment. **This is the set of metrics that constitute the essence of the data that is to be processed in the next sections of the document.** The detailed description about the features is contained in the 'feature_info.txt' file included in the dataset.

* 'train/y_train.txt': Training labels, that correspond to the subject number (from 1 to 30) to whom each record of the 'train\X_train.txt' file is associated with.

* 'test/X_test.txt': Test set, that has the same description as the X_train file. 

* 'test/y_test.txt': Test labels, that has the same description as the Y_train file. 

The reason for having a separate Train and Test data files is that the 30 volunteers were split in two groups, one of which did actual fitness training activities (the "Train" group) whereas the other group (the "Test" group) did normal activities.

#Transformation steps
The full transformation of the raw data files described in the previous section is done through the `run_analysis.R script`. The script has one main function named `run_all()`, that invokes other 4 functions that do the individual transformation steps.

The following is the description of what each function does:

##run_all(directory,outfile)
This is the main function that returns an output text file and also an R data table that contains the tidy dataset. The `directory` parameter is the location of the root directory of the extracted raw data set, and the `outfile` is the filename of the desired output file.

Inside the function, 4 transformation steps are invoked from other functions:

###merge(directory)
This function works with the raw data files located in `directory`as follows:
+ Merge at the column level the X_train and Y_train files in a single dataframe, so that the 561-variables are put together with the corresponding subject.
+ Do the same columnar merge with the X_test and Y_train.
+ Combine the two dataframes into a single one, that is, merge the rows.
+ Change the names of the columns:
++ The first two columns become SubjectID and ActivityID
++ The rest of the columns (561 features) are named with the labels contained in the `features.txt` file.

###extract(rawdf, measurements)
The `rawdf`is the 563-column dataframe obtained by the `merge()` function. The `measurements`parameters is a character vector containing the label of the features (variables) to extract. Since the course project requirement is to select the mean and standard deviation data only, the measurement parameters is c('mean()','std()'), as it was found that the feature labels (contained in `features.txt`) that refer to mean and standard deviations have all the suffix "mean()" and "std()" respectively.

The `extract`function takes the `rawdf`dataframe and produces an output dataframe that contains only the columns whose name correspond to the `measurements` vector. For mean and standard deviation this means that, out of 561 variables, only 66 are selected. 

- **SubjectID** : Numeric 1-30, it is the number of the volunteer who did the experiment.
- **ActivityID** : Numeric 1-5, it is the number of the activity each volunteer did.
- **66 data columns** : Individual values of 66 mean and standard deviation metrics obtained from accelerometer and gyroscope readings. The full explanation about them is contained in the `features_info.txt` file of the original dataset. This is the list of names of the 66 variables, all of them are numeric with values within the [-1,1] interval:
    - "tBodyAcc-mean()-X"
    - "tBodyAcc-mean()-Y"
    - "tBodyAcc-mean()-Z"
    - "tGravityAcc-mean()-X"
    - "tGravityAcc-mean()-Y"
    - "tGravityAcc-mean()-Z"
    - "tBodyAccJerk-mean()-X"
    - "tBodyAccJerk-mean()-Y"
    - "tBodyAccJerk-mean()-Z"
    - "tBodyGyro-mean()-X"
    - "tBodyGyro-mean()-Y"
    - "tBodyGyro-mean()-Z"
    - "tBodyGyroJerk-mean()-X"
    - "tBodyGyroJerk-mean()-Y"
    - "tBodyGyroJerk-mean()-Z"
    - "tBodyAccMag-mean()"
    - "tGravityAccMag-mean()"
    - "tBodyAccJerkMag-mean()"
    - "tBodyGyroMag-mean()"
    - "tBodyGyroJerkMag-mean()"
    - "fBodyAcc-mean()-X"
    - "fBodyAcc-mean()-Y"
    - "fBodyAcc-mean()-Z"
    - "fBodyAccJerk-mean()-X"
    - "fBodyAccJerk-mean()-Y"
    - "fBodyAccJerk-mean()-Z"
    - "fBodyGyro-mean()-X"
    - "fBodyGyro-mean()-Y"
    - "fBodyGyro-mean()-Z"
    - "fBodyAccMag-mean()"
    - "fBodyBodyAccJerkMag-mean()"
    - "fBodyBodyGyroMag-mean()"
    - "fBodyBodyGyroJerkMag-mean()"
    - "tBodyAcc-std()-X"
    - "tBodyAcc-std()-Y"
    - "tBodyAcc-std()-Z"
    - "tGravityAcc-std()-X"
    - "tGravityAcc-std()-Y"
    - "tGravityAcc-std()-Z"
    - "tBodyAccJerk-std()-X"
    - "tBodyAccJerk-std()-Y"
    - "tBodyAccJerk-std()-Z"
    - "tBodyGyro-std()-X"
    - "tBodyGyro-std()-Y"
    - "tBodyGyro-std()-Z"
    - "tBodyGyroJerk-std()-X"
    - "tBodyGyroJerk-std()-Y"
    - "tBodyGyroJerk-std()-Z"
    - "tBodyAccMag-std()"
    - "tGravityAccMag-std()"
    - "tBodyAccJerkMag-std()"
    - "tBodyGyroMag-std()"
    - "tBodyGyroJerkMag-std()"
    - "fBodyAcc-std()-X"
    - "fBodyAcc-std()-Y"
    - "fBodyAcc-std()-Z"
    - "fBodyAccJerk-std()-X"
    - "fBodyAccJerk-std()-Y"
    - "fBodyAccJerk-std()-Z"
    - "fBodyGyro-std()-X"
    - "fBodyGyro-std()-Y"
    - "fBodyGyro-std()-Z"
    - "fBodyAccMag-std()"
    - "fBodyBodyAccJerkMag-std()"
    - "fBodyBodyGyroMag-std()"
    - "fBodyBodyGyroJerkMag-std()"

###label(directory,extractedDF)
This function takes the 68-column dataframe obtained by the previous step and changes the ActivityID and SubjectID columns from numbers to names. The names of the activities are taken from the `activity_labels.txt`file. The names of the subjects are set as `Subject_NN`where NN is the number of the subject (from 1 to 30).

###summarize(dataset)
The labeled dataset obtained from the previous function is grouped by SubjectID-ActivityID and the average of all the 66 variables is calculated. The names of the 66 columns is changed to include the prefix "Mean_" to denote that the values are no longer individual observations but the mean of all the observations taken for a given SubjectID-ActivityID combination. This is the final tidy data set.

#Tidy data description
All the transformations above produce a text file with column names, whose description is as follows:

- **Key columns:** These are the columns that refer to the subject who did the experiment, and the activities performed:
    - "SubjectID": Named as "SubjectNN", where NN is a value between 1 and 30.
    - "ActivityID": Named as per the following list of values:

- **Average data columns:** Averages at the group level (Subject-Activity) of the 66 mean() and std() features selected. Numeric, within the [-1,1] interval. The full description of the nature of these metrics can be obtained from `feature_info.txt`of the original dataset. This is the list of the metrics:
    - "Mean_tBodyAcc-mean()-X"
    - "Mean_tBodyAcc-mean()-Y"
    - "Mean_tBodyAcc-mean()-Z"
    - "Mean_tGravityAcc-mean()-X"
    - "Mean_tGravityAcc-mean()-Y"
    - "Mean_tGravityAcc-mean()-Z"
    - "Mean_tBodyAccJerk-mean()-X"
    - "Mean_tBodyAccJerk-mean()-Y"
    - "Mean_tBodyAccJerk-mean()-Z"
    - "Mean_tBodyGyro-mean()-X"
    - "Mean_tBodyGyro-mean()-Y"
    - "Mean_tBodyGyro-mean()-Z"
    - "Mean_tBodyGyroJerk-mean()-X"
    - "Mean_tBodyGyroJerk-mean()-Y"
    - "Mean_tBodyGyroJerk-mean()-Z"
    - "Mean_tBodyAccMag-mean()"
    - "Mean_tGravityAccMag-mean()"
    - "Mean_tBodyAccJerkMag-mean()"
    - "Mean_tBodyGyroMag-mean()"
    - "Mean_tBodyGyroJerkMag-mean()"
    - "Mean_fBodyAcc-mean()-X"
    - "Mean_fBodyAcc-mean()-Y"
    - "Mean_fBodyAcc-mean()-Z"
    - "Mean_fBodyAccJerk-mean()-X"
    - "Mean_fBodyAccJerk-mean()-Y"
    - "Mean_fBodyAccJerk-mean()-Z"
    - "Mean_fBodyGyro-mean()-X"
    - "Mean_fBodyGyro-mean()-Y"
    - "Mean_fBodyGyro-mean()-Z"
    - "Mean_fBodyAccMag-mean()"
    - "Mean_fBodyBodyAccJerkMag-mean()"
    - "Mean_fBodyBodyGyroMag-mean()"
    - "Mean_fBodyBodyGyroJerkMag-mean()"
    - "Mean_tBodyAcc-std()-X"
    - "Mean_tBodyAcc-std()-Y"
    - "Mean_tBodyAcc-std()-Z"
    - "Mean_tGravityAcc-std()-X"
    - "Mean_tGravityAcc-std()-Y"
    - "Mean_tGravityAcc-std()-Z"
    - "Mean_tBodyAccJerk-std()-X"
    - "Mean_tBodyAccJerk-std()-Y"
    - "Mean_tBodyAccJerk-std()-Z"
    - "Mean_tBodyGyro-std()-X"
    - "Mean_tBodyGyro-std()-Y"
    - "Mean_tBodyGyro-std()-Z"
    - "Mean_tBodyGyroJerk-std()-X"
    - "Mean_tBodyGyroJerk-std()-Y"
    - "Mean_tBodyGyroJerk-std()-Z"
    - "Mean_tBodyAccMag-std()"
    - "Mean_tGravityAccMag-std()"
    - "Mean_tBodyAccJerkMag-std()"
    - "Mean_tBodyGyroMag-std()"
    - "Mean_tBodyGyroJerkMag-std()"
    - "Mean_fBodyAcc-std()-X"
    - "Mean_fBodyAcc-std()-Y"
    - "Mean_fBodyAcc-std()-Z"
    - "Mean_fBodyAccJerk-std()-X"
    - "Mean_fBodyAccJerk-std()-Y"
    - "Mean_fBodyAccJerk-std()-Z"
    - "Mean_fBodyGyro-std()-X"
    - "Mean_fBodyGyro-std()-Y"
    - "Mean_fBodyGyro-std()-Z"
    - "Mean_fBodyAccMag-std()"
    - "Mean_fBodyBodyAccJerkMag-std()"
    - "Mean_fBodyBodyGyroMag-std()"
    - "Mean_fBodyBodyGyroJerkMag-std()"

#How to run the transformation
The following are the steps to run the transformation:

- Download the raw dataset from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> and extract it to a working directory.
- Download and install the run_analysis.R into the R working directory.
- Run the following commands from the R console:
    - install.packages("data.table")
    - source('run_analysis.R')
    - x = run_all("<your directory of the raw dataset>","<filename of the output file>")

#Bibliography
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012. Available in <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#> 

[2] R Core Team (2014). R: A language and environment for statistical
  computing. R Foundation for Statistical Computing, Vienna, Austria.
  URL http://www.R-project.org/. 

[3] M Dowle, T Short, S Lianoglou, A Srinivasan with contributions from
  R Saporta and E Antonyan (2014). data.table: Extension of
  data.frame. R package version 1.9.2.
  http://CRAN.R-project.org/package=data.table
