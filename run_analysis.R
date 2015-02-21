#-----------------------------
#  Getting and Cleaning Data- Course Project
#  Author: Arturo Equihua
#  Date : February 21st, 2015
#---------------------------------
#  This script processes the Human Activity Recognition dataset
#  in order to extract the relevant data and produce a tidy dataset,
#  all this according to the specifications provided by the course
#  teachers:
#
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names. 
#   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
#  Please refer to the CodeBook.md accompanying file for more details on how the data is structured
#  and how this script works.

merge <- function(directory=".")
{
  # Read the raw data files to produce a single, merged dataframe that will be processed further
  
  start_time = Sys.time()

  # Load the feature list
  writeLines("Reading feature file...")
  fname <- paste(directory,"/features.txt", sep="")
  featureDF <- read.table(fname)
  writeLines("Done...\n\n")
  
  # Load the 561-metric lists in dataframes: Train Set
  writeLines("Reading Train dataset files...")
  fname <- paste(directory,"/train/X_train.txt", sep="")
  writeLines(paste("...",fname))
  metricsTrain <- read.table(fname)
  
  fname <- paste(directory,"/train/subject_train.txt", sep="")
  writeLines(paste("...",fname))
  subjectsTrain <- read.table(fname)

  fname <- paste(directory,"/train/Y_train.txt", sep="")
  writeLines(paste("...",fname))
  activityTrain <- read.table(fname)

  #Integrate all the columns in a single dataframe for Train data
  integratedTrain <- cbind(subjectsTrain,activityTrain,metricsTrain)
  writeLines("Done...\n\n")
  
  # Load the 561-metric lists in dataframes: Test Set
  writeLines("Reading Test dataset files...")
  fname <- paste(directory,"/test/X_test.txt", sep="")
  writeLines(paste("...",fname))
  metricsTest <- read.table(fname)
  
  fname <- paste(directory,"/test/subject_test.txt", sep="")
  writeLines(paste("...",fname))
  subjectsTest <- read.table(fname)
  
  fname <- paste(directory,"/test/Y_test.txt", sep="")
  writeLines(paste("...",fname))
  activityTest <- read.table(fname)
  
  #Integrate all the columns in a single dataframe for Test data
  integratedTest <- cbind(subjectsTest,activityTest,metricsTest)
  writeLines("Done...\n\n")
  
  #Merge the Train and Test data in a single dataframe (still raw)
  allIntegrated <- rbind(integratedTrain,integratedTest)
  
  #Name the first two columns as Subject and Activity
  names(allIntegrated)[1] = "SubjectID"
  names(allIntegrated)[2] = "ActivityID"
  #Name the rest of the columns according to the list of the 561 features
  names(allIntegrated)[3:ncol(allIntegrated)] <- as.character(featureDF$V2)
  
  elapsed_time <- Sys.time() - start_time
  
  writeLines(paste("Elapsed time:", elapsed_time, "seconds."))
  allIntegrated
}

extract <- function(rawdf, measurements)
{
  # Extract the given measurements from the dataframe rawdf
  # measurements is a character vector containing the substring of the column names to look for

  start_time = Sys.time()
  
  writeLines("Extracting relevant columns...")
  
  # Initialize the result dataframe with the first two columns (subject and activity)
  result <- rawdf[,1:2]
  
  for (x in measurements)
  {
     writeLines(paste("...Column labeled with",x))
     colselect <- c(grep(x,names(rawdf),fixed=TRUE))
     result <- cbind(result,rawdf[,colselect])
  }
  writeLines("Extraction done..")
        
  elapsed_time <- Sys.time() - start_time
  
  writeLines(paste("Elapsed time:", elapsed_time, "seconds."))
  result
}

label <- function(directory, extractedDF)
{
  # With the reduced dataframe extractedDF, the Activity column now has to be converted to a factor to 
  # introduce the labels of the activity names and not rely on numbers only
  # A similar treatment will be done to the Subject IDs, we will put labels to reflect a
  # "SubjectN" name for each subject
  start_time = Sys.time()
  
  writeLines("Reading activity file...")
  # Load the activity list
  fname <- paste(directory,"/activity_labels.txt", sep="")
  activityDF <- read.table(fname)
  writeLines("Done...\n\n")
  
  # Use the V2 column of the activity list to define labels
  # for the Activity column of the extractedDF dataframe and convert
  # to a factor type vector
  extractedDF$ActivityID <- factor(extractedDF$ActivityID,labels=activityDF$V2)
  
  # Set the labels of the Subject IDs as "Subject_NN"
  subjectLabels <- paste("Subject_",min(extractedDF$SubjectID):max(extractedDF$SubjectID),sep="")
  extractedDF$SubjectID <- factor(extractedDF$SubjectID, labels=subjectLabels)
  
  writeLines("Labeling done..")
  
  elapsed_time <- Sys.time() - start_time
  
  writeLines(paste("Elapsed time:", elapsed_time, "seconds."))
  
  extractedDF
  
}

summarize <- function(dataset)
{
  # Receives the dataset with the relevant variables, properly labeled by Subject and Activity
  # and does the summarization to obtain the averages
  start_time = Sys.time()
  
  writeLines("Summarizing the data...")
  # Convert to data table and define a compound key with SubjectID and ActivityID 
  library(data.table)
  dataset = as.data.table(dataset)
  setkeyv(dataset,colnames(dataset)[1:2])
  
  # Once the data is keyed, use lapply to summarize it with the mean function
  summed = dataset[, lapply(.SD,mean), by = key(dataset)]
  
  # Finally, the column names are changed to "mean of ..." to not confuse them with the atomic value
  setnames(summed,names(summed)[3:ncol(summed)],paste("Mean_",names(summed)[3:ncol(summed)],sep=""))
  
  writeLines("Done...\n\n")
  
  elapsed_time <- Sys.time() - start_time
  
  writeLines(paste("Elapsed time:", elapsed_time, "seconds.")) 
  summed
}

run_all <- function(directory, outfile)
{
  # Function that invokes the full sequence of functions above
  # directory = Location of the source dataset files
  # outfile = Filename of the output text file of the tidy dataset
  
  rawdf = merge(directory)
  extracted = extract(rawdf,c("mean()","std()"))
  labeled = label(directory, extracted)
  summed = summarize(labeled)
  write.table(summed, row.names=FALSE, file=outfile)
  summed
  
}
