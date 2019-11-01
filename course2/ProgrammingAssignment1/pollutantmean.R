pollutantmean <- function(directory, pollutant, id = 1:332) {
        
        # set parent directory
        setwd("C:/Users/user/Desktop/datasciencecoursera/course2/ProgrammingAssignment1")
        
        # obtain list of sensor files in specdata directory
        all_files <- list.files(directory)
        
        # subset list of sensor files
        subset_files <- all_files[id]
        
        # create empty data frame
        combined_data <- data.frame("Date" = character(0), "sulfate" = numeric(0), "nitrate" = numeric(0), "ID" = integer(0))
        
        # loop through files in subset list and
        #    * read the csv file
        #    * bind to "collector" data frame
        setwd(directory)
        for(i in 1:length(subset_files)) {
                combined_data <- rbind(combined_data, read.csv(subset_files[i]))
        }
        
        # calculate mean and return to parent environment
        mean(combined_data[[pollutant]], na.rm = TRUE)
}