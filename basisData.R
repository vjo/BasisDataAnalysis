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
  
  ## Filter a weird value where steps = 12000, WTF?!
  data <- data %>% filter(steps < 1000)
  
  return(data)
}

stepsPointCloudColor <- function(d) {
  x_scale <- genHourScale()
  
  ## First basic plot
  ## x = 24hours minutes by minutes
  ## y = steps per minute for a given minute of the day
  ggplot(d, aes(time, steps, color=day)) +
    geom_point(size=2) +
    theme(legend.position="none") +
    labs(x="Time 00:00 to 24:00 (UTC)", y="Steps / min", title="Steps per minute over 2 years") + 
    scale_x_discrete(breaks=x_scale)
}

stepsPointCloudMono <- function(d) {
  x_scale <- genHourScale()
  
  ggplot(d, aes(time, steps)) +
    geom_point(fill="black", alpha=3/10, size=2) +
    labs(x="Time 00:00 to 24:00 (UTC)", y="Steps / min", title="Steps per minute over 2 years") + 
    scale_x_discrete(breaks=x_scale)
}

heartRatePointCloudMono <- function(d) {
  x_scale <- genHourScale()
  
  ggplot(d, aes(time, heart.rate)) +
    geom_point(fill="black", alpha=3/10, size=2) +
    labs(x="Time 00:00 to 24:00 (UTC)", y="BPM", title="BPM over 24h (2 years)") + 
    scale_x_discrete(breaks=x_scale)
}

dailyStepsHistogram <- function(d) {
  daysOfWeek <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  
  ggplot(d, aes(as.Date(day), steps, fill=strftime(day, format="%A"))) + 
    geom_bar(stat="identity") + 
    labs(x="Day", y="Steps / day", title="Steps per day over 2 years") +
    scale_fill_discrete(name="Days of the week",
                        breaks=daysOfWeek) +
    scale_x_date(breaks="2 months")
}

stepsHistogram <- function(d) {
  x_scale <- genHourScale()
  
  ggplot(d, aes(time, steps)) + 
    geom_line(stat="identity", fill="black", alpha=1/10) + 
    labs(x="Time 00:00 to 24:00 (UTC)", y="Steps / min", title="Steps per minute over days") + 
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
  #stepsPointCloudColor(d)
  #stepsPointCloudMono(d)
  #heartRatePointCloudMono(d)
  #stepsHistogram(d)
  dailyStepsHistogram(d)
}