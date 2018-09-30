#import sms data
#android sms to text app to create a file
library(dplyr) #for pipe
library(tm) #text mining

sms_20180928 <- read.delim("~/Downloads/sms_20180928.txt", header=F)

#name cols
names(sms_20180928) <- c("Date","Time","Sender","PhoneNum","Contact","Message")
#correct type of var
sms_20180928$Date <- as.Date(sms_20180928$Date)
sms_20180928$Time <- as.character(sms_20180928$Time) 
sms_20180928$Message <- as.character(sms_20180928$Message)

#local timestamp for each message using date and time
sms_20180928$timestamp <- paste(sms_20180928$Date, sms_20180928$Time) %>% as.POSIXct(format="%Y-%m-%d %H:%M:%S")
#add categorical day of week category to bin text patterns
sms_20180928$day <- sms_20180928$Date %>% as.Date() %>% weekdays() %>% as.factor()
#Reorder factor levels for mon-sun instead of alpha order
sms_20180928$day <- factor(sms_20180928$day, levels(sms_20180928$day)[c(4,2,6,7,5,1,3)])


#replace in/out with whoever sent the text
sms_20180928$Person <- ifelse(sms_20180928$Sender == "in", "Him", "Her")

#col to grab number of characters per sms
sms_20180928$char <- nchar(sms_20180928$Message)
#count words per sms
sms_20180928$wordcount <- sapply(gregexpr("[[:alpha:]]+", sms_20180928$Message), function(x) sum(x > 0))


#establish corpus/term matrix
smsCorpus <- sms_20180928$Message %>% VectorSource() %>% Corpus()

#Clean data
smsCorpus <- smsCorpus %>% tm_map(content_transformer(tolower)) #lowercase
smsCorpus <- smsCorpus %>% tm_map(removeWords, stopwords("english")) #remove stopwords
#smsCorpus <- smsCorpus %>% tm_map(stemDocument) #stemming

#documentTermMatrix
dtm <- smsCorpus %>% DocumentTermMatrix()
inspect(dtm)
findFreqTerms(dtm,10)
###### nabbing some easy stats rq

#quick test, who has longer texts?
mean(sms_20180928[sms_20180928$Person == "Josh", "char"])
mean(sms_20180928[sms_20180928$Person == "Jessie", "char"])


#quick test, who has more words/text
mean(sms_20180928[sms_20180928$Person == "Josh", "wordcount"])
mean(sms_20180928[sms_20180928$Person == "Jessie", "wordcount"])

