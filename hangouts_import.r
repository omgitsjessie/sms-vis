# Start from google hangouts instead!
# https://takeout.google.com/settings/takeout will let you download your gdata.
# Google Hangouts threads come out as JSON.  

library("rjson")
library("dplyr")
jsonData <- fromJSON(file="~/Downloads/Hangouts.json", flatten = TRUE) #this takes... a while
solversJSON <- jsonData$conversations[[52]] #Our group text is conversation 52 I think.
solversJSON2 <- jsonData$conversations[[51]] #Yup conversation 51 is us too.
#Select down again to only events.  This is where the text content lives.
eventsJSON <- solversJSON[["events"]]

#In that text chain, for all events, read all message contents and record into some other dataframe.
#Figure out sender later
newdf <- c("test")
#TODO - include more than just conversation 52.
#TODO - include the speaker
#TODO - include a timestamp
#Figure out which are just continuations of the same text chain and include those.
#This is just 1 part of 1 group text, including ONLY message content.  No images.
for (i in 1:1000) {
      temptext <- solversJSON[["events"]][[i]][["chat_message"]][["message_content"]][[1]][[1]][["text"]]
      newdf <- c(newdf, temptext)
}



#Test vis stuff to see if you're on the right track :)
#For fun make newdf into a wordcloud?
#establish corpus/term matrix
library(tm)
newdf_corpus <- newdf %>% VectorSource() %>% Corpus()

#Clean data
newdf_corpus <- newdf_corpus %>% tm_map(content_transformer(tolower)) #lowercase
newdf_corpus <- newdf_corpus %>% tm_map(removeWords, stopwords("english")) #remove stopwords
#smsCorpus <- smsCorpus %>% tm_map(stemDocument) #stemming

#documentTermMatrix
dtm <- newdf_corpus %>% DocumentTermMatrix()
tdm <- newdf_corpus %>% TermDocumentMatrix()
inspect(dtm)
findFreqTerms(dtm,10)
#Breaking out tdm terms for maximum wordcloud fun
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=T)
d <- data.frame(word=names(v), freq=v)
wordcloud(newdf_corpus)
wordcloud(d$word,d$freq,c(3,.4),4,random.order=FALSE) #most freq words (4+ freq) plotted first
