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
SCC <- readRDS("Source_Classification_code.rds")
setDT(SCC)

#Subset  Source Classifcation Code Data
vehichle_related <- grepl("Vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehichle_related <- SCC[vehichle_related, SCC]

#Subset PM25 Data
PM25_VR <- PM25[SCC %in% vehichle_related,]
PM25_VR_BC <- PM25_VR[fips == "24510"]

#Format / Summarize Data
total_PM25 <- PM25_VR_BC[,sum(Emissions), by = year][, Total_Emissions := V1][,V1 := NULL]

#Plot Data
png("plot5.png", width=480, height=480)
barplot(total_PM25[, Total_Emissions], xlab = "Years", names = total_PM25[, year] ,ylab = "Total Emissions", main = "Total Vechile Related in Baltiome Ciry Emissions by Years")
dev.off()