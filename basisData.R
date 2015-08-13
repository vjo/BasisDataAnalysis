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

basicPlot <- function(d) {
  ## Filter a weird value where steps = 12000, WTF?!
  d <- d %>% filter(steps < 1000)
  
  x_scale <- genHourScale()
  
  ## First basic plot
  ## x = 24hours minutes by minutes
  ## y = steps per minute for a given minute of the day
  qplot(data=d, x=time, y=steps, main="Steps per minute over 2 years", color=day) + 
    labs(x="Time 00:00 to 24:00", y="Steps / min", title="Steps per minute over days") + 
    scale_x_discrete(breaks=x_scale)
}

histogram <- function(d) {
  ## Filter a weird value where steps = 12000, WTF?!
  d <- d %>% filter(steps < 1000)

  x_scale <- genHourScale()
  
  ggplot(data=d, aes(x=time, y=steps)) + 
    geom_bar(stat="identity", fill="black", alpha=1/10) + 
    labs(x="Time 00:00 to 24:00", y="Steps / min", title="Steps per minute over days") + 
    scale_x_discrete(breaks=x_scale) 
}

genHourScale <- function() {
  c <- seq(
    from=as.POSIXct("00:00", format="%H:%M", tz="UTC"),
    by="2 hour",
    length.out = 12
  )
  strftime(c, format="%H:%M")
}

basicData <- function(d) {

  nbMinutes <- nrow(d)
  #print(nbMinutes)
  
  statsByColName <- function(d, col) {
    ## filter NA value
    output <- d[!is.na(d[,col]), col]
    summary(output)
  }
  
  sumByColName <- function(d, col) {
    ## filter NA value
    output <- d[!is.na(d[,col]), col]
    sum(output)
  }
  
  ## Heart Rate
  hr <- statsByColName(d, "heart.rate")
  print("Heart rate:")
  print(hr)
  
  ## Sum Steps
  steps <- sumByColName(d, "steps")
  print("Sum steps:")
  print(steps)
  
  ## Skin Temp (F)
  temp <- statsByColName(d, "skin.temp")
  print("Skin temp:")
  print(temp)
}

basisData <- function(csvFile){
  d <- readAndFormatData(csvFile)
  
  #basicData(d)
  basicPlot(d)
  #histogram(d) ## XXX working on it
}