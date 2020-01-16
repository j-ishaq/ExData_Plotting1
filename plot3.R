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

png(file="plot3.png", width = 480, height = 480)

sub1 <- as.numeric(as.character(df_2days$Sub_metering_1))
sub2 <- as.numeric(as.character(df_2days$Sub_metering_2))
sub3 <- as.numeric(as.character(df_2days$Sub_metering_3))
t <- 1:length(sub1)

plot(t, sub1, type = "l", axes=FALSE,
     xlab="", ylab="Energy sub metering", frame=TRUE)
lines(t, sub2, col="red")
lines(t, sub3, col="blue")
axis(side=1, at=c(1,1441,2881), labels=c("Thu", "Fri", "Sat"))
axis(side=2, at=c(0,10,20,30))
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty=c(1,1,1), col=c("black", "red", "blue"))

dev.off()
