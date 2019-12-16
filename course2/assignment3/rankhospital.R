rankhospital <- function(state, outcome, num = "best") {
        
        # Read source data
        data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        # Stop function and return error message for invalid state or outcome
        if(!(state %in% data[, 7])) {
                stop("invalid state")
        }
        if(!(outcome %in% c("heart attack", "heart failure", "pneumonia"))) {
                stop("invalid outcome")
        }
        
        # Retrieve data corresponding to input state
        data_state <- split(data, data[, 7])[[state]]
        
        # Return NA if num is larger than number of hospitals, define "best"
        if(class(num) == "numeric" & num > nrow(data_state)) {
                return(NA)
        }
        if(num == "best") {
                num <- 1
        }
        
        # Writing the rankhospital function for the heart attack outcome
        if(outcome == "heart attack") {
                
                # Convert data to numeric form
                suppressWarnings(data_state[, 11] <- as.numeric(data_state[, 11]))
                
                # Re-order dataframe by mortality rate and select hospital name column
                hospitals_ranked <- data_state[order(data_state[, 11], data_state[, 2]), 2]
                
                # Define "worst"
                if(num == "worst") {
                        num <- sum(!is.na(data_state[, 11]))
                }
                
                # Return name of hospital with input rank
                print(hospitals_ranked[[num]])
        }
        
        # Doing the same as above for heart failure outcome
        if(outcome == "heart failure") {
                suppressWarnings(data_state[, 17] <- as.numeric(data_state[, 17]))
                hospitals_ranked <- data_state[order(data_state[, 17], data_state[, 2]), 2]
                if(num == "worst") {
                        num <- sum(!is.na(data_state[, 17]))
                }
                print(hospitals_ranked[[num]])
        }
        
        # Doing the same as above for pneumonia outcome
        if(outcome == "pneumonia") {
                suppressWarnings(data_state[, 23] <- as.numeric(data_state[, 23]))
                hospitals_ranked <- data_state[order(data_state[, 23], data_state[, 2]), 2]
                if(num == "worst") {
                        num <- sum(!is.na(data_state[, 23]))
                }
                print(hospitals_ranked[[num]])
        }
}