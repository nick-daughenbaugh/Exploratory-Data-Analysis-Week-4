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
PM25_VR_BCLA <- PM25_VR[fips == "24510" | fips == "06037"]

#Format PM25 Data
PM25_VR_BCLA$city <- gsub("24510", "Baltimore City", PM25_VR_BCLA$fips)
PM25_VR_BCLA$city <- gsub("06037", "Los Angeles", PM25_VR_BCLA$city)

#Format / Summarize Data
total_PM25 <- PM25_VR_BCLA[,sum(Emissions), by = c("year", "city")][, Total_Emissions := V1][,V1 := NULL]

#Plot Data
png("plot6.png", width=480, height=480)
ggplot(total_PM25, aes(x = reorder(city, -Total_Emissions), y= Total_Emissions)) + 
  geom_bar( stat = "identity", position = position_dodge2() ) +
  xlab("City")+
  ylab("Total Emissions")+
  ggtitle("Vechile Emissions by Year", ) +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()
