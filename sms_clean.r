#import sms data
#android sms to text app to create a file

sms_20180928 <- read.delim("~/Downloads/sms_20180928.txt", header=F)

#name cols
names(sms_20180928) <- c("Date","Time","Sender","PhoneNum","Contact","Message")
#correct type of var
sms_20180928$Date <- as.Date(sms_20180928$Date)
sms_20180928$Time <- as.character(sms_20180928$Time) 
sms_20180928$Message <- as.character(sms_20180928$Message)

#TODO Make a real UTC timestamp for each message using date and time

#replace in/out with whoever sent the text
sms_20180928$Person <- ifelse(sms_20180928$Sender == "in", "Josh", "Jessie")

#col to grab number of characters
sms_20180928$char <- nchar(sms_20180928$Message)

#quick test, who has longer texts?
mean(sms_20180928[sms_20180928$Person == "Josh", "char"])
mean(sms_20180928[sms_20180928$Person == "Jessie", "char"])

#count words
sms_20180928$wordcount <- sapply(gregexpr("[[:alpha:]]+", sms_20180928$Message), function(x) sum(x > 0))

#same, who has more words/text
mean(sms_20180928[sms_20180928$Person == "Josh", "wordcount"])
mean(sms_20180928[sms_20180928$Person == "Jessie", "wordcount"])

#wordcloud