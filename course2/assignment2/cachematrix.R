## These functions operate together to first create a list of functions which
## stores details of a matrix and its inverse which can be retrieved later.
## The idea is that finding the inverse of a matrix is often a computationally
## expensive operation and so caching it can save memory and time

## This function creates a list with functions which:
## 1. set the value of the matrix
## 2. get the value of the matrix
## 3. set the value of the inverse
## 4. get the value of the inverse
## such that the matrix and its inverse is cacheable given additional steps

makeCacheMatrix <- function(x = matrix()) {
        i <- NULL
        set <- function(y) {
                x <<- y
                i <<- NULL
        }
        get <- function() x
        setinverse <- function(inverse) i <<- inverse
        getinverse <- function() i
        list(set = set, get = get,
             setinverse = setinverse,
             getinverse = getinverse)
}


## This function here either retrieves the cached inverse if it exists otherwise
## it calculates the inverse of a created matrix and caches it


cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
        i <- x$getinverse()
        if(!is.null(i)) {
                message("getting cached data")
                return(i)
        }
        data <- x$get()
        i <- solve(data, ...)
        x$setinverse(i)
        i
}