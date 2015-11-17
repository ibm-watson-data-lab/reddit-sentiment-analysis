library(ibmdbR)
mycon <- idaConnect("BLUDB", "", "")
idaInit(mycon)

emotions <- c('"Agreeableness"', '"Analytical"','"Anger"','"Cheerfulness"','"Confident"','"Conscientiousness"','"Negative"','"Openness"','"Tentative"')

count <- list()
print("Length of emotions ", length(emotions))
for(i in 1:9){
  query <- paste('select count(*) from DASH018643."reddit_demotable" where ',emotions[i],' > 70')

df <- idaQuery(query,as.is=F)
nrow(df) 
ncol(df) 
df
count[[i]] <- df[1,]
}
count
sink('/dev/null') 
distribution <- unlist(count)

barplot(distribution,main="Histogram of comments by sentiments > 70% in IBM Reddit AMA",names.arg=emotions, col=139, cex.axis=0.8,cex.names=0.6,xlab="Tone",ylab="Count")

sink('/dev/null') 
idaClose(mycon)

