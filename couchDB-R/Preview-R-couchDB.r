
install.packages("couchDB")

library("couchDB")

#sc <- sparkR.init()
#Re-using existing Spark Context. Please stop SparkR with sparkR.stop() or restart R to create a new Spark Context
#
sqlContext <- sparkRSQL.init(sc)

myconn <- couch_http_connection(host = "b4713dfe-123e-4299-93b1-c7cd01968518-bluemix.cloudant.com", port = 443, https = TRUE,
service = "cloudant", user = "b4713dfe-123e-4299-93b1-c7cd01968518-bluemix", password = "3e4836b2172e03c084fb9b57d0c81b8e766b4e9f37ae43201e464a867f48dc74")

couch_list_databases(myconn)

print(myconn)

results <- couch_fetch(myconn, database = "reddit_regularreddit_top_comments_and_replies/_all_docs", key = NULL, myOpts = NULL)

r_json <- read.df(sqlContext, results, "json")
head(r_json)

#df <- createDataFrame(sqlContext, results)
#head(df)


print(results)

results_df <- data.frame(results)
df <- createDataFrame(sqlContext, results_df)
head(df)

printSchema(df)

keys_list <- data.frame(results)
print(keys_list[,'total_rows'])
print(keys_list[,'rows.key.3'])
rows_df_2 <- data.frame()
for (i in 1:(keys_list[,'total_rows'] - 1) ){
 print(i)
 key <- paste('rows.key.',i,sep="")
 #print(key)   
 #print(keys_list[,key])   
 docs <- couch_fetch(myconn, database = "reddit_regularreddit_top_comments_and_replies", key = keys_list[,key], myOpts = NULL)   
 #print(docs)
  rows_df <- data.frame(docs)
  
  rows_df_2 <- rbind(rows_df_2,rows_df)
    
}
  df2 <- createDataFrame(sqlContext, rows_df_2)
  #head(df2)
  printSchema(df2)
  showDF(df2)

registerTempTable(df2,"reddit")
sentimentDistribution <- list()
columns <- colnames(df2[,9:21])
#count <- list()
for(i in 1:length(columns)){
    #print(i)
    query <- paste('SELECT count(*) as sentCount FROM reddit where ',columns[i],' > 70')
    df3 <- sql(sqlContext,query)
    collected <- collect(df3)
    #print(collected)
    count[columns[i]] <- collected$sentCount
    #print('Emotion is ')
    #print(columns[i])
    #print(count)
}
#print(count)
distribution <- unlist(count)
par(las=2)
barplot(distribution, main="Histogram of comments by sentiments > 70% in IBM Reddit AMA",col=139, ylim=c(0,3),cex.axis=0.5,cex.names=0.5,ylab="Reddit comment count")


col <- colnames(df2[,9:21])
print(col)
print(length(col))

docs <- couch_fetch(myconn, database = "reddit_regularreddit_top_comments_and_replies", key = keys_list[,'rows.key.3'], myOpts = NULL)

print(docs)


