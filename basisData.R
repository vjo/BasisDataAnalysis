basisData <- function(csvFile) {
  data <- read.csv(csvFile, na.strings = "")
  
  ## Convert date column as Date type
  data[["date"]] <- as.Date(data[["date"]])

  nbMinutes <- nrow(data)
  #print(nbMinutes)
  
  statsByColName <- function(data, col) {
    ## filter NA value
    output <- data[!is.na(data[,col]), col]
    summary(output)
  }
  
  sumByColName <- function(data, col) {
    ## filter NA value
    output <- data[!is.na(data[,col]), col]
    sum(output)
  }
  
  ## Heart Rate
  hr <- statsByColName(data, "heart.rate")
  print("Heart rate:")
  print(hr)
  
  ## Sum Steps
  steps <- sumByColName(data, "steps")
  print("Sum steps:")
  print(steps)
  
  ## Skin Temp (F)
  temp <- statsByColName(data, "skin.temp")
  print("Skin temp:")
  print(temp)
}