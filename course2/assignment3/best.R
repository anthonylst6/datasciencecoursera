best <- function(state, outcome) {
        
        # Read source data
        data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        # Stop function and return error message for invalid state or outcome
        if(!(state %in% data[, 7])) {
                stop("invalid state")
        }
        if(!(outcome %in% c("heart attack", "heart failure", "pneumonia"))) {
                stop("invalid outcome")
        }
        
        # Divide hospitals according to state
        hospital_state <- split(data[, 2], data[, 7])
        
        # Define function for getting index of minimum value
        get_index <- function(a) {
                which(a == min(a, na.rm = TRUE))
        }
        
        # Writing the best function for the heart attack outcome
        if(outcome == "heart attack") {
                
                # Convert data to numeric form
                suppressWarnings(data[, 11] <- as.numeric(data[, 11]))
                
                # Get index of minimum mortality rate in each state                }
                heartattack_index <- tapply(data[, 11], data[, 7], get_index)
                
                # Return name of hospital with lowest mortality rate
                hospital_heartattack <- hospital_state[[state]][heartattack_index[[state]]]
                print(hospital_heartattack)
        }
        
        # Doing the same as above for heart failure outcome
        if(outcome == "heart failure") {
                suppressWarnings(data[, 17] <- as.numeric(data[, 17]))
                heartfailure_index <- tapply(data[, 17], data[, 7], get_index)
                hospital_heartfailure <- hospital_state[[state]][heartfailure_index[[state]]]
                print(hospital_heartfailure)
        }
        
        # Doing the same as above for pneumonia outcome
        if(outcome == "pneumonia") {
                suppressWarnings(data[, 23] <- as.numeric(data[, 23]))
                pneumonia_index <- tapply(data[, 23], data[, 7], get_index)
                hospital_pneumonia <- hospital_state[[state]][pneumonia_index[[state]]]
                print(hospital_pneumonia)
        }
}