basisData <- function(csvFile) {
  data <- read.csv(csvFile, na.strings = "")
  data[["date"]] <- as.Date(data[["date"]])

  nbMinutes <- nrow(data)
  #print(nbMinutes)
  
  printMeanMaxMin <- function(output) {
    print(length(output))
    print(mean(output))
    print(max(output))
    print(min(output))
  }
  
  meanByColName <- function(data, col) {
    ## filter NA value
    output <- data[!is.na(data[,col]), col]
    printMeanMaxMin(output)
    mean(output)
  }
  
  sumByColName <- function(data, col) {
    ## filter NA value
    output <- data[!is.na(data[,col]), col]
    printMeanMaxMin(output)
    sum(output)
  }
  
  ## Mean Heart Rate
  hr <- meanByColName(data, "heart.rate")
  print(hr)
  
  ## Sum Steps
  steps <- sumByColName(data, "steps")
  print(steps)
  
  ## Mean Skin Temp (F)
  temp <- meanByColName(data, "skin.temp")
  print(temp)
}