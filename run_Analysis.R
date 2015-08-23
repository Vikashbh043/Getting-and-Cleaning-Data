##merging data sets

unzip("Dataset.zip", list = FALSE, overwrite = TRUE, exdir = ".", unzip = "internal")
file_path <- file.path(".", "UCI HAR Dataset")
files <- list.files(file_path, recursive = TRUE )
files
dataActivityTest  <- read.table(file.path(file_path, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(file_path, "train", "Y_train.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(file_path, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(file_path, "test" , "subject_test.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path(file_path, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTest  <- read.table(file.path(file_path, "train" , "X_train.txt" ),header = FALSE)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures <- rbind(dataFeaturesTest, dataFeaturesTrain)
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(file_path, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Merge Data Completed

#Measurement of Means and standard deviation calcultaion

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)

##Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table(file.path(file_path, "activity_labels.txt"),header = FALSE)
head(Data$activity,30)

##Appropriately label the data set with descriptive variable name

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)



##Creates a second,independent tidy data set and ouput it
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

