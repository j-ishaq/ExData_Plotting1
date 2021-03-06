library(dplyr)
library(stringr)
library(lubridate)

rm(list=ls())

# Power consumption data file should be downloaded/copied to the current working directory
# setwd("")
textfile <- "household_power_consumption.txt"
con <- file(textfile, "r")
line1 <- readLines(con, n = 1) # extract 1st line (header)
close(con)
header <- str_split(line1, pattern = ";", simplify = TRUE)

df <- read.table(textfile, sep = ";")
df <- df[-1,]
colnames(df) <- header

date <- parse_date_time(as.character(df$Date), "dmy")
year <- as.data.frame(year(date))
month <- as.data.frame(month(date))
day <- as.data.frame(day(date))

colnames(year) <- "Year"
colnames(month) <- "Month"
colnames(day) <- "Day"

df <- cbind(year, month, day, df)
df_2days <- filter(df, df$Year==2007 & df$Month==2 & df$Day<3) # extract data of first 2 days for the month of Feb 2007

# Plot

png(file="plot2.png", width = 480, height = 480)

active_power <- as.numeric(as.character(df_2days$Global_active_power))
t <- 1:length(active_power)
plot(t, active_power, type = "l", axes=FALSE,
     xlab="", ylab="Global Active Power (kilowatts)", frame=TRUE)
axis(side=1, at=c(1,1441,2881), labels=c("Thu", "Fri", "Sat"))
axis(side=2, at=c(0,2,4,6))

dev.off()
