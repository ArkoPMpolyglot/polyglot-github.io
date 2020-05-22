## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function
## This function will help in easing computational trouble caching inverse values of matrix whenever computed to 
## variables used through the function
makeCacheMatrix <- function(x = matrix()) {
  m<- NULL
  set <- function(y){
      x <<- y
      m <<- NULL
  }
  get <- function()x
  setinverse <- function(inverse) m<<-inverse
  getinverse <- function()m
  list(set=set,get=get,setinverse = setinverse,getinverse = getinverse)
}


## Write a short comment describing this function
## This function solves the finds the inverse of a matrix using the cached value
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  m <- x$getinverse()
  if(!is.null(m)){
    message("getting cached data")
    return(m)
  }
  data <- x$get()
  m <- solve(data,...)
  x$setinverse(m)
}
