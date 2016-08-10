
install.packages("couchDB") ### One time only as the package is installed for the user

library("couchDB")

sqlContext <- sparkRSQL.init(sc)

myconn <- couch_http_connection(host = "XXXX", port = 443, https = TRUE,
service = "cloudant", user = "XXXX", password = "XXXX")

couch_list_databases(myconn)

print(myconn)

results <- couch_fetch(myconn, database = "reddit_regularreddit_top_comments_and_replies/_all_docs", key = NULL, myOpts = NULL)
results_df <- data.frame(results)
df <- createDataFrame(sqlContext, results_df)

printSchema(df)

typeof(results)

print(results)

keys_list <- data.frame(results)
print(keys_list[,'total_rows'])
print(keys_list[,'rows.key.3'])
rows_df_2 <- data.frame()

    for (i in 1:(keys_list[,'total_rows'] - 1) ){
        print(i)
        key <- paste('rows.key.',i,sep="")
        docs <- couch_fetch(myconn, database = "reddit_regularreddit_top_comments_and_replies", key = keys_list[,key], myOpts = NULL)   
 
        rows_df <- data.frame(docs)  
        rows_df_2 <- rbind(rows_df_2,rows_df)
    
    }

df2 <- createDataFrame(sqlContext, rows_df_2)
printSchema(df2)
showDF(df2)

registerTempTable(df2,"reddit")
sentimentDistribution <- list()
columns <- colnames(df2[,9:21])
count <- list()
    
    for(i in 1:length(columns)){
        query <- paste('SELECT count(*) as sentCount FROM reddit where ',columns[i],' > 70')
        df3 <- sql(sqlContext,query)
        collected <- collect(df3)
        count[columns[i]] <- collected$sentCount
    }

distribution <- unlist(count)
par(las=2)
barplot(distribution, main="Histogram of comments by sentiments > 70% in a MongoDB reddit",col=139, ylim=c(0,2.5),cex.axis=0.5,cex.names=0.5,ylab="Reddit comment count")

for(i in 1:length(columns)){
    columnset <- filter(df2,paste(columns[i], ' > 70') )
    if(count(columnset) > 0){
    print('-----------------------------------------------------------------------------')
    print(columns[i])
    print('-----------------------------------------------------------------------------')
    comments <- as.data.frame(select(columnset,"author","text")) ## not helpful print prints columnwise
        for(j in 1:length(comments)){
            print(paste("Author: ",comments[j,1]))
            print(paste("Comments: ",comments[j,2]))
        }
    }
}


