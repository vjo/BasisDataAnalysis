library(ggplot2)
library(dplyr)

readAndFormatData <- function(csvFile) {
  data <- read.csv(csvFile, na.strings = "")
  
  ## Convert date column as Date type
  #data <- data %>% mutate(fulldate = as.POSIXct(date, "%Y-%m-%d %H:%M", tz="UTC"))
  #data[["date"]] <- as.Date(data[["date"]])
  
  ## Add a day and time column
  ## XXX don't know why it doesn't work in one line :(
  data <- data %>% mutate(time = strftime(date, format="%H:%M", tz="UTC"))
  data <- data %>% mutate(day = strftime(date, format="%Y-%m-%d", tz="UTC"))
  
  return(data)
}

basicPlot <- function(csvFile) {
  d <- readAndFormatData(csvFile)
  
  # Filter minute I didn't move (steps = 0) and a weird value where steps = 12000, WTF?!
  d <- d %>% filter(steps > 0) %>% filter(steps < 1000)
  
  #First basic plot of the last 10000 non-null mesures
  qplot(data=tail(d,10000),x=time,y=steps,main="Steps per minute", color=day)
}

basicData <- function(csvFile) {
  data <- readAndFormatData(csvFile)
  
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