library(ibmdbR)
mycon <- idaConnect("BLUDB", "", "")
idaInit(mycon)

emotions <- c('AGREEABLENESS', 'ANALYTICAL', 'ANGER', 'CONFIDENT', 'CONSCIENTIOUSNESS', 'DISGUST', 'EMOTIONAL_RANGE', 'EXTRAVERSION', 'FEAR', 'JOY', 'OPENNESS', 'SADNESS', 'TENTATIVE')
displaynames <- c('AGREEABLE', 'ANALYTICAL', 'ANGER', 'CONFIDENT', 'CONSCIENTIOUS', 'DISGUST', 'EMO RANGE', 'XVERSION', 'FEAR', 'JOY', 'OPEN', 'SAD', 'TENTATIVE')

count <- list()
for(i in 1:13){
  query <- paste('select count(*) from DASH014376."REDDIT_IBMAMA_TOP_COMMENTS_ONLY" where ',emotions[i],' > 70')

df <- idaQuery(query,as.is=F)
nrow(df) # print number of rows 
ncol(df) # print number of columns
df       # print dataframe
count[[i]] <- df[1,]
}
count
distribution <- unlist(count)

barplot(distribution,main="Histogram of comments by sentiments > 70% in IBM Reddit AMA",names.arg=displaynames, col=139, cex.axis=0.8,cex.names=0.7,xlab="Tone",ylab="Count")

idaClose(mycon)


