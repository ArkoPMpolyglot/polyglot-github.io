powerDateTime <- data.table::fread(input = "household_power_consumption.txt"
                                   , na.strings="?"
)


powerDateTime[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Making a POSIXct date capable of being filtered and graphed by time of day
powerDateTime[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter Dates for 2007-02-01 and 2007-02-02
powerDateTime <- powerDateTime[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

png("plot3.png", width=480, height=480)

# Plot 3
plot(powerDateTime[, dateTime], powerDateTime[, Sub_metering_1], type="l", xlab="", ylab="Energy sub metering")
lines(powerDateTime[, dateTime], powerDateTime[, Sub_metering_2],col="red")
lines(powerDateTime[, dateTime], powerDateTime[, Sub_metering_3],col="blue")
#Annotation
legend("topright"
       , col=c("black","red","blue")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       ,lty=c(1,1), lwd=c(1,1))

dev.off()