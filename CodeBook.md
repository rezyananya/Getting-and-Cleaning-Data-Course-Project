CodeBook:

Course Project for Gettting & Celaning Data based on Human Activity Recognition Using Smartphones Dataset

This CodeBook that describes the variables, the data, and any transformations or work that was performed to clean up
the source data to create a tidy dataset as per requirements of course project.

Information about Source Data Experment:
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

***************************************************************************************************************************************************************************************************************************************************

Requirements & Details of Transformations through run_analysis.R script:

Requirements:

run_analysis.R script has the following requirements to perform transformation on UCI HAR Dataset.

1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement.
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive activity names.
5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
6.Detailed Functions of run_analysis.R Script

1.Downloads the dataset from the URL mentioned above and unzips it to create UCI HAR Dataset folder
Reference from the code that created:#Read file which is located at my machine
Read_file <- file.path("C:/Users/Ananya/Documents/UCI HAR Dataset")
files<-list.files(Read_file, recursive=TRUE)

2.Imports "test" and "train" datsets and creates data frames from then and then Merges the training and the test sets
to create one data frame.
Reference from the code that created:files
#Activity files
ActivityTestData  <- read.table(file.path(Read_file, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrainData <- read.table(file.path(Read_file, "train", "Y_train.txt"),header = FALSE)

#Subject files
SubjectTrainData <- read.table(file.path(Read_file, "train", "subject_train.txt"),header = FALSE)
SubjectTestData <- read.table(file.path(Read_file, "test" , "subject_test.txt"),header = FALSE)

#Features file
FeatureTestData  <- read.table(file.path(Read_file, "test" , "X_test.txt" ),header = FALSE)
FeatureTrainData <- read.table(file.path(Read_file, "train", "X_train.txt"),header = FALSE)

str(ActivityTestData)

#1:Merges the training and the test sets to create one data set.
SubjectData<- rbind(SubjectTrainData,SubjectTestData)
ActivityData<- rbind(ActivityTrainData,ActivityTestData)
FeatureData<- rbind(FeatureTrainData,FeatureTestData)



3.Extracts a subset of data with only the measurements on the mean "mean()" and standard deviation "std()" for each measurement. Also excludes meanFreq()-X measurements or angle measurements where the term mean exists resulting in 66 measurement variables.
Reference from the code that created:
#Now setting names to above defined variables
names(SubjectData) <- c("Subject")
names(ActivityData)<- c("Activity")
FeatureNameData <- read.table(file.path(Read_file, "features.txt"),head = FALSE)
names(FeatureData)<- FeatureNameData$V2
Combine_Data <- cbind(SubjectData,ActivityData)
Final_Data <- cbind(FeatureData,Combine_Data)

#2:Extracts only the measurements on the mean and standard deviation for each measurement
MeanFeaturesNames<-FeatureNameData$V2[grep("mean\\(\\)|std\\(\\)",FeatureNameData$V2)]
Names<-c(as.character(MeanFeaturesNames), "Subject", "Activity")
Final_Data<-subset(Final_Data,select= Names)


4.Updates the variable names in dataframe variable names for data fame to improve readibility
Reference from the code that created:
#3:Uses descriptive activity names to name the activities in the data set
activityname <- read.table(file.path(Read_file, "activity_labels.txt"),header = FALSE)

head(activityname)

5.Appropriately labels the data set with descriptive activity names in place of activity.
Reference from the code that created:
#4:Appropriately labels the data set with descriptive variable names
names(Final_Data)<-gsub("^t", "time", names(Final_Data))
names(Final_Data)<-gsub("^f", "frequency", names(Final_Data))
names(Final_Data)<-gsub("Acc", "Accelerometer", names(Final_Data))
names(Final_Data)<-gsub("Gyro", "Gyroscope", names(Final_Data))
names(Final_Data)<-gsub("Mag", "Magnitude", names(Final_Data))
names(Final_Data)<-gsub("BodyBody", "Body", names(Final_Data))

names(Final_Data)

6.Writes new tidy data frame to a text file to create the required tidy data set file.
Reference from the code that created:
#5:Creates a second,independent tidy data set and ouput it
TidyData<-aggregate(. ~Subject + Activity, Final_Data, mean)
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)


Description of variables in the Tidy Data:

Variable Name	Details
activityName	Factor with 6 levels WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
subjectId	  	Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30
tBodyAccMeanX	Average of Mean Value time doman Body Accelration in x direction
tBodyAccMeanY	Average of Mean Value time doman Body Accelration in Y direction
tBodyAccMeanZ	Average of Mean Value time doman Body Accelration in Z direction
tBodyAccStdX	Average of Standard deviation time doman Body Accelration in x direction
tBodyAccStdY	Average of Standard deviation time doman Body Accelration in Y direction
tBodyAccStdZ	Average of Standard deviation time doman Body Accelration in Z direction
tGravityAccMeanX	Average of Mean Value time doman Gravity Accelrationin x direction
tGravityAccMeanY	Average of Mean Value time doman Gravity Accelrationin Y direction
tGravityAccMeanZ	Average of Mean Value time doman Gravity Accelrationin Z direction
tGravityAccStdX	Average of Standard deviation time doman Gravity Accelrationin x direction
tGravityAccStdY	Average of Standard deviation time doman Gravity Accelrationin Y direction
tGravityAccStdZ	Average of Standard deviation time doman Gravity Accelrationin Z direction
tBodyAccJerkMeanX	Average of Mean Value time doman Body Accelration Jerk in x direction
tBodyAccJerkMeanY	Average of Mean Value time doman Body Accelration Jerk in Y direction
tBodyAccJerkMeanZ	Average of Mean Value time doman Body Accelration Jerk in Z direction
tBodyAccJerkStdX	Average of Standard deviation time doman Body Accelration Jerk in x direction
tBodyAccJerkStdY	Average of Standard deviation time doman Body Accelration Jerk in Y direction
tBodyAccJerkStdZ	Average of Standard deviation time doman Body Accelration Jerk in Z direction
tBodyGyroMeanX	Average of Mean Value time doman Body Gyro in x direction
tBodyGyroMeanY	Average of Mean Value time doman Body Gyro in Y direction
tBodyGyroMeanZ	Average of Mean Value time doman Body Gyro in Z direction
tBodyGyroStdX	Average of Standard deviation time doman Body Gyro in x direction
tBodyGyroStdY	Average of Standard deviation time doman Body Gyro in Y direction
tBodyGyroStdZ	Average of Standard deviation time doman Body Gyro in Z direction
tBodyGyroJerkMeanX	Average of Mean Value time doman Body Gyro Jerk signal in x direction
tBodyGyroJerkMeanY	Average of Mean Value time doman Body Gyro Jerk signal in Y direction
tBodyGyroJerkMeanZ	Average of Mean Value time doman Body Gyro Jerk signal in Z direction
tBodyGyroJerkStdX	Average of Standard deviation time doman Body Gyro Jerk signal in x direction
tBodyGyroJerkStdY	Average of Standard deviation time doman Body Gyro Jerk signal in Y direction
tBodyGyroJerkStdZ	Average of Standard deviation time doman Body Gyro Jerk signal in Z direction
tBodyAccMagMean	Average of Mean Value time doman Body Accelration magnitude
tBodyAccMagStd	Average of Standard deviation time doman Body Accelration magnitude
tGravityAccMagMean	Average of Mean Value time doman Gravity Accelration magnitude
tGravityAccMagStd	Average of Standard deviation time doman Gravity Accelration magnitude
tBodyAccJerkMagMean	Average of Mean Value time doman Body Accelration jerk magnitude
tBodyAccJerkMagStd	Average of Standard deviation time doman Body Accelration jerk magnitude
tBodyGyroMagMean	Average of Mean Value time doman Body Gyro magnitude
tBodyGyroMagStd	Average of Standard deviation time doman Body Gyro magnitude
tBodyGyroJerkMagMean	Average of Mean Value time doman Body Gyro Jerk magnitude
tBodyGyroJerkMagStd	Average of Standard deviation time doman Body Gyro Jerk magnitude
fBodyAccMeanX	Average of Mean Value frequency domainBody Accelration in x direction
fBodyAccMeanY	Average of Mean Value frequency domainBody Accelration in Y direction
fBodyAccMeanZ	Average of Mean Value frequency domainBody Accelration in Z direction
fBodyAccStdX	Average of Standard deviation frequency domainBody Accelration in x direction
fBodyAccStdY	Average of Standard deviation frequency domainBody Accelration in Y direction
fBodyAccStdZ	Average of Standard deviation frequency domainBody Accelration in Z direction
fBodyAccJerkMeanX	Average of Mean Value frequency domainBody Accelration Jerk in x direction
fBodyAccJerkMeanY	Average of Mean Value frequency domainBody Accelration Jerk in Y direction
fBodyAccJerkMeanZ	Average of Mean Value frequency domainBody Accelration Jerk in Z direction
fBodyAccJerkStdX	Average of Standard deviation frequency domainBody Accelration Jerk in x direction
fBodyAccJerkStdY	Average of Standard deviation frequency domainBody Accelration Jerk in Y direction
fBodyAccJerkStdZ	Average of Standard deviation frequency domainBody Accelration Jerk in Z direction
fBodyGyroMeanX	Average of Mean Value frequency domainBody Gyro in x direction
fBodyGyroMeanY	Average of Mean Value frequency domainBody Gyro in Y direction
fBodyGyroMeanZ	Average of Mean Value frequency domainBody Gyro in Z direction
fBodyGyroStdX	Average of Standard deviation frequency domainBody Gyro in x direction
fBodyGyroStdY	Average of Standard deviation frequency domainBody Gyro in Y direction
fBodyGyroStdZ	Average of Standard deviation frequency domainBody Gyro in Z direction
fBodyAccMagMean	Average of Mean Value frequency domainBody Accelration magnitude
fBodyAccMagStd	Average of Standard deviation frequency domainBody Accelration magnitude
fBodyBodyAccJerkMagMean	Average of Mean Value frequency domainBody Accelration jerk magnitude
fBodyBodyAccJerkMagStd	Average of Standard deviation frequency domainBody Accelration jerk magnitude
fBodyBodyGyroMagMean	Average of Mean Value frequency domainBody Body Gyro magnitude
fBodyBodyGyroMagStd	Average of Standard deviation frequency domainBody Body Gyro magnitude
fBodyBodyGyroJerkMagMean	Average of Mean Value frequency domainBody Body Gyro jerk magnitude
fBodyBodyGyroJerkMagStd	Average of Standard deviation frequency domainBody Body Gyro jerk magnitude
Next  Previous
