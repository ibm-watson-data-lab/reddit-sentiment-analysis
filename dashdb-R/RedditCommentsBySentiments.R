library(ibmdbR)
mycon <- idaConnect("BLUDB", "", "")
idaInit(mycon)

emotions <- c('"Agreeableness"', '"Analytical"','"Anger"','"Cheerfulness"','"Confident"','"Conscientiousness"','"Negative"','"Openness"','"Tentative"')
comments <- data.frame(matrix(NA, nrow=14, ncol=9))

colnames(comments) <- emotions

for(i in 1:9){
  query <- paste('select "text" from DASH018643."reddit_demotable" where ',emotions[i],' > 70')
  
  df <- idaQuery(query,as.is=F)
  nrow(df) 
  ncol(df) 
  df[1,]
  df[,1]
  if(nrow(df) < 14)
  df[nrow(df)+1:14,] = " "
#  temp <- as.data.frame(df[,1])
   comments[,emotions[i]] <- data.frame(df[,1])
}  

library(xtable)

comments.table <- xtable(comments)
print(comments.table)
print(comments.table, type="html")
print.xtable(comments.table, type="html", file = "Sentiment.html")
print.xtable(comments.table, type="latex", file = "Sentiment.tex")

sink('/dev/null') 
idaClose(mycon)

