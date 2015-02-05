
##--------------------------------------------------------------------------##
##                                                                          ##
##                     Exploratory Data Analysis                            ##
##                                                                          ##
##                            Project 1                                     ##  
##                                                                          ##
##--------------------------------------------------------------------------##

##  Plot 1

##  This is a large file.  It has over 2 million rows, of which we need less
##  than 3,000.  So, steps have been taken to make the reading more efficient.

##  This script assumes that the unzipped data file or zipped archive is present
##  in the working directory.  If the unzipped file is not present, it is extracted 
##  from the archive.  read.csv.sql() cannot use unz() as an argument, unfortunately.

filName <- "household_power_consumption.txt"

if (!file.exists(filName))
    unzip("exdata-data-household_power_consumption.zip")
    
##  Read in 1 line of the file to determine column classes.

pData <- read.table(filName, header = TRUE, nrows = 1,
                    sep =";", as.is = TRUE, na.strings ="?")

vClasses <- sapply(pData, class)      ##  Store column classes

maxLines <- 2 * 24 * 60               ##  Maximum # of observations
                                      ##  = 2 (days) * 24 (hrs) * 60 (mins)

library(sqldf)                        ##  loading sqldf package

##  Reading file via SQLite, to select only those dates of interest 
##  Telling R the colClasses makes reading files into Data Frames faster.
##  Specifying the number of rows lets R allocate memory in advance.

pData <- read.csv.sql(filName, 
                      sql = "select * from file 
                      WHERE Date = '1/2/2007' OR Date = '2/2/2007'",
                      header = TRUE, , sep = ";", 
                      colClasses = vClasses, nrows = maxLines)

png(file = "plot1.png", width = 480, height = 480)

with(pData, hist(Global_active_power, col = "red", 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)" ))

dev.off()

rm(pData)

##-------------------------------------------------------------------------##
