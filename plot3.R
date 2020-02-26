# Load Packages
library("data.table")
library(ggplot2)

# Disable Scientific Notation
options(scipen=999)

# download data
if ( ! file.exists("summarySCC_PM25.rds")  ) {
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "raw_data.zip")
  unzip("raw_data.zip")
  file.remove("raw_data.zip")
}

#Read-in Data / Set as Data Table
PM25 <- readRDS("summarySCC_PM25.rds")
setDT(PM25)

#Subset data
PM25_BC <- PM25[fips == "24510",]

#Format / Summarize Data
total_PM25 <- PM25_BC[,sum(Emissions), by = c("year", "type")][, Total_Emissions := V1][,V1 := NULL]

#Plot Data
png("plot3.png", width=480, height=480)
ggplot(total_PM25, aes(x = reorder(type, -Total_Emissions), y= Total_Emissions)) + 
  geom_bar( stat = "identity", position = position_dodge2() )
dev.off()
