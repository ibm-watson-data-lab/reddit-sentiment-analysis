library(ibmdbR)
mycon <- idaConnect("BLUDB", "", "")
idaInit(mycon)

library(xtable)

emotions <- c('AGREEABLENESS', 'ANALYTICAL', 'ANGER', 'CONFIDENT', 'CONSCIENTIOUSNESS', 'DISGUST', 'EMOTIONAL_RANGE', 'EXTRAVERSION', 'FEAR', 'JOY', 'OPENNESS', 'SADNESS', 'TENTATIVE')

count <- list()
print("Length of emotions ", length(emotions))
for(i in 1:13){
  query <- paste('select count(*) from "REDDIT_IBMAMA_TOP_COMMENTS_ONLY" where ',emotions[i],' > 70')
  
  df <- idaQuery(query,as.is=F)
  nrow(df) 
  ncol(df) 
  df
  count[[i]] <- df[1,]
}
count

for(i in 1:13){
  query <- paste('select "AUTHOR","TEXT" from "REDDIT_IBMAMA_TOP_COMMENTS_ONLY" where ',emotions[i],' > 70')
  
  df <- idaQuery(query,as.is=F)
  nrow(df) 
  ncol(df) 
  df[1,]
  df[,1]

   comments <- data.frame(matrix(NA, nrow=count[[i]], ncol=2))
   
   comments <- data.frame(df)
   colnames(comments) <- c('AUTHOR', emotions[i])
   comments.table <- xtable(comments)
   print.xtable(comments.table, type="html", file = "RedditSentiment.html",append=TRUE)
   
}  

idaClose(mycon)


