# plot2.R -- Exploratory Data Analysis project 1
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
    unzip("exdata-data-household_power_consumption.zip", "household_power_consumption.txt")}

# Read the whole data and then filter

df <- read_csv2(fname, na = "?") %>%
        filter(Date == "1/2/2007" | Date == "2/2/2007")

# Add a new variable "datetime"

df <- df %>%
        mutate(datetime =
        parse_date_time(str_c(Date, Time, sep = " "),"dmy_hms", truncated = 3))

xlable <- c("1/2/2007", "2/2/2007", "3/2/2007") %>%
        dmy %>%
        weekdays(abbreviate = TRUE)

# Plot 2: Open png file graphics device and plot, then close the device.

png("plot2.png", width = 480, height = 480)

with(df, plot(Global_active_power,
             type = 'l',
             ylab = "Glabal Active Power (Killowatts)",
             xaxt = "n", xlab = ""))
axis(1, at = c(0., 1440.5, 2881.0), label = xlable)

dev.off()


