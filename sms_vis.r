library(ggplot2)
library(dplyr)

#bar chart over day of week, who texts the most?
ggplot(data = sms_20180928, aes(x=day, fill=Person)) + 
  geom_bar(stat="count", position=position_dodge()) + 
  xlab("Day of Week") + ylab("Num Texts Sent") + 
  ggtitle("Texts sent, by person and day of week")
#bar chart over hour of day, when are we texting the most?
ggplot(data=sms_20180928, aes(x=hour, fill=Person)) + 
  geom_bar(stat="count", position=position_dodge()) + 
  xlab("Hour of Day") + ylab("Num Texts Sent") + 
  ggtitle("Texts sent, by person and hour of day")


#TODO scatterplot of words most likely to be said by him/her
#TODO wordclouds (us, him, her)
#TODO timeseries for frequency trend by day of week /  time of day
#TODO distribution of text lengths
#TODO who texts first in a day? last?
#TODO who is most active or responsive?
#TODO mean time between texts
#TODO emoji frequency?