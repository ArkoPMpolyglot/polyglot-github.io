#Reads in data from file then subsets data for specified dates
powerDateTime <- data.table::fread(input = "household_power_consumption.txt"
                             , na.strings="?"
)


powerDateTime[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Making a date  being filtered  as POSIXct and graphed by time of day
powerDateTime[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter Dates for 2007-02-01 and 2007-02-02
powerDateTime <- powerDateTime[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

png("plot2.png", width=480, height=480)

## Plot 2
plot(x = powerDateTime[, dateTime]
     , y = powerDateTime[, Global_active_power]
     , type="l", xlab="", ylab="Global Active Power (kilowatts)")

dev.off()