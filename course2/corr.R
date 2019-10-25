corr <- function(directory, threshold = 0) {
        
        # set parent directory
        setwd("C:/Users/user/Desktop/datasciencecoursera/course2")
        
        # obtain list of sensor files in specdata directory
        all_files <- list.files(directory)
        
        # subset list of sensor files
        subset_files <- all_files[complete(directory)$nobs > threshold]
        
        # return vector of correlations
        if(length(subset_files) == 0) {
                correlations <- numeric(0)
                correlations
        } 
        else {  # create empty vector
                correlations <- numeric(0)
                
                # loop through files in subset list and
                #    * read the csv file
                #    * calculate correlations
                #    * append to empty vector
                for(i in 1:length(subset_files)) {
                        tempdata <- read.csv(subset_files[i])
                        no_na <- !is.na(tempdata$sulfate) & !is.na(tempdata$nitrate)
                        correlations[i] <- cor(tempdata$sulfate[no_na], tempdata$nitrate[no_na])
                }
                correlations
        }
}