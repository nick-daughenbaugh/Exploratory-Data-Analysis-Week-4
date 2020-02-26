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
coal_related <- grepl("coal", SCC[, EI.Sector], ignore.case=TRUE)
combustion_related <- grepl("comb", SCC[, SCC.Level.One], ignore.case=TRUE)
SCC_coal_comb <- SCC[coal_related & combustion_related, SCC]

#Subset PM25 Data
PM25_CC <- PM25[SCC %in% SCC_coal_comb,]

#Format / Summarize Data
total_PM25 <- PM25_CC[,sum(Emissions), by = year][, Total_Emissions := V1][,V1 := NULL]

#Plot Data
png("plot4.png", width=480, height=480)
barplot(total_PM25[, Total_Emissions], xlab = "Years", names = total_PM25[, year] ,ylab = "Total Emissions", main = "Total Coal Combustion Emissions by Years")
dev.off()
