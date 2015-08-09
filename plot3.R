#plot3.R -- Exploratory Data Analysis project 1
#The dataset has 2,075,259 rows and 9 columns. We will only be using data from the #dates 2007-02-01 and 2007-02-02. Missing values are coded as "?"

library(downloader, quietly = TRUE)
library(readr, quietly = TRUE)
library(stringr, quietly = TRUE)
library(dplyr, quietly = TRUE)
library(lubridate, quietly = TRUE)

fname <- "household_power_consumption.txt"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download and unzip if the data file is not here.

if (!file.exists(fname)) {
    print("Downloading and unzipping the data sets.")
    download(url, "exdata-data-household_power_consumption.zip")
    unzip("exdata-data-household_power_consumption.zip", fname)
}

# Read the whole data sets and then filter

df <- read_csv2(fname, na = "?") %>%
    filter(Date == "1/2/2007" | Date == "2/2/2007")

# Add a new variable "datetime"

df <- df %>%
        mutate(datetime =
        parse_date_time(str_c(Date, Time, sep = " "),"dmy_hms", truncated = 3))

xlable <- c("1/2/2007", "2/2/2007", "3/2/2007") %>%
            dmy %>%
            weekdays(abbreviate = TRUE)

# plot 3: Open png file graphics device and plot, then close the device.

png("plot3.png", width = 480, height = 480)

max_y <- max(c(df$Sub_metering_1, df$Sub_metering_2, df$Sub_metering_3))

plot(df$Sub_metering_1, type = 'n',
     ylab = "Energy sub metering",
     xaxt = "n", xlab = "", ylim = c(0, max_y))

lines(df$Sub_metering_1, type = 'l', lwd = 1)
lines(df$Sub_metering_2, type = 'l', lwd = 1, col = "red")
lines(df$Sub_metering_3, type = 'l', lwd = 1, col = "blue")

axis(1, at = c(0., 1440.5, 2881.0), label = xlable)

legend("topright", lwd = 2, cex = 1, col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()
