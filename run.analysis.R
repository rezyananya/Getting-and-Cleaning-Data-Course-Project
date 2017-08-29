#I am reading all the respective files which are located at my machine.


Read_file <- file.path("C:/Users/Ananya/Documents/UCI HAR Dataset")
files<-list.files(Read_file, recursive=TRUE)

#Activity files
ActivityTestData  <- read.table(file.path(Read_file, "test/y_test.txt"),header = FALSE)
ActivityTrainData <- read.table(file.path(Read_file, "train/Y_train.txt"),header = FALSE)

#Subject files
SubjectTrainData <- read.table(file.path(Read_file, "train/subject_train.txt"),header = FALSE)
SubjectTestData <- read.table(file.path(Read_file, "test/subject_test.txt"),header = FALSE)

#Features file
FeatureTestData  <- read.table(file.path(Read_file, "test/X_test.txt" ),header = FALSE)
FeatureTrainData <- read.table(file.path(Read_file, "train/X_train.txt"),header = FALSE)
FeatureNameData <- read.table(file.path(Read_file, "features.txt"),header= FALSE)



#1:Merges the training and the test sets to create one data set.
SubjectData<- rbind(SubjectTrainData,SubjectTestData)
ActivityData<- rbind(ActivityTrainData,ActivityTestData)
FeatureData<- rbind(FeatureTrainData,FeatureTestData)

#Now setting names to above defined variables.
names(SubjectData) <- c("Subject")
names(ActivityData)<- c("Activity")
names(FeatureData)<- FeatureNameData$V2

#combining the data to creat final data set.
Combine_Data <- cbind(SubjectData,ActivityData)
Final_Data <- cbind(FeatureData,Combine_Data)

#2:Extracts only the measurements on the mean and standard deviation for each measurement
MeanFeaturesNames<-FeatureNameData$V2[grep("mean\\(\\)|std\\(\\)",FeatureNameData$V2)]
Names<-c(as.character(MeanFeaturesNames), "Subject", "Activity")
Final_Data<-subset(Final_Data,select= Names)
str(Final_Data)

#3:Uses descriptive activity names to name the activities in the data set
activityname <- read.table(file.path(Read_file, "activity_labels.txt"),header = FALSE)

head(activityname)

#4:I have labeled the data set with their full descriptive variable names
names(Final_Data)<-gsub("^t", "time", names(Final_Data))
names(Final_Data)<-gsub("^f", "frequency", names(Final_Data))
names(Final_Data)<-gsub("Acc", "Accelerometer", names(Final_Data))
names(Final_Data)<-gsub("Gyro", "Gyroscope", names(Final_Data))
names(Final_Data)<-gsub("Mag", "Magnitude", names(Final_Data))
names(Final_Data)<-gsub("BodyBody", "Body", names(Final_Data))

names(Final_Data)

#5:I am Creating here a second,independent tidy data set and name it (tidydata.txt)
TidyData<-aggregate(. ~Subject + Activity, Final_Data, mean)
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)




