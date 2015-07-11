# plot2.R
# script to download householdpowerconsumption.txt from the internet, read into workspace and create
# temporal plot of Global Active Power 2007-02-01 and 2007-02-02

library(lubridate)
library(dplyr)

# download and reading into R
if (!file.exists("household_power_consumption.txt")) {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        zipfile <- "household_power_consumption.zip"
        txtfile <- "household_power_consumption.txt"
        download.file(fileUrl,zipfile,method="curl")
        unzip(zipfile,txtfile)
}
if (!exists("powerdat")) {
        powerdatin<-read.csv2("household_power_consumption.txt",sep=";",header=TRUE,na.strings="?",colClasses="character")



# preparing data to be used for plotting
powerdatDateTime <- powerdatin %>% mutate(DateTime=dmy_hms(paste(Date,Time)))
powerdat <- select(powerdatDateTime,DateTime,Global_active_power:Sub_metering_3)
rm(powerdatin)
rm(powerdatDateTime)

# subset data for dates 2007-02-01 and 2007-02-02
date1 <- as.POSIXct("2007-02-01 00:00:00",tz="UCT")
date2 <- as.POSIXct("2007-02-02 23:59:00",tz="UCT")
int <- new_interval(date1, date2)

powerdat<-powerdat[powerdat$DateTime %within% int,]

# convert factors with values (non-date/time) to numeric
for (i in 2:8) {
        powerdat[,i]<-as.numeric(powerdat[,i])    
}

}

#plot 2: 
png(filename="plot2.png",width=480,height=480,units="px")
with(powerdat,plot(DateTime,Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)"))
dev.off()

