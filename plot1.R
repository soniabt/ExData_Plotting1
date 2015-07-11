# plot1.R
# script to download householdpowerconsumption.txt from the internet, read into workspace and create
# a histogram of Global Active Power

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

# subset data for dates 2007-02-01 abd 2007-02-02
date1 <- as.POSIXct("2007-02-01 00:00:00",tz="UCT")
date2 <- as.POSIXct("2007-02-02 23:59:00",tz="UCT")
int <- new_interval(date1, date2)

powerdat<-powerdat[powerdat$DateTime %within% int,]

# convert factors with values (non-date/time) to numeric
for (i in 2:8) {
        powerdat[,i]<-as.numeric(powerdat[,i])    
}

}
#plot 1: histogram
png(filename="plot1.png",width=480,height=480,units="px")
with(powerdat,(hist(Global_active_power,breaks=12,col="red",xaxt = 'n',xlim=c(0,6),ylim=c(0,1200),main="Global Active Power",xlab="Global Active Power (kilowatts)")))
axis(1,at=seq(0,6,by=2))
dev.off()

