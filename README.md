---
title: "README file - Getting and Cleaning Data Course Project"
author: "Arturo Equihua"
date: "Saturday, February 21, 2015"
output: html_document
---
#Introduction
This document describes how the R code of the project is build and how it can be run. For full details about the nature of the project please refer to the CodeBook.md file available in the GitHub repository.

#Software requirements
The following are the software products that are needed to run the code in this project:
 
+ RStudio  0.98.1091
+ R version 3.1.2 (2014-10-31)
+ R packages: data.table

#How to run the code
The following are the steps to run the transformation:

- Download the raw dataset from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> and extract it to a working directory.
- Download and install the run_analysis.R into the R working directory.
- Run the following commands from the R console:
    - install.packages("data.table")
    - source('run_analysis.R')
    - x = run_all("your directory of the raw dataset","filename of the output file")

#How the script works
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

###label(directory,extractedDF)
This function takes the 68-column dataframe obtained by the previous step and changes the ActivityID and SubjectID columns from numbers to names. The names of the activities are taken from the `activity_labels.txt`file. The names of the subjects are set as `Subject_NN`where NN is the number of the subject (from 1 to 30).

###summarize(dataset)
The labeled dataset obtained from the previous function is grouped by SubjectID-ActivityID and the average of all the 66 variables is calculated. The names of the 66 columns is changed to include the prefix "Mean_" to denote that the values are no longer individual observations but the mean of all the observations taken for a given SubjectID-ActivityID combination. This is the final tidy data set.
