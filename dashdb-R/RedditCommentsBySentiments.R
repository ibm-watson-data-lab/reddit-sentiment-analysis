library(ibmdbR)
mycon <- idaConnect("BLUDB", "", "")
idaInit(mycon)

library(xtable)

#emotions <- c('"Agreeableness"', '"Analytical"','"Anger"','"Cheerfulness"','"Confident"','"Conscientiousness"','"Negative"','"Openness"','"Tentative"')
emotions <- c('AGREEABLENESS', 'ANALYTICAL', 'ANGER', 'CONFIDENT', 'CONSCIENTIOUSNESS', 'DISGUST', 'EMOTIONAL_RANGE', 'EXTRAVERSION', 'FEAR', 'JOY', 'OPENNESS', 'SADNESS', 'TENTATIVE')

count <- list()
print("Length of emotions ", length(emotions))
for(i in 1:13){
  query <- paste('select count(*) from DASH014376."REDDIT_IBMAMA_TOP_COMMENTS_ONLY" where ',emotions[i],' > 70')
  
  df <- idaQuery(query,as.is=F)
  nrow(df) 
  ncol(df) 
  df
  count[[i]] <- df[1,]
}
count

#comments <- data.frame(matrix(NA, nrow=14, ncol=1))

#colnames(comments) <- emotions

for(i in 1:13){
  query <- paste('select "AUTHOR","TEXT" from DASH014376."REDDIT_IBMAMA_TOP_COMMENTS_ONLY" where ',emotions[i],' > 70')
  
  df <- idaQuery(query,as.is=F)
  nrow(df) 
  ncol(df) 
  df[1,]
  df[,1]
  #if(nrow(df) < 14)
  #df[nrow(df)+1:14,] = " "
#  temp <- as.data.frame(df[,1])
   comments <- data.frame(matrix(NA, nrow=count[[i]], ncol=2))
   
   #comments[,emotions[i]] <- data.frame(df[,1:2])
   comments <- data.frame(df)
   colnames(comments) <- c('AUTHOR', emotions[i])
   comments.table <- xtable(comments)
   print.xtable(comments.table, type="html", file = "RedditSentiment.html",append=TRUE)
   
}  


#comments.table <- xtable(comments)

#temp <- data.frame(matrix(NA, nrow=14, ncol=1))

#for(i in 1:13){
  #print(comments[,emotions[i]])
 # colnames(temp) <- emotions[i]
  #temp[,emotions[i]] <- comments[,emotions[i]]
  #temp.table <- xtable(temp)
  #print.xtable(temp.table, type="html", file = "Sentiment.html",append=TRUE)
 
#}
#print(comments.table)
#print(comments.table, type="html")
#print.xtable(comments.table, type="html", file = "Sentiment.html")
#print.xtable(comments.table, type="latex", file = "Sentiment.tex")



sink('/dev/null') 
idaClose(mycon)


