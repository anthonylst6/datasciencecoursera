# This function takes two arguments (outcome and num) and returns a two-column dataframe
# containing the names of the hospital in each state with the given rank specified by num
# in having the lowest mortality rates for the input outcome

rankall <- function(outcome, num = "best") {
        
        # Read source data
        data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        # Stop function and return error message for invalid outcome
        if(!(outcome %in% c("heart attack", "heart failure", "pneumonia"))) {
                stop("invalid outcome")
        }
        
        # Define column numbers corresponding to each outcome
        if(outcome == "heart attack") x <- 11
        if(outcome == "heart failure") x <- 17
        if(outcome == "pneumonia") x <- 23
        
        # Initiate empty hospitals vector to append to and get name of states alphabetically
        hospitals <- character(0)
        states <- sort(unique(data[, 7]))
        
        # Fill into hospitals vector the corresponding hospital name with given rank
        for(i in 1:length(states)) {
                
                # Rank hospitals in ascending order for each state in the loop
                data_state <- split(data, data[, 7])[[states[i]]]
                suppressWarnings(data_state[, x] <- as.numeric(data_state[, x]))
                hospitals_ranked <- data_state[order(data_state[, x], data_state[, 2]), 2]
                
                # Append name of ranked hospital to hospitals vector
                if(class(num) == "numeric" & num > nrow(data_state)) {
                        hospitals[i] <- NA
                        next
                }
                if(num == "best") {
                        hospitals[i] <- hospitals_ranked[[1]]
                        next
                }
                if(num == "worst") {
                        hospitals[i] <- hospitals_ranked[[sum(!is.na(data_state[, x]))]]
                        next
                }
                hospitals[i] <- hospitals_ranked[[num]]
        }
        
        # Return data frame
        data.frame("hospital" = hospitals, "state" = states)
}