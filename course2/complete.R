complete <- function(directory, id = 1:332) {
        
        # set parent directory
        setwd("C:/Users/user/Desktop/datasciencecoursera/course2")
        
        # obtain list of sensor files in specdata directory
        all_files <- list.files(directory)
        
        # subset list of sensor files
        subset_files <- all_files[id]
        
        # create empty vectors
        id <- integer(0)
        nobs <- integer(0)
        
        # loop through files in subset list and
        #    * read the csv file
        #    * append to empty vectors
        setwd(directory)
        for(i in 1:length(subset_files)) {
                tempdata <- read.csv(subset_files[i])
                id[i] <- tempdata$ID[1]
                nobs[i] <- sum(!is.na(tempdata$sulfate) & !is.na(tempdata$nitrate))
        }
        
        # create dataframe
        data.frame(id, nobs)
}