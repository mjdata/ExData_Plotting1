#plot1.R -- Exploratory Data Analysis project 1
#The dataset has 2075259 rows and 9 columns. We will only be using data from the
##dates 2007-02-01 and 2007-02-02. Missing values are coded as "?"

library(downloader, quietly = TRUE)
library(data.table, quietly = TRUE)
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

# Read only a subset, in case of big data, even though this one is only 143 MB
# (nrows * ncols * 8 / 2^20 MB)

tmp <- tbl_df(fread(fname, nrows = 3, na.strings = "?"))

x1 <- str_c(tmp$Date[1],tmp$Time[1], sep = " " )
t1 <- parse_date_time(x1, "dmy_hms", truncated = 3)
t2 <- parse_date_time("1/2/2007 00:00:01",  "dmy_hms", truncated = 3)
t3 <- parse_date_time("3/2/2007 00:00:01",  "dmy_hms", truncated = 3)
t21 <- ceiling((t2 - t1) * 24 * 60)
t32 <- ceiling((t3 - t2) * 24 * 60)
nskip <- as.integer(str_extract(t21, "[0-9]+"))     # 66637
mrows <- as.integer(str_extract(t32, "[0-9]+"))     # 2880

df <- tbl_df(fread(fname, skip = nskip, nrows = mrows, na.strings = "?"))

names(df) <- names(tmp)

# Add a new variable "datetime"

df <- df %>%
        mutate(datetime = parse_date_time(str_c(Date, Time, sep = " "),"dmy_hms", truncated = 3))

# plot 1: Open png file graphics device and plot, then close the device.

png("plot1.png", width = 480, height = 480)

hist(df$Global_active_power,
     col = "red",
     main = "Global Active Power",
     xlab = "Glabal Active Power (Killowatts)")

dev.off()
